import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/estado.dart';

part 'estado_dto.freezed.dart';
part 'estado_dto.g.dart';

@freezed
class EstadoDTO with _$EstadoDTO {
  const EstadoDTO._();

  const factory EstadoDTO({
    required int id,
    required String nome,
    required String uf,
    @JsonKey(name: 'dtaCriacao') DateTime? dtaCriacao,
    @JsonKey(name: 'flgInativo') @Default(false) bool flgInativo,
    @JsonKey(name: 'dtaRemocao') DateTime? dtaRemocao,
  }) = _EstadoDTO;

  factory EstadoDTO.fromJson(Map<String, dynamic> json) =>
      _$EstadoDTOFromJson(json);

  // Converte DTO para Entity
  Estado toEntity() {
    return Estado(
      id: id,
      nome: nome,
      uf: uf,
      dtaCriacao: dtaCriacao,
      flgInativo: flgInativo,
      dtaRemocao: dtaRemocao,
    );
  }

  // Cria DTO a partir de Entity
  factory EstadoDTO.fromEntity(Estado entity) {
    return EstadoDTO(
      id: entity.id,
      nome: entity.nome,
      uf: entity.uf,
      dtaCriacao: entity.dtaCriacao,
      flgInativo: entity.flgInativo,
      dtaRemocao: entity.dtaRemocao,
    );
  }
}

@freezed
class EstadoCreateDTO with _$EstadoCreateDTO {
  const factory EstadoCreateDTO({
    required String nome,
    required String uf,
  }) = _EstadoCreateDTO;

  factory EstadoCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$EstadoCreateDTOFromJson(json);
}

@freezed
class EstadoUpdateDTO with _$EstadoUpdateDTO {
  const factory EstadoUpdateDTO({
    String? nome,
    String? uf,
    @JsonKey(name: 'flgInativo') bool? flgInativo,
  }) = _EstadoUpdateDTO;

  factory EstadoUpdateDTO.fromJson(Map<String, dynamic> json) =>
      _$EstadoUpdateDTOFromJson(json);
}

