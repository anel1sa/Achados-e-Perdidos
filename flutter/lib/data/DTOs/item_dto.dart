import 'foto_dto.dart';

enum TipoItem {
  PERDIDO,
  ACHADO,
  DOADO;

  String toJson() => name;

  static TipoItem fromJson(String value) {
    return TipoItem.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw Exception('Tipo de item inválido: $value'),
    );
  }
}

class ItemDTO {
  final int id;
  final String nome;
  final String descricao;
  final TipoItem tipoItem;
  final String descLocalItem; // Mudado de localId (int) para descLocalItem (String)
  final int usuarioRelatorId;
  final DateTime dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;
  
  // Campos adicionais para exibição (vindos de joins)
  final String? usuarioRelatorNome;
  final int? statusId;
  final List<FotoDTO>? fotos; // Lista de objetos FotoDTO completos

  ItemDTO({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipoItem,
    required this.descLocalItem,
    required this.usuarioRelatorId,
    required this.dtaCriacao,
    required this.flgInativo,
    this.dtaRemocao,
    this.usuarioRelatorNome,
    this.statusId,
    this.fotos,
  });

  factory ItemDTO.fromJson(Map<String, dynamic> json) {
    return ItemDTO(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      tipoItem: TipoItem.fromJson(json['tipoItem'] as String),
      descLocalItem: json['descLocalItem'] as String? ?? '', // Mudado de localId para descLocalItem
      usuarioRelatorId: json['usuarioRelatorId'] as int,
      dtaCriacao: DateTime.parse(json['dtaCriacao'] as String),
      flgInativo: json['flgInativo'] as bool,
      dtaRemocao: json['dtaRemocao'] != null
          ? DateTime.parse(json['dtaRemocao'] as String)
          : null,
      usuarioRelatorNome: json['usuarioRelatorNome'] as String? ?? 
          json['usuarioRelator']?['nome'] as String? ?? 
          json['usuario']?['nome'] as String?,
      statusId: json['statusId'] as int?,
      fotos: json['fotos'] != null
          ? (json['fotos'] as List<dynamic>)
              .map((foto) => FotoDTO.fromJson(foto as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tipoItem': tipoItem.toJson(),
      'descLocalItem': descLocalItem, // Mudado de localId para descLocalItem
      'usuarioRelatorId': usuarioRelatorId,
      'dtaCriacao': dtaCriacao.toIso8601String(),
      'flgInativo': flgInativo,
      'dtaRemocao': dtaRemocao?.toIso8601String(),
      if (usuarioRelatorNome != null) 'usuarioRelatorNome': usuarioRelatorNome,
      if (statusId != null) 'statusId': statusId,
      if (fotos != null) 'fotos': fotos!.map((foto) => foto.toJson()).toList(),
    };
  }
}

class CreateItemDTO {
  final String nome;
  final String descricao;
  final TipoItem tipoItem;
  final String descLocalItem; // Mudado de localId (int) para descLocalItem (String)
  final int? usuarioRelatorId; // Opcional pois API extrai do JWT
  final DateTime? encontradoEm; // Para itens achados (ItemAchadoCreateDTO)
  final DateTime? perdidoEm; // Para itens perdidos (ItemPerdidoCreateDTO)
  final List<Map<String, dynamic>>? fotos; // Lista de fotos

  CreateItemDTO({
    required this.nome,
    required this.descricao,
    required this.tipoItem,
    required this.descLocalItem,
    this.usuarioRelatorId,
    this.encontradoEm,
    this.perdidoEm,
    this.fotos,
  });

  factory CreateItemDTO.fromJson(Map<String, dynamic> json) {
    return CreateItemDTO(
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      tipoItem: TipoItem.fromJson(json['tipoItem'] as String),
      descLocalItem: json['descLocalItem'] as String? ?? '', // Mudado de localId para descLocalItem
      usuarioRelatorId: json['usuarioRelatorId'] as int?,
      encontradoEm: json['encontradoEm'] != null
          ? DateTime.parse(json['encontradoEm'] as String)
          : null,
      perdidoEm: json['perdidoEm'] != null
          ? DateTime.parse(json['perdidoEm'] as String)
          : null,
      fotos: json['fotos'] != null
          ? List<Map<String, dynamic>>.from(json['fotos'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    // A API espera: nome, descricao, tipoItem, descLocalItem
    // usuarioRelatorId é extraído do JWT pelo controller
    final map = {
      'nome': nome,
      'descricao': descricao,
      'tipoItem': tipoItem.toJson(), // API espera enum como string
      'descLocalItem': descLocalItem, // Mudado de localId para descLocalItem
    };
    
    return map;
  }
}

/// DTO para atualização de item
class ItemUpdateDTO {
  final String? nome;
  final String? descricao;
  final String? descLocalItem;
  final TipoItem? tipoItem;
  final bool? flgInativo;

  const ItemUpdateDTO({
    this.nome,
    this.descricao,
    this.descLocalItem,
    this.tipoItem,
    this.flgInativo,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (nome != null) map['nome'] = nome;
    if (descricao != null) map['descricao'] = descricao;
    if (descLocalItem != null) map['descLocalItem'] = descLocalItem;
    if (tipoItem != null) map['tipoItem'] = tipoItem!.toJson();
    if (flgInativo != null) map['flgInativo'] = flgInativo;
    return map;
  }
}
