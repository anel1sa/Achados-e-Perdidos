import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../datasources/item_remote_datasource.dart';
import '../DTOs/item_dto.dart';
import '../DTOs/item_perdido_dto.dart';
import '../DTOs/item_achado_dto.dart';
import '../../core/network/dio_client.dart';

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

  /// Busca todos os itens
  Future<List<ItemDTO>> getAllItens() async {
    return await _dataSource.getAll();
  }

  /// Busca itens ativos
  Future<List<ItemDTO>> getItensAtivos() async {
    return await _dataSource.getAllActive();
  }

  /// Busca item por ID
  Future<ItemDTO> getItemById(int id) async {
    return await _dataSource.getById(id);
  }

  /// Busca itens por campus
  Future<List<ItemDTO>> getItensByCampus(int campusId) async {
    return await _dataSource.getByCampus(campusId);
  }


  /// Busca itens PERDIDOS
  Future<List<ItemDTO>> getItensPerdidos() async {
    return await _dataSource.getItensPerdidos();
  }

  /// Busca itens ACHADOS
  Future<List<ItemDTO>> getItensAchados() async {
    return await _dataSource.getItensAchados();
  }

  /// Busca itens DOADOS
  Future<List<ItemDTO>> getItensDoados() async {
    return await _dataSource.getItensDoados();
  }

  /// Busca itens por usuário
  Future<List<ItemDTO>> getItensByUser(int userId) async {
    return await _dataSource.getByUser(userId);
  }

  /// Busca itens por empresa
  Future<List<ItemDTO>> getItensByEmpresa(int empresaId) async {
    return await _dataSource.getByEmpresa(empresaId);
  }

  /// Busca itens por termo de pesquisa
  Future<List<ItemDTO>> searchItens(String term) async {
    return await _dataSource.search(term);
  }

  /// Cria um novo item
  Future<ItemDTO> createItem(CreateItemDTO dto) async {
    return await _dataSource.create(dto);
  }

  /// Cria um item PERDIDO (usa endpoint especializado)
  /// Se fotoPaths for fornecido, usa multipart/form-data, senão usa JSON
  Future<ItemDTO> createItemPerdido(
    ItemPerdidoCreateDTO dto, {
    List<String>? fotoPaths,
  }) async {
    return await _dataSource.createItemPerdido(dto, fotoPaths: fotoPaths);
  }

  /// Cria um item ACHADO (usa endpoint especializado)
  /// SEMPRE usa multipart/form-data (foto OBRIGATÓRIA)
  Future<ItemDTO> createItemAchado(
    ItemAchadoCreateDTO dto, {
    required List<String> fotoPaths,
  }) async {
    return await _dataSource.createItemAchado(dto, fotoPaths: fotoPaths);
  }

  /// Atualiza um item
  Future<ItemDTO> updateItem(int id, ItemUpdateDTO dto) async {
    return await _dataSource.update(id, dto);
  }

  /// Deleta um item
  Future<void> deleteItem(int id) async {
    return await _dataSource.delete(id);
  }
}


