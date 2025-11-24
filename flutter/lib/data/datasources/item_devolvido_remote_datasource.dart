import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/item_devolvido_dto.dart';

typedef AppException = ServerException;

/// DataSource para Itens Devolvidos
/// Comunicação HTTP com /api/itens-devolvidos
class ItemDevolvidoRemoteDataSource {
  final http.Client client;
  final String baseUrl = ApiConstants.BASE_URL;

  ItemDevolvidoRemoteDataSource({required this.client});

  /// GET /api/itens-devolvidos - Lista todos os itens devolvidos
  Future<List<ItemDevolvidoDTO>> getAll() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/itens-devolvidos'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => ItemDevolvidoDTO.fromJson(json)).toList();
      } else {
        throw AppException(message: 'Erro ao buscar itens devolvidos: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// GET /api/itens-devolvidos/{id} - Busca item devolvido por ID
  Future<ItemDevolvidoDTO> getById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/itens-devolvidos/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return ItemDevolvidoDTO.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 404) {
        throw AppException(message: 'Item devolvido não encontrado');
      } else {
        throw AppException(message: 'Erro ao buscar item devolvido: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// POST /api/itens-devolvidos - Registra nova devolução
  Future<ItemDevolvidoDTO> create(ItemDevolvidoCreateDTO dto) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/itens-devolvidos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ItemDevolvidoDTO.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 400) {
        throw AppException(message: 'Dados inválidos: ${response.body}');
      } else {
        throw AppException(message: 'Erro ao registrar devolução: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// PUT /api/itens-devolvidos/{id} - Atualiza registro de devolução
  Future<ItemDevolvidoDTO> update(int id, ItemDevolvidoUpdateDTO dto) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/itens-devolvidos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        return ItemDevolvidoDTO.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 404) {
        throw AppException(message: 'Item devolvido não encontrado');
      } else {
        throw AppException(message: 'Erro ao atualizar devolução: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// DELETE /api/itens-devolvidos/{id} - Remove registro de devolução
  Future<void> delete(int id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/itens-devolvidos/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw AppException(message: 'Erro ao deletar devolução: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }

  /// GET /api/itens-devolvidos/item/{itemId} - Devoluções de um item
  Future<List<ItemDevolvidoDTO>> getByItem(int itemId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/itens-devolvidos/item/$itemId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => ItemDevolvidoDTO.fromJson(json)).toList();
      } else {
        throw AppException(message: 'Erro ao buscar devoluções do item: ${response.statusCode}');
      }
    } catch (e) {
      throw AppException(message: 'Falha na comunicação: $e');
    }
  }
}

