import '../datasources/reivindicacao_remote_datasource.dart';
import '../DTOs/reivindicacao_dto.dart';
import '../../core/error/exceptions.dart';

typedef AppException = ServerException;

/// Service para Reivindicações
/// Camada de negócio sobre ReivindicacaoRemoteDataSource
class ReivindicacaoService {
  final ReivindicacaoRemoteDataSource _dataSource;

  ReivindicacaoService(this._dataSource);

  /// Lista todas as reivindicações
  Future<List<ReivindicacaoDTO>> getAll() async {
    try {
      return await _dataSource.getAll();
    } catch (e) {
      throw AppException(message: 'Erro ao buscar reivindicações: $e');
    }
  }

  /// Busca reivindicação por ID
  Future<ReivindicacaoDTO> getById(int id) async {
    try {
      return await _dataSource.getById(id);
    } catch (e) {
      throw AppException(message: 'Erro ao buscar reivindicação: $e');
    }
  }

  /// Cria nova reivindicação
  Future<ReivindicacaoDTO> create(ReivindicacaoCreateDTO dto) async {
    try {
      return await _dataSource.create(dto);
    } catch (e) {
      throw AppException(message: 'Erro ao criar reivindicação: $e');
    }
  }

  /// Atualiza reivindicação (aprovar/rejeitar)
  Future<ReivindicacaoDTO> update(int id, ReivindicacaoUpdateDTO dto) async {
    try {
      return await _dataSource.update(id, dto);
    } catch (e) {
      throw AppException(message: 'Erro ao atualizar reivindicação: $e');
    }
  }

  /// Aprova uma reivindicação
  Future<ReivindicacaoDTO> aprovar(int id) async {
    try {
      return await _dataSource.update(
        id,
        ReivindicacaoUpdateDTO(status: StatusReivindicacao.APROVADA.name),
      );
    } catch (e) {
      throw AppException(message: 'Erro ao aprovar reivindicação: $e');
    }
  }

  /// Rejeita uma reivindicação
  Future<ReivindicacaoDTO> rejeitar(int id) async {
    try {
      return await _dataSource.update(
        id,
        ReivindicacaoUpdateDTO(status: StatusReivindicacao.REJEITADA.name),
      );
    } catch (e) {
      throw AppException(message: 'Erro ao rejeitar reivindicação: $e');
    }
  }

  /// Remove reivindicação
  Future<void> delete(int id) async {
    try {
      await _dataSource.delete(id);
    } catch (e) {
      throw AppException(message: 'Erro ao deletar reivindicação: $e');
    }
  }

  /// Busca reivindicações de um item
  Future<List<ReivindicacaoDTO>> getByItem(int itemId) async {
    try {
      return await _dataSource.getByItem(itemId);
    } catch (e) {
      throw AppException(message: 'Erro ao buscar reivindicações do item: $e');
    }
  }

  /// Busca reivindicações feitas por um usuário
  Future<List<ReivindicacaoDTO>> getByUser(int userId) async {
    try {
      return await _dataSource.getByUser(userId);
    } catch (e) {
      throw AppException(message: 'Erro ao buscar reivindicações do usuário: $e');
    }
  }

  /// Busca reivindicações recebidas por um usuário (proprietário)
  Future<List<ReivindicacaoDTO>> getByProprietario(int proprietarioId) async {
    try {
      return await _dataSource.getByProprietario(proprietarioId);
    } catch (e) {
      throw AppException(message: 'Erro ao buscar reivindicações recebidas: $e');
    }
  }

  /// Verifica se usuário já reivindicou um item
  Future<bool> usuarioJaReivindicou(int itemId, int userId) async {
    try {
      final reivindicacao = await _dataSource.getByItemAndUser(itemId, userId);
      return reivindicacao != null;
    } catch (e) {
      throw AppException(message: 'Erro ao verificar reivindicação: $e');
    }
  }

  /// Busca reivindicação específica de um item por um usuário
  Future<ReivindicacaoDTO?> getByItemAndUser(int itemId, int userId) async {
    try {
      return await _dataSource.getByItemAndUser(itemId, userId);
    } catch (e) {
      throw AppException(message: 'Erro ao buscar reivindicação: $e');
    }
  }
}
