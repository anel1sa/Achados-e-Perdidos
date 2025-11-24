/// DTOs para Reivindicações de Itens Perdidos
/// Endpoint: /api/reivindicacoes

class ReivindicacaoDTO {
  final int id;
  final int itemId;
  final int usuarioReivindicadorId;
  final int usuarioProprietarioId;
  final String? descricao;
  final String? comprovante; // URL da foto/documento
  final String status; // PENDENTE, APROVADA, REJEITADA
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  ReivindicacaoDTO({
    required this.id,
    required this.itemId,
    required this.usuarioReivindicadorId,
    required this.usuarioProprietarioId,
    this.descricao,
    this.comprovante,
    required this.status,
    required this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });

  factory ReivindicacaoDTO.fromJson(Map<String, dynamic> json) {
    return ReivindicacaoDTO(
      id: json['id'] as int,
      itemId: json['itemId'] as int,
      usuarioReivindicadorId: json['usuarioReivindicadorId'] as int,
      usuarioProprietarioId: json['usuarioProprietarioId'] as int,
      descricao: json['descricao'] as String?,
      comprovante: json['comprovante'] as String?,
      status: json['status'] as String,
      dtaCriacao: DateTime.parse(json['dtaCriacao'] as String),
      flgInativo: json['flgInativo'] as bool? ?? false,
      dtaRemocao: json['dtaRemocao'] != null
          ? DateTime.parse(json['dtaRemocao'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'usuarioReivindicadorId': usuarioReivindicadorId,
      'usuarioProprietarioId': usuarioProprietarioId,
      if (descricao != null) 'descricao': descricao,
      if (comprovante != null) 'comprovante': comprovante,
      'status': status,
      'dtaCriacao': dtaCriacao.toIso8601String(),
      'flgInativo': flgInativo,
      if (dtaRemocao != null) 'dtaRemocao': dtaRemocao!.toIso8601String(),
    };
  }
}

/// DTO para criar uma nova reivindicação
class ReivindicacaoCreateDTO {
  final int itemId;
  final String? descricao;
  final String? comprovante; // URL da foto/documento

  ReivindicacaoCreateDTO({
    required this.itemId,
    this.descricao,
    this.comprovante,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      if (descricao != null && descricao!.isNotEmpty) 'descricao': descricao,
      if (comprovante != null && comprovante!.isNotEmpty)
        'comprovante': comprovante,
    };
  }
}

/// DTO para atualizar uma reivindicação (aprovar/rejeitar)
class ReivindicacaoUpdateDTO {
  final String? status; // PENDENTE, APROVADA, REJEITADA
  final String? descricao;
  final bool? flgInativo;

  ReivindicacaoUpdateDTO({
    this.status,
    this.descricao,
    this.flgInativo,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (status != null) map['status'] = status;
    if (descricao != null) map['descricao'] = descricao;
    if (flgInativo != null) map['flgInativo'] = flgInativo;
    return map;
  }
}

/// Enum para status da reivindicação
enum StatusReivindicacao {
  PENDENTE,
  APROVADA,
  REJEITADA;

  String toJson() => name;

  static StatusReivindicacao fromJson(String value) {
    return StatusReivindicacao.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StatusReivindicacao.PENDENTE,
    );
  }
}
