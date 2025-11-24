/// DTO para notificações do sistema
class NotificacaoDTO {
  final String id;
  final String? titulo;
  final String mensagem;
  final String tipo; // CHAT, NOVO_ITEM, REIVINDICACAO, DEVOLUCAO, SISTEMA
  final DateTime data;
  bool lida; // Mutável para poder atualizar
  final Map<String, dynamic>? dadosAdicionais; // Para dados extras como itemId, userId, etc.

  NotificacaoDTO({
    required this.id,
    this.titulo,
    required this.mensagem,
    required this.tipo,
    required this.data,
    this.lida = false,
    this.dadosAdicionais,
  });

  factory NotificacaoDTO.fromChatMessage(Map<String, dynamic> json) {
    final tipoMensagem = json['tipo'] as String? ?? 'CHAT';
    final status = json['status'] as String? ?? 'ENVIADA';
    final isLida = status == 'LIDA' || status == 'LIDO';
    
    // Extrair dados adicionais se existirem
    Map<String, dynamic>? dadosAdicionais;
    if (json['dadosAdicionais'] != null) {
      dadosAdicionais = Map<String, dynamic>.from(json['dadosAdicionais']);
    }
    
    // Determinar título baseado no tipo
    String? titulo;
    switch (tipoMensagem) {
      case 'CHAT':
        titulo = 'Nova mensagem';
        break;
      case 'SYSTEM':
        titulo = 'Notificação do sistema';
        break;
      default:
        titulo = 'Notificação';
    }
    
    return NotificacaoDTO(
      id: json['id']?.toString() ?? '',
      titulo: titulo,
      mensagem: json['menssagem'] as String? ?? json['conteudo'] as String? ?? '',
      tipo: tipoMensagem,
      data: json['data_Hora_Menssagem'] != null
          ? DateTime.parse(json['data_Hora_Menssagem'] as String)
          : DateTime.now(),
      lida: isLida,
      dadosAdicionais: dadosAdicionais,
    );
  }

  factory NotificacaoDTO.fromOneSignal(Map<String, dynamic> json) {
    final additionalData = json['additionalData'] as Map<String, dynamic>?;
    final tipo = additionalData?['type'] as String? ?? 'SISTEMA';
    
    return NotificacaoDTO(
      id: json['notificationId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: json['title'] as String? ?? 'Notificação',
      mensagem: json['body'] as String? ?? '',
      tipo: tipo,
      data: json['sentTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sentTime'] as int)
          : DateTime.now(),
      lida: json['isAppInFocus'] == true, // Se o app estava em foco, consideramos como lida
      dadosAdicionais: additionalData,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'mensagem': mensagem,
        'tipo': tipo,
        'data': data.toIso8601String(),
        'lida': lida,
        if (dadosAdicionais != null) 'dadosAdicionais': dadosAdicionais,
      };
}

