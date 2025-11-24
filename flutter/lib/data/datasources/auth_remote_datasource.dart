import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/auth_models.dart';
import '../DTOs/usuario_dto.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// Login com email e senha
  /// POST /api/usuarios/login
  Future<LoginResponseDTO> login({
    required String email,
    required String senha,
  }) async {
    try {
      // Validação prévia
      final emailTrimmed = email.trim();
      final senhaTrimmed = senha.trim();
      
      if (emailTrimmed.isEmpty) {
        throw ValidationException(message: 'Email é obrigatório');
      }
      if (senhaTrimmed.isEmpty) {
        throw ValidationException(message: 'Senha é obrigatória');
      }
      
      final loginRequest = LoginRequestDTO(
        email: emailTrimmed,
        senha: senhaTrimmed,
        plataforma: 'mobile',
      );
      
      final requestData = loginRequest.toJson();
      print('[AuthRemoteDataSource] Dados do login: $requestData');
      print('[AuthRemoteDataSource] Email no requestData: ${requestData['Email_Usuario']}');
      print('[AuthRemoteDataSource] Email está vazio? ${requestData['Email_Usuario']?.toString().isEmpty ?? true}');
      
      final response = await _dio.post(
        ApiConstants.login,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return LoginResponseDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao fazer login',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Trata erros de validação (400)
      if (e.response?.statusCode == 400) {
        final errorMessage = e.response?.data['message'] as String? ?? 
                            e.response?.data['error'] as String? ?? 
                            'Dados inválidos';
        throw ValidationException(message: errorMessage);
      }
      
      // Trata erros de autenticação (401, 403)
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthenticationException(
          message: e.response?.data['message'] ?? 'Credenciais inválidas',
        );
      }
      
      // Trata outros erros
      if (e.error is AuthenticationException || e.error is ValidationException) {
        rethrow;
      }
      
      throw AuthenticationException(
        message: e.response?.data['message'] ?? 'Erro ao fazer login',
      );
    } on ValidationException {
      rethrow;
    } catch (e) {
      if (e is ValidationException || e is AuthenticationException) {
        rethrow;
      }
      throw AuthenticationException(
        message: 'Erro inesperado ao fazer login: $e',
      );
    }
  }

  /// Login com Google OAuth2 usando idToken JWT do Google Sign-In nativo
  /// 
  /// NOTA: Este método envia o idToken JWT obtido do Google Sign-In nativo do Flutter.
  /// O backend deve aceitar POST com JSON contendo o idToken.
  /// 
  /// Se o backend retornar HTML (página de login do Google), significa que está
  /// configurado apenas para fluxo OAuth2 web (redirecionamento). Nesse caso,
  /// será necessário:
  /// 1. Criar um endpoint alternativo no backend que aceite idToken via POST
  /// 2. Ou usar o fluxo web OAuth2 com WebView
  /// 
  /// POST /api/google-auth/login
  /// Body: { "idToken": "..." } ou { "code": "..." } ou { "token": "..." }
  Future<LoginResponseDTO> loginWithGoogle(String idToken) async {
    try {
      // Valida se o token não está vazio
      if (idToken.trim().isEmpty) {
        throw ValidationException(message: 'Token do Google não pode ser vazio');
      }

      print('[AuthRemoteDataSource] Enviando Google ID Token para login...');
      print('[AuthRemoteDataSource] Token length: ${idToken.length}');
      
      // Tenta enviar como idToken primeiro, depois como code
      final requestData = GoogleAuthRequestDTO(idToken: idToken).toJson();
      print('[AuthRemoteDataSource] Request data: $requestData');
      
      final response = await _dio.post(
        ApiConstants.googleAuthLogin,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Verifica se a resposta é HTML (erro de configuração do backend)
      if (response.data is String && (response.data as String).contains('<!DOCTYPE') || 
          (response.data is String && (response.data as String).contains('<html'))) {
        throw ServerException(
          message: 'O backend retornou HTML em vez de JSON. Verifique a configuração do endpoint /api/google-auth/login',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('[AuthRemoteDataSource] Login com Google bem-sucedido');
        print('[AuthRemoteDataSource] Response data type: ${response.data.runtimeType}');
        
        // Verifica se é um Map antes de fazer parse
        if (response.data is Map<String, dynamic>) {
          return LoginResponseDTO.fromJson(response.data as Map<String, dynamic>);
        } else if (response.data is String) {
          // Se for string, pode ser token direto ou JSON string
          final jsonData = response.data as String;
          if (jsonData.startsWith('{')) {
            // É JSON string, tenta fazer parse
            throw ServerException(
              message: 'Backend retornou JSON como string. Formato não suportado.',
              statusCode: response.statusCode,
            );
          } else {
            // É token direto (improvável, mas possível)
            return LoginResponseDTO(
              token: jsonData,
              tokenType: 'Bearer',
              expiresIn: 3600,
              id: 0,
              nome: '',
              email: '',
            );
          }
        } else {
          throw ServerException(
            message: 'Formato de resposta inesperado do backend: ${response.data.runtimeType}',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Erro ao fazer login com Google',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('[AuthRemoteDataSource] Erro no login com Google: ${e.response?.statusCode}');
      print('[AuthRemoteDataSource] Mensagem: ${e.response?.data}');
      
      // Trata erros de validação (400)
      if (e.response?.statusCode == 400) {
        final errorMessage = e.response?.data['message'] as String? ?? 
                            e.response?.data['error'] as String? ?? 
                            'Token do Google inválido';
        throw ValidationException(message: errorMessage);
      }
      
      // Trata erros de autenticação (401, 403)
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw AuthenticationException(
          message: e.response?.data['message'] ?? 
                  'Falha na autenticação com Google. Verifique se o usuário está cadastrado.',
        );
      }
      
      // Trata erro 404 (usuário não encontrado)
      if (e.response?.statusCode == 404) {
        throw NotFoundException(
          message: e.response?.data['message'] ?? 
                  'Usuário não encontrado. Cadastre-se primeiro!',
        );
      }
      
      if (e.error is AuthenticationException || 
          e.error is ValidationException || 
          e.error is NotFoundException) {
        rethrow;
      }
      
      throw AuthenticationException(
        message: e.response?.data['message'] ?? 
                e.response?.data['error'] ?? 
                'Erro ao autenticar com Google. Tente novamente.',
      );
    } catch (e) {
      if (e is AuthenticationException || 
          e is ValidationException || 
          e is NotFoundException) {
        rethrow;
      }
      throw AuthenticationException(
        message: 'Erro inesperado ao autenticar com Google: $e',
      );
    }
  }

  /// Callback do Google OAuth2
  /// GET /api/google-auth/callback
  Future<String> googleAuthCallback(String code) async {
    try {
      final response = await _dio.get(
        ApiConstants.googleAuthCallback,
        queryParameters: {'code': code},
      );

      if (response.statusCode == 200) {
        return response.data['token'] as String;
      } else {
        throw ServerException(
          message: 'Erro no callback do Google',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw AuthenticationException(
        message: e.response?.data['message'] ?? 'Erro no callback do Google',
      );
    }
  }
}

