import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/notificacao_remote_datasource.dart';
import '../DTOs/notificacao_dto.dart';
import '../../core/network/dio_client.dart';

class NotificacaoService {
  late final NotificacaoRemoteDataSource _dataSource;

  NotificacaoService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = NotificacaoRemoteDataSource(client);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Busca todas as notificações do usuário
  Future<List<NotificacaoDTO>> getNotificacoes(String userId) async {
    return await _dataSource.getNotificacoesUsuario(userId);
  }

  /// Marca uma notificação como lida
  Future<void> marcarComoLida(String messageId) async {
    await _dataSource.marcarComoLida(messageId);
  }

  /// Marca todas as notificações como lidas
  Future<void> marcarTodasComoLidas(String userId) async {
    await _dataSource.marcarTodasComoLidas(userId);
  }
}

