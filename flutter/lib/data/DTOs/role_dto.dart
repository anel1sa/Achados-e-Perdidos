import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/role.dart';

part 'role_dto.freezed.dart';
part 'role_dto.g.dart';

@freezed
class RoleDTO with _$RoleDTO {
  const RoleDTO._();

  const factory RoleDTO({
    required int id,
    required String nome,
    String? descricao,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _RoleDTO;

  factory RoleDTO.fromJson(Map<String, dynamic> json) =>
      _$RoleDTOFromJson(json);

  // Converte DTO para Entity
  Role toEntity() {
    return Role(
      id: id,
      nome: nome,
      descricao: descricao,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory RoleDTO.fromEntity(Role entity) {
    return RoleDTO(
      id: entity.id,
      nome: entity.nome,
      descricao: entity.descricao,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

@freezed
class RoleCreateDTO with _$RoleCreateDTO {
  const factory RoleCreateDTO({
    required String nome,
    String? descricao,
  }) = _RoleCreateDTO;

  factory RoleCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$RoleCreateDTOFromJson(json);
}

@freezed
class RoleUpdateDTO with _$RoleUpdateDTO {
  const factory RoleUpdateDTO({
    String? nome,
    String? descricao,
    @JsonKey(name: 'flgInativo') bool? flgInativo,
  }) = _RoleUpdateDTO;

  factory RoleUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$RoleUpdateDTOFromJson(json);
}

