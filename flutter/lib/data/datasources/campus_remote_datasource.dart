import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/campus_dto.dart';
import '../DTOs/campus_dto.dart';

class CampusRemoteDataSource {
  final Dio _dio;

  CampusRemoteDataSource(this._dio);

  /// GET /api/campus
  Future<List<CampusDTO>> getAll() async {
    try {
      final response = await _dio.get(ApiConstants.campus);
      
      if (response.statusCode == 200) {
        // A API retorna {campi: [...], totalCount: n}
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> campiData = responseData['campi'] ?? [];
        return campiData.map((json) => CampusDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar campus',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar campus',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/campus/active
  Future<List<CampusDTO>> getAllActive() async {
    try {
      final response = await _dio.get(ApiConstants.campusActive);
      
      if (response.statusCode == 200) {
        // A API retorna {campi: [...], totalCount: n}
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> campiData = responseData['campi'] ?? [];
        return campiData.map((json) => CampusDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar campus ativos',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar campus ativos',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/campus/{id}
  Future<CampusDTO> getById(int id) async {
    try {
      final response = await _dio.get(ApiConstants.campusById(id));
      
      if (response.statusCode == 200) {
        return CampusDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao buscar campus',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar campus',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/campus/instituicao/{instituicaoId}
  Future<List<CampusDTO>> getByInstituicao(int instituicaoId) async {
    try {
      final response = await _dio.get(ApiConstants.campusByInstituicao(instituicaoId));
      
      if (response.statusCode == 200) {
        // A API retorna {campi: [...], totalCount: n}
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> campiData = responseData['campi'] ?? [];
        return campiData.map((json) => CampusDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar campus por instituição',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar campus',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/campus
  Future<CampusDTO> create(CampusCreateDTO dto) async {
    try {
      final response = await _dio.post(
        ApiConstants.campus,
        data: dto.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return CampusDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao criar campus',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao criar campus',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// PUT /api/campus/{id}
  Future<CampusDTO> update(int id, CampusUpdateDTO dto) async {
    try {
      final response = await _dio.put(
        ApiConstants.campusById(id),
        data: dto.toJson(),
      );
      
      if (response.statusCode == 200) {
        return CampusDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao atualizar campus',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao atualizar campus',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// DELETE /api/campus/{id}
  Future<void> delete(int id) async {
    try {
      final response = await _dio.delete(ApiConstants.campusById(id));
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao deletar campus',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao deletar campus',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

