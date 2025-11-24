class Role {
  final int id;
  final String nome;
  final String? descricao;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  Role({
    required this.id,
    required this.nome,
    this.descricao,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

