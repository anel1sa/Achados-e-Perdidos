import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/device_token_dto.dart';

class DeviceTokenRemoteDataSource {
  final Dio _dio;

  DeviceTokenRemoteDataSource(this._dio);

  /// POST /api/device-tokens/register (Endpoint simplificado)
  Future<DeviceTokenDTO> registerOrUpdateToken({
    required String token,
    required String plataforma,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.deviceTokensRegister,
        queryParameters: {
          'token': token,
          'plataforma': plataforma,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeviceTokenDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao registrar token de dispositivo',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException(message: 'Token JWT inválido ou expirado');
      }
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao registrar token',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/device-tokens (Método completo)
  Future<DeviceTokenDTO> create(DeviceTokenCreateDTO dto) async {
    try {
      final response = await _dio.post(
        ApiConstants.deviceTokens,
        data: dto.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return DeviceTokenDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao criar token de dispositivo',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao criar token',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/device-tokens/usuario/{usuarioId}/active
  Future<List<DeviceTokenDTO>> getActiveTokensByUsuarioId(int usuarioId) async {
    try {
      final response = await _dio.get(
        ApiConstants.deviceTokensActiveByUsuario(usuarioId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => DeviceTokenDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar tokens ativos',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar tokens',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// DELETE /api/device-tokens/{id}
  Future<void> delete(int id) async {
    try {
      final response = await _dio.delete(ApiConstants.deviceTokenById(id));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao deletar token de dispositivo',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao deletar token',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
