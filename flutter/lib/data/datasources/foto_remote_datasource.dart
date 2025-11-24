import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../DTOs/foto_dto.dart';

class FotoRemoteDataSource {
  final Dio _dio;

  FotoRemoteDataSource(this._dio);

  /// POST /api/fotos/upload/item - Upload de foto para um item
  Future<FotoDTO> uploadItemPhoto({
    required String filePath,
    required int userId,
    required int itemId,
  }) async {
    try {
      final fileName = filePath.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        'userId': userId,
        'itemId': itemId,
      });

      final response = await _dio.post(
        ApiConstants.uploadItemPhoto,
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return FotoDTO.fromJson(response.data);
      } else {
        throw Exception('Erro ao fazer upload da foto');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao fazer upload: ${e.message}');
    }
  }

  /// GET /api/fotos/item/{itemId} - Buscar fotos de um item
  Future<List<FotoDTO>> getFotosByItem(int itemId) async {
    try {
      final response = await _dio.get(ApiConstants.fotosByItem(itemId));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FotoDTO.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar fotos');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar fotos: ${e.message}');
    }
  }
}
