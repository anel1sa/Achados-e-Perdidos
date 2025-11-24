import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/campus.dart';

part 'campus_dto.freezed.dart';
part 'campus_dto.g.dart';

@freezed
class CampusDTO with _$CampusDTO {
  const CampusDTO._();

  const factory CampusDTO({
    required int id,
    required String nome,
    @JsonKey(name: 'instituicaoId') required int instituicaoId,
    @JsonKey(name: 'enderecoId') required int enderecoId,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _CampusDTO;

  factory CampusDTO.fromJson(Map<String, dynamic> json) =>
      _$CampusDTOFromJson(json);

  // Converte DTO para Entity
  Campus toEntity() {
    return Campus(
      id: id,
      nome: nome,
      instituicaoId: instituicaoId,
      enderecoId: enderecoId,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory CampusDTO.fromEntity(Campus entity) {
    return CampusDTO(
      id: entity.id,
      nome: entity.nome,
      instituicaoId: entity.instituicaoId,
      enderecoId: entity.enderecoId,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

@freezed
class CampusCreateDTO with _$CampusCreateDTO {
  const factory CampusCreateDTO({
    required String nome,
    @JsonKey(name: 'instituicaoId') required int instituicaoId,
    @JsonKey(name: 'enderecoId') required int enderecoId,
  }) = _CampusCreateDTO;

  factory CampusCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$CampusCreateDTOFromJson(json);
}

@freezed
class CampusUpdateDTO with _$CampusUpdateDTO {
  const factory CampusUpdateDTO({
    String? nome,
    @JsonKey(name: 'instituicaoId') int? instituicaoId,
    @JsonKey(name: 'enderecoId') int? enderecoId,
    @JsonKey(name: 'flgInativo') bool? flgInativo,
  }) = _CampusUpdateDTO;

  factory CampusUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$CampusUpdateDTOFromJson(json);
}

