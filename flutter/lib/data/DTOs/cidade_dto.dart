import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cidade.dart';

part 'cidade_dto.freezed.dart';
part 'cidade_dto.g.dart';

@freezed
class CidadeDTO with _$CidadeDTO {
  const CidadeDTO._();

  const factory CidadeDTO({
    required int id,
    required String nome,
    @JsonKey(name: 'estadoId') required int estadoId,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _CidadeDTO;

  factory CidadeDTO.fromJson(Map<String, dynamic> json) =>
      _$CidadeDTOFromJson(json);

  // Converte DTO para Entity
  Cidade toEntity() {
    return Cidade(
      id: id,
      nome: nome,
      estadoId: estadoId,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory CidadeDTO.fromEntity(Cidade entity) {
    return CidadeDTO(
      id: entity.id,
      nome: entity.nome,
      estadoId: entity.estadoId,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

@freezed
class CidadeCreateDTO with _$CidadeCreateDTO {
  const factory CidadeCreateDTO({
    required String nome,
    @JsonKey(name: 'estadoId') required int estadoId,
  }) = _CidadeCreateDTO;

  factory CidadeCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$CidadeCreateDTOFromJson(json);
}

@freezed
class CidadeUpdateDTO with _$CidadeUpdateDTO {
  const factory CidadeUpdateDTO({
    String? nome,
    @JsonKey(name: 'estadoId') int? estadoId,
    @JsonKey(name: 'flgInativo') bool? flgInativo,
  }) = _CidadeUpdateDTO;

  factory CidadeUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$CidadeUpdateDTOFromJson(json);
}

