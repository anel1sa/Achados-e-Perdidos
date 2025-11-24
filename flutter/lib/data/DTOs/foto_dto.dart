import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/foto.dart';

part 'foto_dto.freezed.dart';
part 'foto_dto.g.dart';

@freezed
class FotoDTO with _$FotoDTO {
  const FotoDTO._();

  const factory FotoDTO({
    required int id,
    required String url,
    @JsonKey(name: 'provedorArmazenamento') required String provedorArmazenamento,
    @JsonKey(name: 'chaveArmazenamento') String? chaveArmazenamento,
    @JsonKey(name: 'nomeArquivoOriginal') String? nomeArquivoOriginal,
    @JsonKey(name: 'tamanhoArquivoBytes') int? tamanhoArquivoBytes,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _FotoDTO;

  factory FotoDTO.fromJson(Map<String, dynamic> json) =>
      _$FotoDTOFromJson(json);

  // Converte DTO para Entity
  Foto toEntity() {
    return Foto(
      id: id,
      url: url,
      provedorArmazenamento: provedorArmazenamento,
      chaveArmazenamento: chaveArmazenamento,
      nomeArquivoOriginal: nomeArquivoOriginal,
      tamanhoArquivoBytes: tamanhoArquivoBytes,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory FotoDTO.fromEntity(Foto entity) {
    return FotoDTO(
      id: entity.id,
      url: entity.url,
      provedorArmazenamento: entity.provedorArmazenamento,
      chaveArmazenamento: entity.chaveArmazenamento,
      nomeArquivoOriginal: entity.nomeArquivoOriginal,
      tamanhoArquivoBytes: entity.tamanhoArquivoBytes,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

