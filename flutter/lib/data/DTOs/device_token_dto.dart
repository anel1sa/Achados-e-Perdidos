class DeviceTokenDTO {
  final int id;
  final int usuarioId;
  final String token;
  final String plataforma;
  final DateTime dtaCriacao;
  final DateTime? dtaAtualizacao;
  final bool flgInativo;
  final DateTime? dtaRemocao;

  DeviceTokenDTO({
    required this.id,
    required this.usuarioId,
    required this.token,
    required this.plataforma,
    required this.dtaCriacao,
    this.dtaAtualizacao,
    required this.flgInativo,
    this.dtaRemocao,
  });

  factory DeviceTokenDTO.fromJson(Map<String, dynamic> json) {
    return DeviceTokenDTO(
      id: json['id'] as int,
      usuarioId: json['usuarioId'] as int,
      token: json['token'] as String,
      plataforma: json['plataforma'] as String,
      dtaCriacao: DateTime.parse(json['dtaCriacao'] as String),
      dtaAtualizacao: json['dtaAtualizacao'] != null
          ? DateTime.parse(json['dtaAtualizacao'] as String)
          : null,
      flgInativo: json['flgInativo'] as bool,
      dtaRemocao: json['dtaRemocao'] != null
          ? DateTime.parse(json['dtaRemocao'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'token': token,
      'plataforma': plataforma,
      'dtaCriacao': dtaCriacao.toIso8601String(),
      if (dtaAtualizacao != null) 'dtaAtualizacao': dtaAtualizacao!.toIso8601String(),
      'flgInativo': flgInativo,
      if (dtaRemocao != null) 'dtaRemocao': dtaRemocao!.toIso8601String(),
    };
  }
}

class DeviceTokenCreateDTO {
  final int usuarioId;
  final String token;
  final String plataforma;

  DeviceTokenCreateDTO({
    required this.usuarioId,
    required this.token,
    required this.plataforma,
  });

  factory DeviceTokenCreateDTO.fromJson(Map<String, dynamic> json) {
    return DeviceTokenCreateDTO(
      usuarioId: json['usuarioId'] as int,
      token: json['token'] as String,
      plataforma: json['plataforma'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'token': token,
      'plataforma': plataforma,
    };
  }
}
