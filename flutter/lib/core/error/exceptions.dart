class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({
    required this.message,
  });

  @override
  String toString() => 'NetworkException: $message';
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({
    required this.message,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException({
    required this.message,
  });

  @override
  String toString() => 'CacheException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({
    required this.message,
  });

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException({
    required this.message,
  });

  @override
  String toString() => 'NotFoundException: $message';
}

class ConnectionException implements Exception {
  final String message;

  ConnectionException({
    required this.message,
  });

  @override
  String toString() => 'ConnectionException: $message';
}
