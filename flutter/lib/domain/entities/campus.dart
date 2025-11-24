import 'package:flutter/foundation.dart';

/// Entity representando tabela `campus` (ap_achados_perdidos.campus)
/// Corresponde a: com.AchadosPerdidos.API.Domain.Entity.Campus
@immutable
class Campus {
  final int id;
  final String nome;
  final int instituicaoId;
  final int enderecoId;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  const Campus({
    required this.id,
    required this.nome,
    required this.instituicaoId,
    required this.enderecoId,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

