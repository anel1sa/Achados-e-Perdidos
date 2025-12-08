import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

@freezed
class AuthResponseDTO with _$AuthResponseDTO {
  const factory AuthResponseDTO({
    required String token,
    @JsonKey(name: 'tokenType') required String tokenType,
    @JsonKey(name: 'expiresIn') required int expiresIn,
    required int id,
    required String nome,
    required String email,
    String? role,
    String? campus,
  }) = _AuthResponseDTO;

  factory AuthResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDTOFromJson(json);
}

@freezed
class GoogleUserDTO with _$GoogleUserDTO {
  const factory GoogleUserDTO({
    required String id,
    required String email,
    required String name,
    String? picture,
    @JsonKey(name: 'verified_email') @Default(false) bool verifiedEmail,
  }) = _GoogleUserDTO;

  factory GoogleUserDTO.fromJson(Map<String, dynamic> json) =>
      _$GoogleUserDTOFromJson(json);
}

