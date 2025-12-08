import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';
import '../../core/network/dio_client.dart';

/// Service para autenticação
/// Conecta os datasources às páginas
class AuthService {
  late final AuthRemoteDataSource _dataSource;

  AuthService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = AuthRemoteDataSource(client);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Login com email e senha
  Future<LoginResponseDTO> login({
    required String email,
    required String senha,
  }) async {
    return await _dataSource.login(email: email, senha: senha);
  }

  /// Login com Google OAuth2
  Future<LoginResponseDTO> loginWithGoogle(String code) async {
    return await _dataSource.loginWithGoogle(code);
  }

  /// Callback do Google OAuth2
  Future<String> googleAuthCallback(String code) async {
    return await _dataSource.googleAuthCallback(code);
  }
}

