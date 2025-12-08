class Estado {
  final int id;
  final String nome;
  final String uf;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  Estado({
    required this.id,
    required this.nome,
    required this.uf,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

