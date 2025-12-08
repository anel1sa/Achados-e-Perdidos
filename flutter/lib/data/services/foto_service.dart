import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/foto_remote_datasource.dart';
import '../DTOs/foto_dto.dart';
import '../../core/network/dio_client.dart';

class FotoService {
  late final FotoRemoteDataSource _dataSource;

  FotoService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = FotoRemoteDataSource(client);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Faz upload de uma foto para um item
  Future<FotoDTO> uploadItemPhoto({
    required String filePath,
    required int userId,
    required int itemId,
  }) async {
    return await _dataSource.uploadItemPhoto(
      filePath: filePath,
      userId: userId,
      itemId: itemId,
    );
  }

  /// Faz upload de múltiplas fotos para um item
  Future<List<FotoDTO>> uploadMultipleItemPhotos({
    required List<String> filePaths,
    required int userId,
    required int itemId,
  }) async {
    final List<FotoDTO> uploadedPhotos = [];

    for (final filePath in filePaths) {
      try {
        final foto = await uploadItemPhoto(
          filePath: filePath,
          userId: userId,
          itemId: itemId,
        );
        uploadedPhotos.add(foto);
      } catch (e) {
        print('Erro ao fazer upload de $filePath: $e');
        // Continua tentando fazer upload das outras fotos
      }
    }

    return uploadedPhotos;
  }

  /// Busca fotos de um item
  Future<List<FotoDTO>> getFotosByItem(int itemId) async {
    return await _dataSource.getFotosByItem(itemId);
  }
}
