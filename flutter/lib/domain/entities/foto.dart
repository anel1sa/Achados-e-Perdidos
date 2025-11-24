class Foto {
  final int id;
  final String url;
  final String provedorArmazenamento;
  final String? chaveArmazenamento;
  final String? nomeArquivoOriginal;
  final int? tamanhoArquivoBytes;
  final DateTime? dtaCriacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  Foto({
    required this.id,
    required this.url,
    this.provedorArmazenamento = 'local',
    this.chaveArmazenamento,
    this.nomeArquivoOriginal,
    this.tamanhoArquivoBytes,
    this.dtaCriacao,
    this.flgInativo = false,
    this.dtaRemocao,
  });
}

