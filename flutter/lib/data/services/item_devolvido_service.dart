import '../datasources/item_devolvido_remote_datasource.dart';
import '../DTOs/item_devolvido_dto.dart';
import '../../core/error/exceptions.dart';

typedef AppException = ServerException;

/// Service para Itens Devolvidos
/// Camada de negócio sobre ItemDevolvidoRemoteDataSource
class ItemDevolvidoService {
  final ItemDevolvidoRemoteDataSource _dataSource;

  ItemDevolvidoService(this._dataSource);

  /// Lista todos os itens devolvidos
  Future<List<ItemDevolvidoDTO>> getAll() async {
    try {
      return await _dataSource.getAll();
    } catch (e) {
      throw AppException(message: 'Erro ao buscar itens devolvidos: $e');
    }
  }

  /// Busca item devolvido por ID
  Future<ItemDevolvidoDTO> getById(int id) async {
    try {
      return await _dataSource.getById(id);
    } catch (e) {
      throw AppException(message: 'Erro ao buscar item devolvido: $e');
    }
  }

  /// Registra nova devolução
  Future<ItemDevolvidoDTO> create(ItemDevolvidoCreateDTO dto) async {
    try {
      // Validação local: mínimo 20 caracteres
      if (dto.detalhesDevolucao.trim().length < 20) {
        throw AppException(message: 'Os detalhes da devolução devem ter pelo menos 20 caracteres');
      }
      return await _dataSource.create(dto);
    } catch (e) {
      throw AppException(message: 'Erro ao registrar devolução: $e');
    }
  }

  /// Atualiza registro de devolução
  Future<ItemDevolvidoDTO> update(int id, ItemDevolvidoUpdateDTO dto) async {
    try {
      return await _dataSource.update(id, dto);
    } catch (e) {
      throw AppException(message: 'Erro ao atualizar devolução: $e');
    }
  }

  /// Remove registro de devolução
  Future<void> delete(int id) async {
    try {
      await _dataSource.delete(id);
    } catch (e) {
      throw AppException(message: 'Erro ao deletar devolução: $e');
    }
  }

  /// Busca devoluções de um item
  Future<List<ItemDevolvidoDTO>> getByItem(int itemId) async {
    try {
      return await _dataSource.getByItem(itemId);
    } catch (e) {
      throw AppException(message: 'Erro ao buscar devoluções do item: $e');
    }
  }

  /// Verifica se item já foi devolvido
  Future<bool> itemJaDevolvido(int itemId) async {
    try {
      final devolicoes = await _dataSource.getByItem(itemId);
      return devolicoes.isNotEmpty;
    } catch (e) {
      throw AppException(message: 'Erro ao verificar devolução: $e');
    }
  }
}

