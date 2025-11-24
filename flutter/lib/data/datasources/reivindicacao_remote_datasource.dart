import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/reivindicacao_dto.dart';

typedef AppException = ServerException;

/// DataSource para Reivindicações
/// Comunicação HTTP com /api/reivindicacoes
class ReivindicacaoRemoteDataSource {
  final http.Client client;
  final String baseUrl = ApiConstants.BASE_URL;

  ReivindicacaoRemoteDataSource({required this.client});

  /// GET /api/reivindicacoes - Lista todas as reivindicações
  Future<List<ReivindicacaoDTO>> getAll() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/reivindicacoes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => ReivindicacaoDTO.fromJson(json)).toList();
      } else {
        throw AppException(message: 'Erro ao buscar reivindicações: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// GET /api/reivindicacoes/{id} - Busca reivindicação por ID
  Future<ReivindicacaoDTO> getById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/reivindicacoes/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return ReivindicacaoDTO.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 404) {
        throw AppException(message: 'Reivindicação não encontrada');
      } else {
        throw AppException(message: 'Erro ao buscar reivindicação: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// POST /api/reivindicacoes - Cria nova reivindicação
  Future<ReivindicacaoDTO> create(ReivindicacaoCreateDTO dto) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/reivindicacoes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ReivindicacaoDTO.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 400) {
        throw AppException(message: 'Dados inválidos: ${response.body}');
      } else {
        throw AppException(message: 'Erro ao criar reivindicação: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// PUT /api/reivindicacoes/{id} - Atualiza reivindicação (aprovar/rejeitar)
  Future<ReivindicacaoDTO> update(int id, ReivindicacaoUpdateDTO dto) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/reivindicacoes/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        return ReivindicacaoDTO.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 404) {
        throw AppException(message: 'Reivindicação não encontrada');
      } else {
        throw AppException(message: 'Erro ao atualizar reivindicação: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// DELETE /api/reivindicacoes/{id} - Remove reivindicação
  Future<void> delete(int id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/reivindicacoes/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw AppException(message: 'Erro ao deletar reivindicação: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// GET /api/reivindicacoes/item/{itemId} - Reivindicações de um item
  Future<List<ReivindicacaoDTO>> getByItem(int itemId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/reivindicacoes/item/$itemId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => ReivindicacaoDTO.fromJson(json)).toList();
      } else {
        throw AppException(message: 'Erro ao buscar reivindicações do item: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// GET /api/reivindicacoes/user/{userId} - Reivindicações de um usuário
  Future<List<ReivindicacaoDTO>> getByUser(int userId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/reivindicacoes/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => ReivindicacaoDTO.fromJson(json)).toList();
      } else {
        throw AppException(message: 'Erro ao buscar reivindicações do usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// GET /api/reivindicacoes/proprietario/{id} - Reivindicações recebidas
  Future<List<ReivindicacaoDTO>> getByProprietario(int proprietarioId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/reivindicacoes/proprietario/$proprietarioId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => ReivindicacaoDTO.fromJson(json)).toList();
      } else {
        throw AppException(message: 'Erro ao buscar reivindicações recebidas: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// GET /api/reivindicacoes/item/{itemId}/user/{userId} - Reivindicação específica
  Future<ReivindicacaoDTO?> getByItemAndUser(int itemId, int userId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/reivindicacoes/item/$itemId/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return ReivindicacaoDTO.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 404) {
        return null; // Nenhuma reivindicação encontrada
      } else {
        throw AppException(message: 'Erro ao buscar reivindicação: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }
}

