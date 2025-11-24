import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/item_dto.dart';

class DeadlineRemoteDataSource {
  final Dio _dio;

  DeadlineRemoteDataSource(this._dio);

  /// GET /api/deadline/near-deadline - Itens próximos do prazo de doação
  Future<List<ItemDTO>> getItemsNearDeadline({int daysFromNow = 25}) async {
    try {
      final response = await _dio.get(
        ApiConstants.deadlineNearDeadline,
        queryParameters: {'daysFromNow': daysFromNow},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ItemDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens próximos do prazo',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/deadline/expired - Itens expirados
  Future<List<ItemDTO>> getExpiredItems({int daysExpired = 30}) async {
    try {
      final response = await _dio.get(
        ApiConstants.deadlineExpired,
        queryParameters: {'daysExpired': daysExpired},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ItemDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens expirados',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens expirados',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/deadline/mark-donated/{itemId} - Marca item como doado
  Future<void> markItemAsDonated(int itemId) async {
    try {
      final response = await _dio.post(ApiConstants.deadlineMarkDonated(itemId));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao marcar item como doado',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao marcar item como doado',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/deadline/notify-deadlines - Força notificações de prazo
  Future<void> notifyDeadlines() async {
    try {
      final response = await _dio.post(ApiConstants.deadlineNotify);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao enviar notificações',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao enviar notificações',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/deadline/mark-expired-donated - Marca itens expirados como doados
  Future<void> markExpiredAsDonated() async {
    try {
      final response = await _dio.post(ApiConstants.deadlineMarkExpiredDonated);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao marcar itens expirados',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao marcar itens expirados',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/deadline/stats - Estatísticas de prazos
  Future<DeadlineStatsModel> getDeadlineStats() async {
    try {
      final response = await _dio.get(ApiConstants.deadlineStats);

      if (response.statusCode == 200) {
        return DeadlineStatsModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao buscar estatísticas',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar estatísticas',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

/// Model para estatísticas de deadline
class DeadlineStatsModel {
  final int itemsNearDeadline;
  final int expiredItems;
  final int donatedItems;
  final int totalProcessed;

  DeadlineStatsModel({
    required this.itemsNearDeadline,
    required this.expiredItems,
    required this.donatedItems,
    required this.totalProcessed,
  });

  factory DeadlineStatsModel.fromJson(Map<String, dynamic> json) {
    return DeadlineStatsModel(
      itemsNearDeadline: json['itemsNearDeadline'] ?? 0,
      expiredItems: json['expiredItems'] ?? 0,
      donatedItems: json['donatedItems'] ?? 0,
      totalProcessed: json['totalProcessed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemsNearDeadline': itemsNearDeadline,
      'expiredItems': expiredItems,
      'donatedItems': donatedItems,
      'totalProcessed': totalProcessed,
    };
  }
}

