import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/notificacao_dto.dart';
import '../DTOs/chat_dto.dart';

class NotificacaoRemoteDataSource {
  final Dio _dio;

  NotificacaoRemoteDataSource(this._dio);

  /// Busca notificações do sistema
  /// NOTA: Não há endpoint específico para buscar notificações
  /// As notificações chegam via OneSignal em tempo real quando eventos ocorrem
  /// Este método retorna lista vazia pois as notificações são gerenciadas via push
  Future<List<NotificacaoDTO>> getNotificacoesSistema(String userId) async {
    // Não há endpoint para buscar notificações do sistema
    // As notificações chegam via OneSignal quando:
    // - Mensagens de chat são enviadas
    // - Novos itens são criados
    // - Reivindicações são aprovadas
    // - Itens são devolvidos
    print('ℹ️ Notificações são recebidas via OneSignal em tempo real, não há endpoint de busca');
    return [];
  }

  /// Busca todas as notificações do usuário
  /// Usa o endpoint de chat privado para buscar mensagens do tipo SYSTEM
  /// Notificações de chat (tipo CHAT) chegam via OneSignal em tempo real
  Future<List<NotificacaoDTO>> getNotificacoesUsuario(String userId) async {
    try {
      // Buscar mensagens do tipo SYSTEM usando o endpoint de chat privado
      // As notificações de chat chegam via OneSignal quando uma nova mensagem é enviada
      return await getNotificacoesSistema(userId);
    } catch (e) {
      print('❌ Erro ao buscar notificações: $e');
      return [];
    }
  }

  /// Marca notificação como lida
  /// PUT /api/chat/mark-read
  /// Requer buscar a mensagem primeiro para obter todos os dados necessários
  Future<void> marcarComoLida(String messageId) async {
    try {
      // Primeiro, buscar a mensagem para obter todos os dados necessários
      final response = await _dio.get(ApiConstants.chatMessageById(messageId));
      
      if (response.statusCode == 200 && response.data != null) {
        final messageData = response.data as Map<String, dynamic>;
        
        // Criar ChatMessageModel para facilitar o acesso aos dados
        final message = ChatMessageModel.fromJson(messageData);
        
        // Agora marcar como lida usando o endpoint correto com todos os dados
        await _dio.put(
          ApiConstants.chatMarkRead,
          data: {
            'id': message.id,
            'id_Usuario_Remetente': message.idUsuarioRemetente,
            'id_Usuario_Destino': message.idUsuarioDestino,
            'data_Hora_Menssagem': message.dataEnvio.toIso8601String(),
            'id_Chat': message.conversaId ?? '',
            'menssagem': message.conteudo,
            'tipo': 'CHAT',
            'status': 'LIDA', // Marcar como lida
          },
        );
      } else {
        throw ServerException(
          message: 'Mensagem não encontrada',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao marcar notificação como lida',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Marca todas as notificações como lidas
  /// PUT /api/chat/messages/read-all/{userId}
  Future<void> marcarTodasComoLidas(String userId) async {
    try {
      await _dio.put(
        ApiConstants.chatMessagesReadAll(userId),
      );
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao marcar notificações como lidas',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

