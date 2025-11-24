import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/endereco.dart';

part 'endereco_dto.freezed.dart';
part 'endereco_dto.g.dart';

@freezed
class EnderecoDTO with _$EnderecoDTO {
  const EnderecoDTO._();

  const factory EnderecoDTO({
    required int id,
    required String logradouro,
    String? numero,
    String? complemento,
    String? bairro,
    String? cep,
    @JsonKey(name: 'cidadeId') required int cidadeId,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _EnderecoDTO;

  factory EnderecoDTO.fromJson(Map<String, dynamic> json) =>
      _$EnderecoDTOFromJson(json);

  // Converte DTO para Entity
  Endereco toEntity() {
    return Endereco(
      id: id,
      logradouro: logradouro,
      numero: numero,
      complemento: complemento,
      bairro: bairro,
      cep: cep,
      cidadeId: cidadeId,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory EnderecoDTO.fromEntity(Endereco entity) {
    return EnderecoDTO(
      id: entity.id,
      logradouro: entity.logradouro,
      numero: entity.numero,
      complemento: entity.complemento,
      bairro: entity.bairro,
      cep: entity.cep,
      cidadeId: entity.cidadeId,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

@freezed
class EnderecoCreateDTO with _$EnderecoCreateDTO {
  const factory EnderecoCreateDTO({
    required String logradouro,
    String? numero,
    String? complemento,
    String? bairro,
    String? cep,
    @JsonKey(name: 'cidadeId') required int cidadeId,
  }) = _EnderecoCreateDTO;

  factory EnderecoCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$EnderecoCreateDTOFromJson(json);
}

@freezed
class EnderecoUpdateDTO with _$EnderecoUpdateDTO {
  const factory EnderecoUpdateDTO({
    String? logradouro,
    String? numero,
    String? complemento,
    String? bairro,
    String? cep,
    @JsonKey(name: 'cidadeId') int? cidadeId,
    @JsonKey(name: 'flgInativo') bool? flgInativo,
  }) = _EnderecoUpdateDTO;

  factory EnderecoUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$EnderecoUpdateDTOFromJson(json);
}

