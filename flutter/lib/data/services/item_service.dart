import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/item_remote_datasource.dart';
import '../DTOs/item_dto.dart';
import '../DTOs/item_perdido_dto.dart';
import '../DTOs/item_achado_dto.dart';
import '../../core/network/dio_client.dart';
import '../../core/cache/cache_service.dart';

/// Service para gerenciamento de itens
/// Conecta os datasources às páginas
class ItemService {
  late final ItemRemoteDataSource _dataSource;

  ItemService({Dio? dio, FlutterSecureStorage? secureStorage}) {
    final client = dio ?? _createDioClient(secureStorage);
    _dataSource = ItemRemoteDataSource(client);
  }

  Dio _createDioClient(FlutterSecureStorage? secureStorage) {
    final storage = secureStorage ?? const FlutterSecureStorage();
    final dioClient = DioClient(secureStorage: storage);
    return dioClient.dio;
  }

  /// Busca todos os itens (com cache de 7 minutos)
  Future<List<ItemDTO>> getAllItens() async {
    return await CacheService.getItems<ItemDTO>(
      key: 'all_items',
      fetchFromApi: () => _dataSource.getAll(),
      fromJson: (json) => ItemDTO.fromJson(json),
      toJson: (item) => item.toJson(),
      ttl: const Duration(minutes: 7),
    );
  }

  /// Busca itens ativos (com cache de 7 minutos)
  Future<List<ItemDTO>> getItensAtivos() async {
    return await CacheService.getItems<ItemDTO>(
      key: 'active_items',
      fetchFromApi: () => _dataSource.getAllActive(),
      fromJson: (json) => ItemDTO.fromJson(json),
      toJson: (item) => item.toJson(),
      ttl: const Duration(minutes: 7),
    );
  }

  /// Busca item por ID (com cache de 10 minutos)
  Future<ItemDTO> getItemById(int id) async {
    return await CacheService.get<ItemDTO>(
      key: 'item_$id',
      boxName: 'items_cache',
      fetchFromApi: () => _dataSource.getById(id),
      ttl: const Duration(minutes: 10),
      fromJson: (json) => ItemDTO.fromJson(json),
      toJson: (item) => item.toJson(),
    ) ?? await _dataSource.getById(id);
  }

  /// Busca itens por campus (com cache de 7 minutos)
  Future<List<ItemDTO>> getItensByCampus(int campusId) async {
    return await CacheService.getItems<ItemDTO>(
      key: 'items_campus_$campusId',
      fetchFromApi: () => _dataSource.getByCampus(campusId),
      fromJson: (json) => ItemDTO.fromJson(json),
      toJson: (item) => item.toJson(),
      ttl: const Duration(minutes: 7),
    );
  }

  /// Busca itens PERDIDOS (com cache de 5 minutos)
  Future<List<ItemDTO>> getItensPerdidos() async {
    return await CacheService.getItems<ItemDTO>(
      key: 'items_perdidos',
      fetchFromApi: () => _dataSource.getItensPerdidos(),
      fromJson: (json) => ItemDTO.fromJson(json),
      toJson: (item) => item.toJson(),
      ttl: const Duration(minutes: 5),
    );
  }

  /// Busca itens ACHADOS (com cache de 5 minutos)
  Future<List<ItemDTO>> getItensAchados() async {
    return await CacheService.getItems<ItemDTO>(
      key: 'items_achados',
      fetchFromApi: () => _dataSource.getItensAchados(),
      fromJson: (json) => ItemDTO.fromJson(json),
      toJson: (item) => item.toJson(),
      ttl: const Duration(minutes: 5),
    );
  }

  /// Busca itens DOADOS (com cache de 10 minutos)
  Future<List<ItemDTO>> getItensDoados() async {
    return await CacheService.getItems<ItemDTO>(
      key: 'items_doados',
      fetchFromApi: () => _dataSource.getItensDoados(),
      fromJson: (json) => ItemDTO.fromJson(json),
      toJson: (item) => item.toJson(),
      ttl: const Duration(minutes: 10),
    );
  }

  /// Busca itens por usuário (com cache de 7 minutos)
  Future<List<ItemDTO>> getItensByUser(int userId) async {
    return await CacheService.getItems<ItemDTO>(
      key: 'items_user_$userId',
      fetchFromApi: () => _dataSource.getByUser(userId),
      fromJson: (json) => ItemDTO.fromJson(json),
      toJson: (item) => item.toJson(),
      ttl: const Duration(minutes: 7),
    );
  }

  /// Busca itens por empresa
  Future<List<ItemDTO>> getItensByEmpresa(int empresaId) async {
    return await _dataSource.getByEmpresa(empresaId);
  }

  /// Busca itens por termo de pesquisa
  Future<List<ItemDTO>> searchItens(String term) async {
    return await _dataSource.search(term);
  }

  /// Cria um novo item (invalida cache de listas)
  Future<ItemDTO> createItem(CreateItemDTO dto) async {
    final item = await _dataSource.create(dto);
    // Invalidar caches relacionados
    await CacheService.invalidateItems('all_items');
    await CacheService.invalidateItems('active_items');
    return item;
  }

  /// Cria um item PERDIDO (invalida cache)
  Future<ItemDTO> createItemPerdido(
    ItemPerdidoCreateDTO dto, {
    List<String>? fotoPaths,
  }) async {
    final item = await _dataSource.createItemPerdido(dto, fotoPaths: fotoPaths);
    await CacheService.invalidateItems('items_perdidos');
    await CacheService.invalidateItems('all_items');
    await CacheService.invalidateItems('active_items');
    return item;
  }

  /// Cria um item ACHADO (invalida cache)
  Future<ItemDTO> createItemAchado(
    ItemAchadoCreateDTO dto, {
    required List<String> fotoPaths,
  }) async {
    final item = await _dataSource.createItemAchado(dto, fotoPaths: fotoPaths);
    await CacheService.invalidateItems('items_achados');
    await CacheService.invalidateItems('all_items');
    await CacheService.invalidateItems('active_items');
    return item;
  }

  /// Atualiza um item (invalida cache do item específico e listas)
  Future<ItemDTO> updateItem(int id, ItemUpdateDTO dto) async {
    final item = await _dataSource.update(id, dto);
    await CacheService.invalidateItems('item_$id');
    await CacheService.invalidateItems('all_items');
    await CacheService.invalidateItems('active_items');
    return item;
  }

  /// Deleta um item (invalida cache)
  Future<void> deleteItem(int id) async {
    await _dataSource.delete(id);
    await CacheService.invalidateItems('item_$id');
    await CacheService.invalidateItems('all_items');
    await CacheService.invalidateItems('active_items');
  }
}


