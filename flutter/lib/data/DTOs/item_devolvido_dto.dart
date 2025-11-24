/// DTOs para Itens Devolvidos
/// Endpoint: /api/itens-devolvidos

class ItemDevolvidoDTO {
  final int id;
  final int itemId;
  final int usuarioDevolvedorId;
  final int? usuarioAchouId;
  final String detalhesDevolucao; // Mínimo 20 caracteres (constraint SQL)
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  ItemDevolvidoDTO({
    required this.id,
    required this.itemId,
    required this.usuarioDevolvedorId,
    this.usuarioAchouId,
    required this.detalhesDevolucao,
    required this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });

  factory ItemDevolvidoDTO.fromJson(Map<String, dynamic> json) {
    return ItemDevolvidoDTO(
      id: json['id'] as int,
      itemId: json['itemId'] as int,
      usuarioDevolvedorId: json['usuarioDevolvedorId'] as int,
      usuarioAchouId: json['usuarioAchouId'] as int?,
      detalhesDevolucao: json['detalhesDevolucao'] as String,
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
      'usuarioDevolvedorId': usuarioDevolvedorId,
      if (usuarioAchouId != null) 'usuarioAchouId': usuarioAchouId,
      'detalhesDevolucao': detalhesDevolucao,
      'dtaCriacao': dtaCriacao.toIso8601String(),
      'flgInativo': flgInativo,
      if (dtaRemocao != null) 'dtaRemocao': dtaRemocao!.toIso8601String(),
    };
  }
}

/// DTO para registrar uma nova devolução
class ItemDevolvidoCreateDTO {
  final int itemId;
  final String detalhesDevolucao; // Onde/como foi devolvido (min 20 chars)

  ItemDevolvidoCreateDTO({
    required this.itemId,
    required this.detalhesDevolucao,
  });

  Map<String, dynamic> toJson() {
    // Validação: mínimo 20 caracteres (constraint SQL)
    if (detalhesDevolucao.trim().length < 20) {
      throw ArgumentError(
        'Detalhes da devolução devem ter no mínimo 20 caracteres',
      );
    }

    return {
      'itemId': itemId,
      'detalhesDevolucao': detalhesDevolucao.trim(),
    };
  }
}

/// DTO para atualizar uma devolução
class ItemDevolvidoUpdateDTO {
  final String? detalhesDevolucao;
  final bool? flgInativo;

  ItemDevolvidoUpdateDTO({
    this.detalhesDevolucao,
    this.flgInativo,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (detalhesDevolucao != null) {
      // Validação: mínimo 20 caracteres
      if (detalhesDevolucao!.trim().length < 20) {
        throw ArgumentError(
          'Detalhes da devolução devem ter no mínimo 20 caracteres',
        );
      }
      map['detalhesDevolucao'] = detalhesDevolucao!.trim();
    }
    if (flgInativo != null) map['flgInativo'] = flgInativo;
    return map;
  }
}
