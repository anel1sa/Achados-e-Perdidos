/// Entrada de cache com TTL (Time To Live)
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration ttl;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.ttl,
  });

  /// Verifica se o cache ainda é válido
  bool get isValid {
    final now = DateTime.now();
    final expiration = timestamp.add(ttl);
    return now.isBefore(expiration);
  }

  /// Verifica se o cache expirou
  bool get isExpired => !isValid;

  /// Converte para JSON (requer função de serialização)
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) serializer) {
    return {
      'data': serializer(data),
      'timestamp': timestamp.toIso8601String(),
      'ttl': ttl.inMilliseconds,
    };
  }

  /// Cria a partir de JSON (requer função de deserialização)
  /// Para objetos únicos
  factory CacheEntry.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) deserializer,
  ) {
    final dataValue = json['data'];
    T data;
    
    if (dataValue is Map<String, dynamic>) {
      data = deserializer(dataValue);
    } else {
      // Se não for Map, tenta deserializar diretamente
      data = deserializer({'value': dataValue});
    }
    
    return CacheEntry<T>(
      data: data,
      timestamp: DateTime.parse(json['timestamp'] as String),
      ttl: Duration(milliseconds: json['ttl'] as int),
    );
  }

  /// Cria entrada de cache para objeto único
  factory CacheEntry.single(
    T data,
    Duration ttl,
  ) {
    return CacheEntry<T>(
      data: data,
      timestamp: DateTime.now(),
      ttl: ttl,
    );
  }
}

