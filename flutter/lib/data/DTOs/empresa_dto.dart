import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/empresa.dart';

part 'empresa_dto.freezed.dart';
part 'empresa_dto.g.dart';

@freezed
class EmpresaDTO with _$EmpresaDTO {
  const EmpresaDTO._();

  const factory EmpresaDTO({
    required int id,
    required String nome,
    @JsonKey(name: 'nomeFantasia') required String nomeFantasia,
    String? cnpj,
    @JsonKey(name: 'enderecoId') int? enderecoId,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _EmpresaDTO;

  factory EmpresaDTO.fromJson(Map<String, dynamic> json) =>
      _$EmpresaDTOFromJson(json);

  // Converte DTO para Entity
  Empresa toEntity() {
    return Empresa(
      id: id,
      nome: nome,
      nomeFantasia: nomeFantasia,
      cnpj: cnpj,
      enderecoId: enderecoId,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory EmpresaDTO.fromEntity(Empresa entity) {
    return EmpresaDTO(
      id: entity.id,
      nome: entity.nome,
      nomeFantasia: entity.nomeFantasia,
      cnpj: entity.cnpj,
      enderecoId: entity.enderecoId,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

@freezed
class EmpresaCreateDTO with _$EmpresaCreateDTO {
  const factory EmpresaCreateDTO({
    required String nome,
    @JsonKey(name: 'nomeFantasia') required String nomeFantasia,
    String? cnpj,
    @JsonKey(name: 'enderecoId') int? enderecoId,
  }) = _EmpresaCreateDTO;

  factory EmpresaCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$EmpresaCreateDTOFromJson(json);
}

@freezed
class EmpresaUpdateDTO with _$EmpresaUpdateDTO {
  const factory EmpresaUpdateDTO({
    String? nome,
    @JsonKey(name: 'nomeFantasia') String? nomeFantasia,
    String? cnpj,
    @JsonKey(name: 'enderecoId') int? enderecoId,
    @JsonKey(name: 'flgInativo') bool? flgInativo,
  }) = _EmpresaUpdateDTO;

  factory EmpresaUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$EmpresaUpdateDTOFromJson(json);
}

