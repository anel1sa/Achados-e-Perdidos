import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'cache_entry.dart';

/// Serviço de cache genérico usando padrão Cache Aside
/// 
/// Padrão Cache Aside:
/// 1. Verifica cache primeiro
/// 2. Se encontrar e válido, retorna do cache (cache hit)
/// 3. Se não encontrar ou expirado, busca da API (cache miss)
/// 4. Salva resultado no cache para próximas requisições
class CacheService {
  // Nomes das boxes Hive
  static const String _itemsBoxName = 'items_cache';
  static const String _campusBoxName = 'campus_cache';
  static const String _userProfileBoxName = 'user_profile_cache';
  static const String _chatConversationsBoxName = 'chat_conversations_cache';

  static bool _initialized = false;

  /// Inicializa o Hive e abre as boxes
  static Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Abrir boxes (criar se não existir)
    await Hive.openBox(_itemsBoxName);
    await Hive.openBox(_campusBoxName);
    await Hive.openBox(_userProfileBoxName);
    await Hive.openBox(_chatConversationsBoxName);

    _initialized = true;
  }

  /// Padrão Cache Aside: Busca no cache, se não encontrar busca na API
  static Future<T?> get<T>({
    required String key,
    required String boxName,
    required Future<T> Function() fetchFromApi,
    required Duration ttl,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    try {
      await init();
      final box = await Hive.openBox(boxName);

      // 1. Tentar buscar do cache
      final cachedJson = box.get(key);

      if (cachedJson != null) {
        try {
          final cachedData = jsonDecode(cachedJson as String) as Map<String, dynamic>;
          final entry = CacheEntry.fromJson(cachedData, fromJson);

          // 2. Verificar se ainda é válido
          if (entry.isValid) {
            return entry.data; // Cache hit ✅
          } else {
            // Cache expirado, remover
            await box.delete(key);
          }
        } catch (e) {
          // Erro ao parsear cache, remover
          await box.delete(key);
        }
      }

      // 3. Cache miss - buscar da API
      final data = await fetchFromApi();

      // 4. Salvar no cache
      final entry = CacheEntry.single(data, ttl);
      final entryJson = jsonEncode(entry.toJson(toJson));
      await box.put(key, entryJson);

      return data;
    } catch (e) {
      // Se der erro no cache, retornar da API mesmo assim
      return await fetchFromApi();
    }
  }

  /// Cache Aside para listas
  static Future<List<T>> getList<T>({
    required String key,
    required String boxName,
    required Future<List<T>> Function() fetchFromApi,
    required Duration ttl,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    try {
      await init();
      final box = await Hive.openBox(boxName);

      // 1. Tentar buscar do cache
      final cachedJson = box.get(key);

      if (cachedJson != null) {
        try {
          final cachedData = jsonDecode(cachedJson as String) as Map<String, dynamic>;
          final dataList = (cachedData['data'] as List)
              .map((e) => fromJson(e as Map<String, dynamic>))
              .toList();
          
          final timestamp = DateTime.parse(cachedData['timestamp'] as String);
          final ttl = Duration(milliseconds: cachedData['ttl'] as int);
          final entry = CacheEntry<List<T>>(
            data: dataList,
            timestamp: timestamp,
            ttl: ttl,
          );

          // 2. Verificar se ainda é válido
          if (entry.isValid) {
            return entry.data; // Cache hit ✅
          } else {
            // Cache expirado, remover
            await box.delete(key);
          }
        } catch (e) {
          // Erro ao parsear cache, remover
          await box.delete(key);
        }
      }

      // 3. Cache miss - buscar da API
      final data = await fetchFromApi();

      // 4. Salvar no cache
      final timestamp = DateTime.now();
      final entryJson = jsonEncode({
        'data': data.map((e) => toJson(e)).toList(),
        'timestamp': timestamp.toIso8601String(),
        'ttl': ttl.inMilliseconds,
      });
      await box.put(key, entryJson);

      return data;
    } catch (e) {
      // Se der erro no cache, retornar da API mesmo assim
      return await fetchFromApi();
    }
  }

  /// Invalida cache específico
  static Future<void> invalidate(String key, String boxName) async {
    try {
      await init();
      final box = await Hive.openBox(boxName);
      await box.delete(key);
    } catch (e) {
      // Ignorar erros na invalidação
    }
  }

  /// Limpa todo o cache de uma box
  static Future<void> clearBox(String boxName) async {
    try {
      await init();
      final box = await Hive.openBox(boxName);
      await box.clear();
    } catch (e) {
      // Ignorar erros na limpeza
    }
  }

  /// Limpa todo o cache
  static Future<void> clearAll() async {
    await clearBox(_itemsBoxName);
    await clearBox(_campusBoxName);
    await clearBox(_userProfileBoxName);
    await clearBox(_chatConversationsBoxName);
  }

  // ========== Métodos específicos para cada tipo de cache ==========

  /// Cache de itens (TTL: 5-10 minutos)
  static Future<List<T>> getItems<T>({
    required String key,
    required Future<List<T>> Function() fetchFromApi,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    Duration ttl = const Duration(minutes: 7),
  }) async {
    return await getList<T>(
      key: key,
      boxName: _itemsBoxName,
      fetchFromApi: fetchFromApi,
      ttl: ttl,
      fromJson: fromJson,
      toJson: toJson,
    );
  }

  /// Cache de campus (TTL: 30 minutos)
  static Future<List<T>> getCampus<T>({
    required String key,
    required Future<List<T>> Function() fetchFromApi,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    return await getList<T>(
      key: key,
      boxName: _campusBoxName,
      fetchFromApi: fetchFromApi,
      ttl: const Duration(minutes: 30),
      fromJson: fromJson,
      toJson: toJson,
    );
  }

  /// Cache de perfil do usuário (até logout - TTL longo)
  static Future<T?> getUserProfile<T>({
    required String userId,
    required Future<T> Function() fetchFromApi,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    return await get<T>(
      key: 'user_$userId',
      boxName: _userProfileBoxName,
      fetchFromApi: fetchFromApi,
      ttl: const Duration(days: 365), // Praticamente permanente até logout
      fromJson: fromJson,
      toJson: toJson,
    );
  }

  /// Cache de conversas de chat (TTL: 24 horas)
  static Future<List<T>> getChatConversations<T>({
    required String userId,
    required Future<List<T>> Function() fetchFromApi,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    return await getList<T>(
      key: 'conversations_$userId',
      boxName: _chatConversationsBoxName,
      fetchFromApi: fetchFromApi,
      ttl: const Duration(hours: 24),
      fromJson: fromJson,
      toJson: toJson,
    );
  }

  /// Invalida cache de itens
  static Future<void> invalidateItems(String key) async {
    await invalidate(key, _itemsBoxName);
  }

  /// Invalida cache de campus
  static Future<void> invalidateCampus(String key) async {
    await invalidate(key, _campusBoxName);
  }

  /// Invalida cache de perfil do usuário
  static Future<void> invalidateUserProfile(String userId) async {
    await invalidate('user_$userId', _userProfileBoxName);
  }

  /// Invalida cache de conversas
  static Future<void> invalidateChatConversations(String userId) async {
    await invalidate('conversations_$userId', _chatConversationsBoxName);
  }
}

