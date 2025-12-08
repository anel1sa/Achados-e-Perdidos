import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/usuario_remote_datasource.dart';
import '../DTOs/usuario_dto.dart';
import '../DTOs/campus_dto.dart';
import '../DTOs/usuario_dto.dart';
import '../../core/network/dio_client.dart';
import '../../core/cache/cache_service.dart';
import 'campus_service.dart';

/// Service para gerenciamento de usuários
/// Conecta os datasources às páginas
class UsuarioService {
  late final UsuarioRemoteDataSource _dataSource;
  late final CampusService _campusService;

  UsuarioService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = UsuarioRemoteDataSource(client);
    _campusService = CampusService(dio: client, secureStorage: secureStorage);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Busca todos os usuários
  Future<List<UsuarioDTO>> getAllUsuarios() async {
    return await _dataSource.getAll();
  }

  /// Busca usuários ativos
  Future<List<UsuarioDTO>> getUsuariosAtivos() async {
    return await _dataSource.getAllActive();
  }

  /// Busca usuário por ID (com cache até logout)
  Future<UsuarioDTO> getUsuarioById(int id) async {
    return await CacheService.getUserProfile<UsuarioDTO>(
      userId: id.toString(),
      fetchFromApi: () => _dataSource.getById(id),
      fromJson: (json) => UsuarioDTO.fromJson(json),
      toJson: (user) => user.toJson(),
    ) ?? await _dataSource.getById(id);
  }

  /// Busca usuário por email
  Future<UsuarioDTO> getUsuarioByEmail(String email) async {
    return await _dataSource.getByEmail(email);
  }

  /// Cria um novo usuário
  Future<UsuarioDTO> createUsuario(UsuarioCreateDTO dto) async {
    return await _dataSource.create(dto);
  }

  /// Atualiza um usuário (invalida cache do perfil)
  Future<UsuarioDTO> updateUsuario(int id, UsuarioUpdateDTO dto) async {
    final user = await _dataSource.update(id, dto);
    await CacheService.invalidateUserProfile(id.toString());
    return user;
  }

  /// Altera a senha do usuário
  Future<void> alterarSenha(int id, AlterarSenhaDTO dto) async {
    return await _dataSource.changePassword(id, dto);
  }

  /// Deleta um usuário
  Future<void> deleteUsuario(int id) async {
    return await _dataSource.delete(id);
  }

  /// Busca todos os campus (delega para CampusService)
  /// Mantido para compatibilidade com código existente
  Future<List<CampusDTO>> getCampi() async {
    return await _campusService.getAllCampus();
  }

  /// Cadastra um novo usuário (alias para createUsuario)
  /// Nota: Este método é um wrapper para createUsuario para compatibilidade
  Future<Map<String, dynamic>> cadastrarUsuario(UsuarioCreateDTO dto) async {
    try {
      final usuario = await createUsuario(dto);
      return {
        'sucesso': true,
        'mensagem': 'Usuário cadastrado com sucesso',
        'usuario': usuario,
      };
    } on FormatException catch (e) {
      // Erro de parse JSON - API não retornou o formato esperado
      return {
        'sucesso': true, // Cadastro foi feito (201), mas formato incorreto
        'mensagem': 'Cadastro realizado! Faça login para continuar.',
        'erros': {'format': 'A API retornou um formato inesperado: ${e.message}'},
      };
    } catch (e) {
      return {
        'sucesso': false,
        'mensagem': e.toString(),
        'erros': {},
      };
    }
  }

  /// Cadastra um novo aluno usando o endpoint específico
  /// POST /api/usuarios/aluno
  Future<Map<String, dynamic>> cadastrarAluno(UsuarioCreateDTO dto) async {
    try {
      final usuario = await _dataSource.createAluno(dto);
      return {
        'sucesso': true,
        'mensagem': 'Aluno cadastrado com sucesso',
        'usuario': usuario,
      };
    } on FormatException catch (e) {
      return {
        'sucesso': true,
        'mensagem': 'Cadastro realizado! Faça login para continuar.',
        'erros': {'format': 'A API retornou um formato inesperado: ${e.message}'},
      };
    } catch (e) {
      return {
        'sucesso': false,
        'mensagem': e.toString(),
        'erros': {},
      };
    }
  }

  /// Cadastra um novo servidor usando o endpoint específico
  /// POST /api/usuarios/servidor
  Future<Map<String, dynamic>> cadastrarServidor(UsuarioCreateDTO dto) async {
    try {
      final usuario = await _dataSource.createServidor(dto);
      return {
        'sucesso': true,
        'mensagem': 'Servidor cadastrado com sucesso',
        'usuario': usuario,
      };
    } on FormatException catch (e) {
      return {
        'sucesso': true,
        'mensagem': 'Cadastro realizado! Faça login para continuar.',
        'erros': {'format': 'A API retornou um formato inesperado: ${e.message}'},
      };
    } catch (e) {
      return {
        'sucesso': false,
        'mensagem': e.toString(),
        'erros': {},
      };
    }
  }
}


