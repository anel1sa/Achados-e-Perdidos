import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/deadline_remote_datasource.dart';
import '../DTOs/item_dto.dart';
import '../../core/network/dio_client.dart';

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

/// Service para gerenciamento de deadlines
/// Conecta os datasources às páginas
class DeadlineService {
  late final DeadlineRemoteDataSource _dataSource;

  DeadlineService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = DeadlineRemoteDataSource(client);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Busca itens próximos do prazo de doação
  Future<List<ItemDTO>> getItemsNearDeadline({int daysFromNow = 25}) async {
    return await _dataSource.getItemsNearDeadline(daysFromNow: daysFromNow);
  }

  /// Busca itens expirados
  Future<List<ItemDTO>> getExpiredItems({int daysExpired = 30}) async {
    return await _dataSource.getExpiredItems(daysExpired: daysExpired);
  }

  /// Marca item como doado
  Future<void> markItemAsDonated(int itemId) async {
    return await _dataSource.markItemAsDonated(itemId);
  }

  /// Força notificações de prazo
  Future<void> notifyDeadlines() async {
    return await _dataSource.notifyDeadlines();
  }

  /// Marca itens expirados como doados
  Future<void> markExpiredAsDonated() async {
    return await _dataSource.markExpiredAsDonated();
  }

  /// Busca estatísticas de prazos
  Future<DeadlineStatsModel> getDeadlineStats() async {
    return await _dataSource.getDeadlineStats();
  }
}


