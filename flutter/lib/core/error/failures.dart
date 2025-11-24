import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
  }) = NetworkFailure;

  const factory Failure.authentication({
    required String message,
  }) = AuthenticationFailure;

  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationFailure;

  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;

  const factory Failure.unauthorized({
    required String message,
  }) = UnauthorizedFailure;

  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  const factory Failure.unknown({
    required String message,
  }) = UnknownFailure;
}

extension FailureX on Failure {
  String get errorMessage => when(
        server: (message, statusCode) => message,
        network: (message) => message,
        authentication: (message) => message,
        validation: (message, errors) => message,
        notFound: (message) => message,
        unauthorized: (message) => message,
        cache: (message) => message,
        unknown: (message) => message,
      );
}
