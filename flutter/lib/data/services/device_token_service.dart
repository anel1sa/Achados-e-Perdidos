import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/device_token_remote_datasource.dart';
import '../DTOs/device_token_dto.dart';
import '../../core/network/dio_client.dart';

/// Service para gerenciamento de tokens de dispositivos (Push Notifications)
class DeviceTokenService {
  late final DeviceTokenRemoteDataSource _dataSource;

  DeviceTokenService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = DeviceTokenRemoteDataSource(client);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Registra ou atualiza token de dispositivo (método simplificado)
  /// Extrai usuarioId automaticamente do JWT no header Authorization
  Future<DeviceTokenDTO> registerOrUpdateToken({
    required String token,
    required String plataforma,
  }) async {
    return await _dataSource.registerOrUpdateToken(
      token: token,
      plataforma: plataforma,
    );
  }

  /// Cria token de dispositivo (método completo)
  Future<DeviceTokenDTO> createDeviceToken(DeviceTokenCreateDTO dto) async {
    return await _dataSource.create(dto);
  }

  /// Busca tokens ativos de um usuário
  Future<List<DeviceTokenDTO>> getActiveTokensByUsuarioId(int usuarioId) async {
    return await _dataSource.getActiveTokensByUsuarioId(usuarioId);
  }

  /// Deleta token de dispositivo
  Future<void> deleteDeviceToken(int id) async {
    return await _dataSource.delete(id);
  }
}
