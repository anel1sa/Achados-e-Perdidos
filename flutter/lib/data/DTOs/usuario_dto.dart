import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/usuario.dart';

part 'usuario_dto.freezed.dart';
part 'usuario_dto.g.dart';

@freezed
class UsuarioDTO with _$UsuarioDTO {
  const UsuarioDTO._();

  const factory UsuarioDTO({
    required int id,
    @JsonKey(name: 'nomeCompleto') required String nomeCompleto,
    String? cpf,
    required String email,
    String? matricula,
    @JsonKey(name: 'numeroTelefone') String? numeroTelefone,
    @JsonKey(name: 'empresaId') int? empresaId,
    @JsonKey(name: 'campusId') int? campusId,
    @JsonKey(name: 'enderecoId') int? enderecoId,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _UsuarioDTO;

  factory UsuarioDTO.fromJson(Map<String, dynamic> json) =>
      _$UsuarioDTOFromJson(json);

  // Getters de compatibilidade (para páginas antigas que usavam UsuarioModel)
  String get nome => nomeCompleto.split(' ')[0]; // Primeiro nome

  // Converte DTO para Entity
  Usuario toEntity() {
    return Usuario(
      id: id,
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      email: email,
      hashSenha: '', // Não vem no DTO
      matricula: matricula,
      numeroTelefone: numeroTelefone,
      enderecoId: enderecoId,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory UsuarioDTO.fromEntity(Usuario entity) {
    return UsuarioDTO(
      id: entity.id,
      nomeCompleto: entity.nomeCompleto,
      cpf: entity.cpf,
      email: entity.email,
      matricula: entity.matricula,
      numeroTelefone: entity.numeroTelefone,
      enderecoId: entity.enderecoId,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

// DTOs para requisições

@freezed
class UsuarioCreateDTO with _$UsuarioCreateDTO {
  const factory UsuarioCreateDTO({
    @JsonKey(name: 'nomeCompleto') required String nomeCompleto,
    @JsonKey(includeIfNull: false) String? cpf,
    required String email,
    required String senha,
    @JsonKey(includeIfNull: false) String? matricula,
    @JsonKey(name: 'numeroTelefone', includeIfNull: false)
    String? numeroTelefone,
    @JsonKey(name: 'campusId') required int campusId,
    @JsonKey(name: 'enderecoId', includeIfNull: false) int? enderecoId,
  }) = _UsuarioCreateDTO;

  factory UsuarioCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$UsuarioCreateDTOFromJson(json);
}

@freezed
class UsuarioUpdateDTO with _$UsuarioUpdateDTO {
  const factory UsuarioUpdateDTO({
    @JsonKey(name: 'nomeCompleto') String? nomeCompleto,
    @JsonKey(includeIfNull: false) String? cpf,
    @JsonKey(includeIfNull: false) String? email,
    @JsonKey(includeIfNull: false) String? matricula,
    @JsonKey(name: 'empresaId', includeIfNull: false) int? empresaId,
    @JsonKey(name: 'enderecoId', includeIfNull: false) int? enderecoId,
    @JsonKey(name: 'flgInativo', includeIfNull: false) bool? flgInativo,
  }) = _UsuarioUpdateDTO;

  factory UsuarioUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$UsuarioUpdateDTOFromJson(json);
}

@freezed
class AlterarSenhaDTO with _$AlterarSenhaDTO {
  const factory AlterarSenhaDTO({
    @JsonKey(name: 'senhaAtual') required String senhaAtual,
    @JsonKey(name: 'novaSenha') required String novaSenha,
  }) = _AlterarSenhaDTO;

  factory AlterarSenhaDTO.fromJson(Map<String, dynamic> json) =>
      _$AlterarSenhaDTOFromJson(json);
}

