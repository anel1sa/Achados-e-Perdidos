/// DTO para enviar mensagem de chat
/// A API espera 'menssagem' (com dois 's') no objeto ChatMessage
class SendChatMessageDTO {
  final String conteudo;

  const SendChatMessageDTO({
    required this.conteudo,
  });

  Map<String, dynamic> toJson() => {
        'menssagem': conteudo, // API usa 'menssagem' (com dois 's')
      };
}

/// Model da mensagem de chat retornada pela API
class ChatMessageModel {
  final String id;
  final String conteudo;
  final String idUsuarioRemetente;
  final String idUsuarioDestino;
  final DateTime dataEnvio;
  final bool lida;
  final String? conversaId; // Mudado de int? para String? pois id_Chat é String no formato "chat_{userId1}_{userId2}"

  const ChatMessageModel({
    required this.id,
    required this.conteudo,
    required this.idUsuarioRemetente,
    required this.idUsuarioDestino,
    required this.dataEnvio,
    required this.lida,
    this.conversaId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    // API retorna: menssagem (não conteudo), data_Hora_Menssagem (não data_Envio), id_Chat (não conversa_Id)
    // Se id_Usuario_Remetente for null, usa currentUserId como fallback
    final remetenteId = json['id_Usuario_Remetente']?.toString() ?? currentUserId ?? '';
    
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      conteudo: json['menssagem'] as String? ?? json['conteudo'] as String? ?? '',
      idUsuarioRemetente: remetenteId,
      idUsuarioDestino: json['id_Usuario_Destino']?.toString() ?? '',
      dataEnvio: json['data_Hora_Menssagem'] != null
          ? DateTime.parse(json['data_Hora_Menssagem'] as String)
          : (json['data_Envio'] != null
              ? DateTime.parse(json['data_Envio'] as String)
              : DateTime.now()),
      lida: json['lida'] as bool? ?? (json['status'] == 'LIDA'),
      conversaId: json['id_Chat']?.toString() ?? json['conversa_Id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conteudo': conteudo,
        'id_Usuario_Remetente': idUsuarioRemetente,
        'id_Usuario_Destino': idUsuarioDestino,
        'data_Envio': dataEnvio.toIso8601String(),
        'lida': lida,
        if (conversaId != null) 'id_Chat': conversaId,
      };
}

/// DTO para resumo de conversa (retornado por GET /api/chat/chats/{userId})
class ChatSummaryDTO {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageDate;
  final int unreadCount;
  final String? idUltimaMensagem;

  const ChatSummaryDTO({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.unreadCount,
    this.idUltimaMensagem,
  });

  factory ChatSummaryDTO.fromJson(Map<String, dynamic> json) {
    return ChatSummaryDTO(
      chatId: json['chatId'] as String? ?? '',
      otherUserId: json['otherUserId']?.toString() ?? '',
      otherUserName: (json['otherUserName'] as String?)?.trim() ?? 'Sistema',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageDate: json['lastMessageDate'] != null
          ? DateTime.parse(json['lastMessageDate'] as String)
          : DateTime.now(),
      unreadCount: json['unreadCount'] as int? ?? 0,
      idUltimaMensagem: json['idUltimaMensagem']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'otherUserId': otherUserId,
        'otherUserName': otherUserName,
        'lastMessage': lastMessage,
        'lastMessageDate': lastMessageDate.toIso8601String(),
        'unreadCount': unreadCount,
        if (idUltimaMensagem != null) 'idUltimaMensagem': idUltimaMensagem,
      };
}

/// DTO para resposta de lista de conversas
class ChatListResponseDTO {
  final List<ChatSummaryDTO> chats;
  final int totalCount;

  const ChatListResponseDTO({
    required this.chats,
    required this.totalCount,
  });

  factory ChatListResponseDTO.fromJson(Map<String, dynamic> json) {
    return ChatListResponseDTO(
      chats: (json['chats'] as List<dynamic>?)
              ?.map((chat) => ChatSummaryDTO.fromJson(chat as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'chats': chats.map((chat) => chat.toJson()).toList(),
        'totalCount': totalCount,
      };
}
