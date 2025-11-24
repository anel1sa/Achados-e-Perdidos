import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/item_dto.dart';
import '../DTOs/item_perdido_dto.dart';
import '../DTOs/item_achado_dto.dart';

class ItemRemoteDataSource {
  final Dio _dio;

  ItemRemoteDataSource(this._dio);

  /// GET /api/itens
  Future<List<ItemDTO>> getAll() async {
    try {
      final response = await _dio.get(ApiConstants.itens);
      
      if (response.statusCode == 200) {
        // A API retorna { itens: [...], totalCount: X }
        final data = response.data;
        if (data is Map && data.containsKey('itens')) {
          final List<dynamic> itens = data['itens'];
          return itens.map((json) => ItemDTO.fromJson(json)).toList();
        } else if (data is List) {
          // Fallback para formato antigo (lista direta)
          return data.map((json) => ItemDTO.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens/active
  Future<List<ItemDTO>> getAllActive() async {
    try {
      final response = await _dio.get(ApiConstants.itensActive);
      
      if (response.statusCode == 200) {
        // A API retorna { itens: [...], totalCount: X }
        final data = response.data;
        if (data is Map && data.containsKey('itens')) {
          final List<dynamic> itens = data['itens'];
          return itens.map((json) => ItemDTO.fromJson(json)).toList();
        } else if (data is List) {
          // Fallback para formato antigo (lista direta)
          return data.map((json) => ItemDTO.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens ativos',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens ativos',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens/{id}
  Future<ItemDTO> getById(int id) async {
    try {
      final response = await _dio.get(ApiConstants.itemById(id));
      
      if (response.statusCode == 200) {
        return ItemDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao buscar item',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar item',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens/campus/{campusId}
  Future<List<ItemDTO>> getByCampus(int campusId) async {
    try {
      final response = await _dio.get(ApiConstants.itensByCampus(campusId));
      
      if (response.statusCode == 200) {
        // A API retorna { itens: [...], totalCount: X }
        final data = response.data;
        if (data is Map && data.containsKey('itens')) {
          final List<dynamic> itens = data['itens'];
          return itens.map((json) => ItemDTO.fromJson(json)).toList();
        } else if (data is List) {
          // Fallback para formato antigo (lista direta)
          return data.map((json) => ItemDTO.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens por campus',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens',
        statusCode: e.response?.statusCode,
      );
    }
  }


  /// GET /api/itens/status/{statusId} (DEPRECATED)
  @Deprecated('Use getItensPerdidos, getItensAchados ou getItensDoados')
  Future<List<ItemDTO>> getByStatus(int statusId) async {
    try {
      // Mapeia statusId antigo para novo endpoint
      String endpoint;
      if (statusId == 1) {
        endpoint = ApiConstants.itensAchados;
      } else if (statusId == 2) {
        endpoint = ApiConstants.itensPerdidos;
      } else if (statusId == 3) {
        endpoint = ApiConstants.itensDoados;
      } else {
        throw ValidationException(message: 'Status inválido: $statusId');
      }
      
      final response = await _dio.get(endpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ItemDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens por status',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens-achados (NEW)
  Future<List<ItemDTO>> getItensAchados() async {
    try {
      final response = await _dio.get(ApiConstants.itensAchados);
      
      if (response.statusCode == 200) {
        // A API retorna { itensAchados: [...], totalCount: X }
        final data = response.data;
        if (data is Map && data.containsKey('itensAchados')) {
          final List<dynamic> itensAchados = data['itensAchados'];
          // ItemAchadoDTO pode ter estrutura diferente, vamos tentar converter
          return itensAchados.map((json) {
            // Se já for ItemDTO, retorna direto
            if (json.containsKey('tipoItem')) {
              return ItemDTO.fromJson(json);
            }
            // Se for ItemAchadoDTO, precisa converter
            // Por enquanto, vamos assumir que tem os campos básicos
            return ItemDTO.fromJson(json);
          }).toList();
        } else if (data is List) {
          // Fallback para formato antigo (lista direta)
          return data.map((json) => ItemDTO.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens achados',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens achados',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens-perdidos (NEW)
  Future<List<ItemDTO>> getItensPerdidos() async {
    try {
      final response = await _dio.get(ApiConstants.itensPerdidos);
      
      if (response.statusCode == 200) {
        // A API retorna { itensPerdidos: [...], totalCount: X }
        final data = response.data;
        if (data is Map && data.containsKey('itensPerdidos')) {
          final List<dynamic> itensPerdidos = data['itensPerdidos'];
          // ItemPerdidoDTO pode ter estrutura diferente, vamos tentar converter
          return itensPerdidos.map((json) {
            // Se já for ItemDTO, retorna direto
            if (json.containsKey('tipoItem')) {
              return ItemDTO.fromJson(json);
            }
            // Se for ItemPerdidoDTO, precisa converter
            // Por enquanto, vamos assumir que tem os campos básicos
            return ItemDTO.fromJson(json);
          }).toList();
        } else if (data is List) {
          // Fallback para formato antigo (lista direta)
          return data.map((json) => ItemDTO.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens perdidos',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens perdidos',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens-doados (NEW)
  Future<List<ItemDTO>> getItensDoados() async {
    try {
      final response = await _dio.get(ApiConstants.itensDoados);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ItemDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens doados',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens doados',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens/user/{userId}
  Future<List<ItemDTO>> getByUser(int userId) async {
    try {
      final response = await _dio.get(ApiConstants.itensByUser(userId));
      
      if (response.statusCode == 200) {
        // A API retorna { itens: [...], totalCount: X }
        final data = response.data;
        if (data is Map && data.containsKey('itens')) {
          final List<dynamic> itens = data['itens'];
          return itens.map((json) => ItemDTO.fromJson(json)).toList();
        } else if (data is List) {
          // Fallback para formato antigo (lista direta)
          return data.map((json) => ItemDTO.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens do usuário',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens do usuário',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens/empresa/{empresaId}
  Future<List<ItemDTO>> getByEmpresa(int empresaId) async {
    try {
      final response = await _dio.get(ApiConstants.itensByEmpresa(empresaId));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ItemDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens da empresa',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens da empresa',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/itens/search?term=xxx
  Future<List<ItemDTO>> search(String term) async {
    try {
      final response = await _dio.get(
        ApiConstants.itensSearch,
        queryParameters: {'term': term},
      );
      
      if (response.statusCode == 200) {
        // A API retorna { itens: [...], totalCount: X }
        final data = response.data;
        if (data is Map && data.containsKey('itens')) {
          final List<dynamic> itens = data['itens'];
          return itens.map((json) => ItemDTO.fromJson(json)).toList();
        } else if (data is List) {
          // Fallback para formato antigo (lista direta)
          return data.map((json) => ItemDTO.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar itens',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar itens',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/itens
  Future<ItemDTO> create(CreateItemDTO dto) async {
    try {
      print('[ItemRemoteDataSource] POST ${ApiConstants.itens}');
      print('[ItemRemoteDataSource] DTO: ${dto.toJson()}');
      
      final response = await _dio.post(
        ApiConstants.itens,
        data: dto.toJson(),
      );
      
      print('[ItemRemoteDataSource] Response status: ${response.statusCode}');
      print('[ItemRemoteDataSource] Response data: ${response.data}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ItemDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao criar item',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('[ItemRemoteDataSource] DioException: ${e.message}');
      print('[ItemRemoteDataSource] Response: ${e.response?.data}');
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao criar item',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/itens-perdidos (NEW - especializado)
  /// Aceita JSON (sem foto) ou multipart/form-data (com foto)
  Future<ItemDTO> createItemPerdido(
    ItemPerdidoCreateDTO dto, {
    List<String>? fotoPaths,
  }) async {
    try {
      print('[ItemRemoteDataSource] POST ${ApiConstants.itensPerdidos}');
      print('[ItemRemoteDataSource] DTO: ${dto.toJson()}');
      print('[ItemRemoteDataSource] Fotos: ${fotoPaths?.length ?? 0}');
      
      Response response;
      
      // Se houver fotos, usa multipart/form-data
      if (fotoPaths != null && fotoPaths.isNotEmpty) {
        print('[ItemRemoteDataSource] Usando multipart/form-data (com fotos)');
        
        // Prepara o JSON do item (sem o campo fotos)
        final itemJson = dto.toJson();
        itemJson.remove('fotos'); // Remove fotos do JSON pois será enviado como arquivo
        
        // Cria FormData com o item JSON e os arquivos
        // Usa MultipartFile.fromString para garantir Content-Type: application/json
        final formData = FormData.fromMap({
          'item': MultipartFile.fromString(
            jsonEncode(itemJson),
            contentType: MediaType('application', 'json', {'charset': 'utf-8'}),
          ),
        });
        
        // Adiciona cada arquivo
        for (var filePath in fotoPaths) {
          final fileName = filePath.split('/').last;
          formData.files.add(
            MapEntry(
              'file',
              await MultipartFile.fromFile(
                filePath,
                filename: fileName,
              ),
            ),
          );
        }
        
        response = await _dio.post(
          ApiConstants.itensPerdidos,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
          ),
        );
      } else {
        // Se não houver fotos, usa JSON simples
        print('[ItemRemoteDataSource] Usando application/json (sem fotos)');
        
        // Remove fotos do JSON se estiver vazio
        final jsonData = dto.toJson();
        if (jsonData.containsKey('fotos') && (dto.fotos == null || dto.fotos!.isEmpty)) {
          jsonData.remove('fotos');
        }
        
        response = await _dio.post(
          ApiConstants.itensPerdidos,
          data: jsonData,
        );
      }
      
      print('[ItemRemoteDataSource] Response status: ${response.statusCode}');
      print('[ItemRemoteDataSource] Response data: ${response.data}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // A API retorna ItemPerdidoDTO que só tem id, itemId, perdidoEm, etc
        // Precisamos buscar o ItemDTO completo usando o itemId
        final itemPerdidoData = response.data;
        final itemId = itemPerdidoData['itemId'] ?? itemPerdidoData['id'];
        
        if (itemId != null) {
          try {
            // Buscar o item completo
            final itemResponse = await _dio.get(ApiConstants.itemById(itemId is int ? itemId : (itemId as num).toInt()));
            if (itemResponse.statusCode == 200) {
              return ItemDTO.fromJson(itemResponse.data);
            }
          } catch (e) {
            print('[ItemRemoteDataSource] Erro ao buscar item completo: $e');
            // Continua para criar ItemDTO básico
          }
        }
        
        // Se não conseguir buscar o item completo, retorna um ItemDTO básico
        // usando os dados do DTO enviado
        final finalItemId = itemPerdidoData['id'] ?? itemPerdidoData['itemId'] ?? 0;
        return ItemDTO(
          id: finalItemId is int ? finalItemId : (finalItemId as num).toInt(),
          nome: dto.nome,
          descricao: dto.descricao,
          tipoItem: TipoItem.PERDIDO,
          descLocalItem: dto.descLocalItem,
          usuarioRelatorId: dto.usuarioRelatorId ?? 0,
          dtaCriacao: DateTime.now(),
          flgInativo: false,
        );
      } else {
        throw ServerException(
          message: 'Erro ao criar item perdido',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('[ItemRemoteDataSource] DioException: ${e.message}');
      print('[ItemRemoteDataSource] Response: ${e.response?.data}');
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao criar item perdido',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/itens-achados (NEW - especializado)
  /// SEMPRE usa multipart/form-data (foto OBRIGATÓRIA)
  Future<ItemDTO> createItemAchado(
    ItemAchadoCreateDTO dto, {
    required List<String> fotoPaths,
  }) async {
    try {
      print('[ItemRemoteDataSource] POST ${ApiConstants.itensAchados}');
      print('[ItemRemoteDataSource] DTO: ${dto.toJson()}');
      print('[ItemRemoteDataSource] Fotos: ${fotoPaths.length}');
      
      // Validação: foto é obrigatória para itens achados
      if (fotoPaths.isEmpty) {
        throw ValidationException(message: 'Foto é obrigatória para itens achados');
      }
      
      // Prepara o JSON do item (sem o campo fotos)
      final itemJson = dto.toJson();
      itemJson.remove('fotos'); // Remove fotos do JSON pois será enviado como arquivo
      
      // Cria FormData com o item JSON e os arquivos
      // Usa MultipartFile.fromString para garantir Content-Type: application/json
      final formData = FormData.fromMap({
        'item': MultipartFile.fromString(
          jsonEncode(itemJson),
          contentType: MediaType('application', 'json', {'charset': 'utf-8'}),
        ),
      });
      
      // Adiciona cada arquivo com a chave 'files' (plural) - API espera 'files'
      for (var filePath in fotoPaths) {
        final fileName = filePath.split('/').last;
        formData.files.add(
          MapEntry(
            'files', // API espera 'files' (plural) para itens achados
            await MultipartFile.fromFile(
              filePath,
              filename: fileName,
            ),
          ),
        );
      }
      
      print('[ItemRemoteDataSource] Usando multipart/form-data (foto obrigatória)');
      print('[ItemRemoteDataSource] Total de arquivos: ${fotoPaths.length}');
      final response = await _dio.post(
        ApiConstants.itensAchados,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      
      print('[ItemRemoteDataSource] Response status: ${response.statusCode}');
      print('[ItemRemoteDataSource] Response data: ${response.data}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // A API retorna ItemAchadoDTO que só tem id, itemId, encontradoEm, etc
        // Precisamos buscar o ItemDTO completo usando o itemId
        final itemAchadoData = response.data;
        final itemId = itemAchadoData['itemId'] ?? itemAchadoData['id'];
        
        if (itemId != null) {
          try {
            // Buscar o item completo
            final itemResponse = await _dio.get(ApiConstants.itemById(itemId is int ? itemId : (itemId as num).toInt()));
            if (itemResponse.statusCode == 200) {
              return ItemDTO.fromJson(itemResponse.data);
            }
          } catch (e) {
            print('[ItemRemoteDataSource] Erro ao buscar item completo: $e');
            // Continua para criar ItemDTO básico
          }
        }
        
        // Se não conseguir buscar o item completo, retorna um ItemDTO básico
        // usando os dados do DTO enviado
        final finalItemId = itemAchadoData['id'] ?? itemAchadoData['itemId'] ?? 0;
        return ItemDTO(
          id: finalItemId is int ? finalItemId : (finalItemId as num).toInt(),
          nome: dto.nome,
          descricao: dto.descricao,
          tipoItem: TipoItem.ACHADO,
          descLocalItem: dto.descLocalItem,
          usuarioRelatorId: dto.usuarioRelatorId ?? 0,
          dtaCriacao: DateTime.now(),
          flgInativo: false,
        );
      } else {
        throw ServerException(
          message: 'Erro ao criar item achado',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('[ItemRemoteDataSource] DioException: ${e.message}');
      print('[ItemRemoteDataSource] Response: ${e.response?.data}');
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao criar item achado',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// PUT /api/itens/{id}
  Future<ItemDTO> update(int id, ItemUpdateDTO dto) async {
    try {
      final response = await _dio.put(
        ApiConstants.itemById(id),
        data: dto.toJson(),
      );
      
      if (response.statusCode == 200) {
        return ItemDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao atualizar item',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao atualizar item',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// DELETE /api/itens/{id}
  Future<void> delete(int id) async {
    try {
      final response = await _dio.delete(ApiConstants.itemById(id));
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao deletar item',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao deletar item',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

