class Instituicao {
  final int id;
  final String nome;
  final String codigo;
  final String tipo;
  final String? cnpj;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  Instituicao({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.tipo,
    this.cnpj,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

