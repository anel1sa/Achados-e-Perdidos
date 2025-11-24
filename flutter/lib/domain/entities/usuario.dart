import 'package:flutter/foundation.dart';

/// Entity representando tabela `usuarios` (ap_achados_perdidos.usuarios)
/// Corresponde a: com.AchadosPerdidos.API.Domain.Entity.Usuario
@immutable
class Usuario {
  final int id;
  final String nomeCompleto;
  final String? cpf;
  final String email;
  final String? hashSenha; // Não deve ser exposto em DTOs públicos
  final String? matricula;
  final String? numeroTelefone;
  final int? enderecoId;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  const Usuario({
    required this.id,
    required this.nomeCompleto,
    this.cpf,
    required this.email,
    this.hashSenha,
    this.matricula,
    this.numeroTelefone,
    this.enderecoId,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

