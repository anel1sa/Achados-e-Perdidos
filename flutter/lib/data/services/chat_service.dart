import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/chat_remote_datasource.dart';
import '../DTOs/chat_dto.dart';
import '../../core/network/dio_client.dart';

/// Service para gerenciamento de chat
/// Conecta os datasources às páginas
class ChatService {
  late final ChatRemoteDataSource _dataSource;

  ChatService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = ChatRemoteDataSource(client);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Envia mensagem privada
  Future<ChatMessageModel> sendMessage(SendChatMessageDTO dto, String destinatarioId, String remetenteId) async {
    return await _dataSource.sendMessageRest(dto, destinatarioId, remetenteId);
  }

  /// Envia mensagem privada (alternativa)
  Future<ChatMessageModel> sendPrivateMessage(SendChatMessageDTO dto, String destinatarioId) async {
    return await _dataSource.sendPrivateMessage(dto, destinatarioId);
  }

  /// Lista mensagens de um chat
  Future<List<ChatMessageModel>> getChatMessages(String chatId) async {
    return await _dataSource.getChatMessages(chatId);
  }

  /// Mensagens entre dois usuários
  Future<List<ChatMessageModel>> getMessagesBetweenUsers(String userId1, String userId2) async {
    return await _dataSource.getMessagesBetweenUsers(userId1, userId2);
  }

  /// Busca mensagem por ID
  Future<ChatMessageModel> getMessageById(String messageId) async {
    return await _dataSource.getMessageById(messageId);
  }

  /// Conta mensagens do chat
  Future<int> getMessageCount(String chatId) async {
    return await _dataSource.getMessageCount(chatId);
  }

  /// Marca mensagens como lidas
  Future<void> markAsRead(String remetenteId, String destinatarioId) async {
    return await _dataSource.markAsRead(remetenteId, destinatarioId);
  }

  /// Indica que está digitando
  Future<void> sendTyping(String destinatarioId) async {
    return await _dataSource.sendTyping(destinatarioId);
  }

  /// Para indicação de digitação
  Future<void> sendStopTyping(String destinatarioId) async {
    return await _dataSource.sendStopTyping(destinatarioId);
  }

  /// Notifica que está online
  Future<void> sendOnline(String destinatarioId) async {
    return await _dataSource.sendOnline(destinatarioId);
  }

  /// Notifica que está offline
  Future<void> sendOffline(String destinatarioId) async {
    return await _dataSource.sendOffline(destinatarioId);
  }

  /// Conecta ao WebSocket STOMP
  void connectWebSocket({
    required String token,
    required String userId,
    required void Function(ChatMessageModel) onMessageReceived,
    void Function()? onConnect,
    void Function(String)? onError,
  }) {
    _dataSource.connectWebSocket(
      token: token,
      userId: userId,
      onMessageReceived: onMessageReceived,
      onConnect: onConnect,
      onError: onError,
    );
  }

  /// Envia mensagem via WebSocket STOMP
  void sendMessageViaWebSocket({
    required String conversaId,
    required String conteudo,
  }) {
    _dataSource.sendMessageViaWebSocket(
      conversaId: conversaId,
      conteudo: conteudo,
    );
  }

  /// Desconecta do WebSocket
  void disconnectWebSocket() {
    _dataSource.disconnectWebSocket();
  }

  /// Verifica se está conectado
  bool get isConnected => _dataSource.isConnected;

  /// Lista todas as conversas do usuário
  Future<List<ChatSummaryDTO>> getUserChats(String userId) async {
    return await _dataSource.getUserChats(userId);
  }

  /// Lista mensagens não lidas do usuário
  Future<List<ChatMessageModel>> getUnreadMessages(String userId) async {
    return await _dataSource.getUnreadMessages(userId);
  }
}

