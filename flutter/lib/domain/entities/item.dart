import 'package:flutter/foundation.dart';

/// Entity representando tabela `itens` (ap_achados_perdidos.itens)
/// Corresponde a: com.AchadosPerdidos.API.Domain.Entity.Itens
@immutable
class Item {
  final int id;
  final String nome;
  final String descricao;
  final String tipoItem; // PERDIDO, ACHADO, DOADO
  final String descLocalItem; // Mudado de localId (int) para descLocalItem (String)
  final int usuarioRelatorId;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  const Item({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipoItem,
    required this.descLocalItem,
    required this.usuarioRelatorId,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

/// Entity representando tabela `itens_achados` (ap_achados_perdidos.itens_achados)
/// Corresponde a: com.AchadosPerdidos.API.Domain.Entity.ItemAchado
@immutable
class ItemAchado {
  final int id;
  final DateTime encontradoEm;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  const ItemAchado({
    required this.id,
    required this.encontradoEm,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

/// Entity representando tabela `itens_perdidos` (ap_achados_perdidos.itens_perdidos)
/// Corresponde a: com.AchadosPerdidos.API.Domain.Entity.ItemPerdido
@immutable
class ItemPerdido {
  final int id;
  final DateTime perdidoEm;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  const ItemPerdido({
    required this.id,
    required this.perdidoEm,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

