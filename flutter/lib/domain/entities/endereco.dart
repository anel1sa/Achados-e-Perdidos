class Endereco {
  final int id;
  final String logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cep;
  final int cidadeId;
  final String? cidadeNome;
  final String? estadoUf;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  Endereco({
    required this.id,
    required this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    this.cep,
    required this.cidadeId,
    this.cidadeNome,
    this.estadoUf,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

