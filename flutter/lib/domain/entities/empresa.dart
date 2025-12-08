class Empresa {
  final int id;
  final String nome;
  final String nomeFantasia;
  final String? cnpj;
  final int? enderecoId;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  Empresa({
    required this.id,
    required this.nome,
    required this.nomeFantasia,
    this.cnpj,
    this.enderecoId,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

