import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/auth_models.dart';

class GoogleAuthRemoteDataSource {
  final Dio _dio;

  GoogleAuthRemoteDataSource(this._dio);

  /// GET /api/google-auth/login - Obtém URL de autorização do Google
  /// O backend pode retornar:
  /// - 302/301 redirect com Location header (URL do Google)
  /// - 200 com HTML (página de login do Google)
  /// - 200 com URL no body
  Future<String> getGoogleAuthUrl() async {
    try {
      print('[GoogleAuthDataSource] Fazendo GET em ${ApiConstants.googleAuthLogin}');
      
      final response = await _dio.get(
        ApiConstants.googleAuthLogin,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('[GoogleAuthDataSource] Status code: ${response.statusCode}');
      print('[GoogleAuthDataSource] Headers: ${response.headers.map}');

      // O backend retorna um redirect (302/301), pegamos a URL do header Location
      if (response.statusCode == 302 || response.statusCode == 301) {
        final location = response.headers.value('location');
        if (location != null && location.isNotEmpty) {
          print('[GoogleAuthDataSource] URL obtida do redirect: $location');
          return location;
        }
      }

      // Se retornar 200, pode ser HTML ou URL
      if (response.statusCode == 200) {
        if (response.data is String) {
          final data = response.data as String;
          // Se for HTML, extrai a URL do Google do HTML
          if (data.contains('accounts.google.com')) {
            // Tenta extrair URL do HTML
            final regex = RegExp(r'https://accounts\.google\.com[^\s"<>]+');
            final match = regex.firstMatch(data);
            if (match != null) {
              print('[GoogleAuthDataSource] URL extraída do HTML: ${match.group(0)}');
              return match.group(0)!;
            }
          }
          // Se não for HTML, assume que é a URL diretamente
          print('[GoogleAuthDataSource] URL do body: $data');
          return data;
        }
      }

      // Se chegou aqui, tenta construir a URL baseada na base URL
      final baseUrl = ApiConstants.BASE_URL;
      final authUrl = '$baseUrl${ApiConstants.googleAuthLogin}';
      print('[GoogleAuthDataSource] Usando URL completa: $authUrl');
      return authUrl;
    } on DioException catch (e) {
      print('[GoogleAuthDataSource] Erro DioException: ${e.message}');
      print('[GoogleAuthDataSource] Status: ${e.response?.statusCode}');
      print('[GoogleAuthDataSource] Data: ${e.response?.data}');
      
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao iniciar autenticação Google',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/google-auth/callback?code={code} - Processa callback do Google
  Future<LoginResponseDTO> handleGoogleCallback(String authorizationCode) async {
    try {
      final response = await _dio.get(
        ApiConstants.googleAuthCallback,
        queryParameters: {'code': authorizationCode},
      );

      if (response.statusCode == 200) {
        return LoginResponseDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao processar callback do Google',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException(
          message: e.response?.data['message'] ?? 'Usuário não encontrado ou inativo',
        );
      }
      if (e.response?.statusCode == 400) {
        throw ValidationException(
          message: e.response?.data['message'] ?? 'Código de autorização inválido',
        );
      }
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao autenticar com Google',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Login completo com Google (fluxo simplificado)
  /// Retorna a URL de autorização que deve ser aberta no navegador
  Future<String> initiateGoogleLogin() async {
    return await getGoogleAuthUrl();
  }
}
