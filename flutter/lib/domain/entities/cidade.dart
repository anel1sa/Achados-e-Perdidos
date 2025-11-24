class Cidade {
  final int id;
  final String nome;
  final int estadoId;
  final String? estadoNome;
  final String? estadoUf;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  Cidade({
    required this.id,
    required this.nome,
    required this.estadoId,
    this.estadoNome,
    this.estadoUf,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

