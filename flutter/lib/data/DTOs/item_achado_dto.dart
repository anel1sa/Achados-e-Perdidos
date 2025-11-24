class ItemAchadoCreateDTO {
  final String nome;
  final String descricao;
  final String descLocalItem; // Mudado de localId (int) para descLocalItem (String)
  final int? usuarioRelatorId; // Opcional - extraído do JWT
  final DateTime? encontradoEm;
  final List<FotoCreateDTO>? fotos;

  ItemAchadoCreateDTO({
    required this.nome,
    required this.descricao,
    required this.descLocalItem,
    this.usuarioRelatorId,
    this.encontradoEm,
    this.fotos,
  });

  Map<String, dynamic> toJson() {
    // API espera apenas: nome, descricao, descLocalItem
    return {
      'nome': nome,
      'descricao': descricao,
      'descLocalItem': descLocalItem, // Mudado de localId para descLocalItem
    };
  }
}

class FotoCreateDTO {
  final String url;
  final String? provedorArmazenamento; // "local", "s3", etc
  final String? chaveArmazenamento;
  final String? nomeArquivoOriginal;
  final int? tamanhoArquivoBytes;

  FotoCreateDTO({
    required this.url,
    this.provedorArmazenamento,
    this.chaveArmazenamento,
    this.nomeArquivoOriginal,
    this.tamanhoArquivoBytes,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (provedorArmazenamento != null)
        'provedorArmazenamento': provedorArmazenamento,
      if (chaveArmazenamento != null) 'chaveArmazenamento': chaveArmazenamento,
      if (nomeArquivoOriginal != null)
        'nomeArquivoOriginal': nomeArquivoOriginal,
      if (tamanhoArquivoBytes != null)
        'tamanhoArquivoBytes': tamanhoArquivoBytes,
    };
  }
}
