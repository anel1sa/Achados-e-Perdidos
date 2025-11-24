import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/instituicao.dart';

part 'instituicao_dto.freezed.dart';
part 'instituicao_dto.g.dart';

@freezed
class InstituicaoDTO with _$InstituicaoDTO {
  const InstituicaoDTO._();

  const factory InstituicaoDTO({
    required int id,
    required String nome,
    required String codigo,
    required String tipo,
    String? cnpj,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _InstituicaoDTO;

  factory InstituicaoDTO.fromJson(Map<String, dynamic> json) =>
      _$InstituicaoDTOFromJson(json);

  // Converte DTO para Entity
  Instituicao toEntity() {
    return Instituicao(
      id: id,
      nome: nome,
      codigo: codigo,
      tipo: tipo,
      cnpj: cnpj,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory InstituicaoDTO.fromEntity(Instituicao entity) {
    return InstituicaoDTO(
      id: entity.id,
      nome: entity.nome,
      codigo: entity.codigo,
      tipo: entity.tipo,
      cnpj: entity.cnpj,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

@freezed
class InstituicaoCreateDTO with _$InstituicaoCreateDTO {
  const factory InstituicaoCreateDTO({
    required String nome,
    required String codigo,
    required String tipo,
    String? cnpj,
  }) = _InstituicaoCreateDTO;

  factory InstituicaoCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$InstituicaoCreateDTOFromJson(json);
}

@freezed
class InstituicaoUpdateDTO with _$InstituicaoUpdateDTO {
  const factory InstituicaoUpdateDTO({
    String? nome,
    String? codigo,
    String? tipo,
    String? cnpj,
    @JsonKey(name: 'flgInativo') bool? flgInativo,
  }) = _InstituicaoUpdateDTO;

  factory InstituicaoUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$InstituicaoUpdateDTOFromJson(json);
}

