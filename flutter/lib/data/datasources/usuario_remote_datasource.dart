import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/usuario_dto.dart';
import '../DTOs/usuario_dto.dart';

class UsuarioRemoteDataSource {
  final Dio _dio;

  UsuarioRemoteDataSource(this._dio);

  /// GET /api/usuarios
  Future<List<UsuarioDTO>> getAll() async {
    try {
      final response = await _dio.get(ApiConstants.usuarios);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => UsuarioDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar usuários',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar usuários',
        statusCode: e.response?.statusCode,
      );
    }
  }


  /// GET /api/usuarios/active
  Future<List<UsuarioDTO>> getAllActive() async {
    try {
      final response = await _dio.get(ApiConstants.usuariosActive);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => UsuarioDTO.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar usuários ativos',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar usuários ativos',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/usuarios/{id}
  Future<UsuarioDTO> getById(int id) async {
    try {
      final response = await _dio.get(ApiConstants.usuarioById(id));
      
      if (response.statusCode == 200) {
        // A API retorna {usuarios: [...], totalCount: 1}
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('usuarios')) {
          final usuarios = data['usuarios'] as List;
          if (usuarios.isNotEmpty) {
            return UsuarioDTO.fromJson(usuarios[0]);
          }
        }
        // Se não tiver o formato esperado, tenta parsear direto
        return UsuarioDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao buscar usuário',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar usuário',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/usuarios/email/{email}
  Future<UsuarioDTO> getByEmail(String email) async {
    try {
      final response = await _dio.get(ApiConstants.usuarioByEmail(email));
      
      if (response.statusCode == 200) {
        return UsuarioDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao buscar usuário por email',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar usuário',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/usuarios
  Future<UsuarioDTO> create(UsuarioCreateDTO dto) async {
    try {
      final response = await _dio.post(
        ApiConstants.usuarios,
        data: dto.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return UsuarioDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao criar usuário',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao criar usuário',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/usuarios/aluno
  /// Cria usuário do tipo ALUNO com validações específicas
  /// 
  /// Campos enviados:
  /// - nomeCompleto (obrigatório)
  /// - email (obrigatório)
  /// - senha (obrigatório)
  /// - matricula (obrigatório)
  /// - numeroTelefone (opcional)
  /// - campusId (obrigatório)
  /// 
  /// Campos NÃO enviados:
  /// - cpf (removido explicitamente)
  /// - enderecoId (removido se null ou 0)
  Future<UsuarioDTO> createAluno(UsuarioCreateDTO dto) async {
    try {
      final jsonData = dto.toJson();
      
      // Limpa o JSON: remove null e campos que não devem ser enviados para ALUNO
      final cleanedJson = <String, dynamic>{};
      jsonData.forEach((key, value) {
        // Não envia campos null
        if (value == null) return;
        
        // Para ALUNO, não envia CPF (mesmo que não seja null)
        if (key == 'cpf') return;
        
        // Não envia enderecoId se for 0 ou null
        if (key == 'enderecoId' && (value == null || value == 0)) return;
        
        cleanedJson[key] = value;
      });
      
      final response = await _dio.post(
        ApiConstants.usuariosAluno,
        data: cleanedJson,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          // Log do que está sendo retornado
          print('[UsuarioRemoteDataSource] Resposta do backend: ${response.data}');
          print('[UsuarioRemoteDataSource] Tipo da resposta: ${response.data.runtimeType}');
          
          // Garante que o id existe, se não existir, adiciona um valor padrão temporário
          Map<String, dynamic> responseData;
          if (response.data is Map) {
            responseData = Map<String, dynamic>.from(response.data as Map);
          } else {
            throw ServerException(
              message: 'Resposta do servidor em formato inválido',
              statusCode: response.statusCode,
            );
          }
          
          // Se não tiver id, adiciona um valor temporário (o backend deveria retornar)
          if (!responseData.containsKey('id') || responseData['id'] == null) {
            print('[UsuarioRemoteDataSource] AVISO: id não encontrado na resposta, usando 0 temporariamente');
            responseData['id'] = 0; // Valor temporário, o backend deveria retornar o id
          }
          
          print('[UsuarioRemoteDataSource] Dados processados: $responseData');
          return UsuarioDTO.fromJson(responseData);
        } catch (e, stackTrace) {
          print('[UsuarioRemoteDataSource] Erro ao deserializar resposta: $e');
          print('[UsuarioRemoteDataSource] Stack trace: $stackTrace');
          throw ServerException(
            message: 'Erro ao processar resposta do servidor: ${e.toString()}',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Erro ao criar aluno',
          statusCode: response.statusCode,
        );
      }
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      // O _errorInterceptor já converteu para ValidationException ou ServerException
      if (e.error is ValidationException) {
        throw e.error as ValidationException;
      }
      if (e.error is ServerException) {
        throw e.error as ServerException;
      }
      
      // Se não foi convertido, tenta extrair a mensagem manualmente
      String message = 'Erro ao criar aluno. Verifique os dados informados.';
      Map<String, String>? errors;
      
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          final data = e.response!.data as Map;
          message = data['message'] as String? ?? 
                   data['error'] as String? ?? 
                   message;
          
          // Tenta extrair erros de validação
          if (data['errors'] != null) {
            final errorsData = data['errors'];
            if (errorsData is Map) {
              errors = errorsData.map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              );
            }
          }
        } else if (e.response!.data is String) {
          message = e.response!.data as String;
        }
      }
      
      if (e.response?.statusCode == 400) {
        throw ValidationException(message: message, errors: errors);
      }
      
      throw ServerException(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/usuarios/servidor
  /// Cria usuário do tipo SERVIDOR com validações específicas
  /// 
  /// Campos enviados:
  /// - nomeCompleto (obrigatório)
  /// - cpf (obrigatório, 11 dígitos)
  /// - email (obrigatório)
  /// - senha (obrigatório)
  /// - numeroTelefone (opcional)
  /// - campusId (obrigatório)
  /// 
  /// Campos NÃO enviados:
  /// - matricula (removido explicitamente)
  /// - enderecoId (removido se null ou 0)
  Future<UsuarioDTO> createServidor(UsuarioCreateDTO dto) async {
    try {
      final jsonData = dto.toJson();
      
      // Limpa o JSON: remove null e campos que não devem ser enviados para SERVIDOR
      final cleanedJson = <String, dynamic>{};
      jsonData.forEach((key, value) {
        // Não envia campos null
        if (value == null) return;
        
        // Para SERVIDOR, não envia matrícula (mesmo que não seja null)
        if (key == 'matricula') return;
        
        // Não envia enderecoId se for 0 ou null
        if (key == 'enderecoId' && (value == null || value == 0)) return;
        
        cleanedJson[key] = value;
      });
      
      final response = await _dio.post(
        ApiConstants.usuariosServidor,
        data: cleanedJson,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          // Log do que está sendo retornado
          print('[UsuarioRemoteDataSource] Resposta do backend: ${response.data}');
          print('[UsuarioRemoteDataSource] Tipo da resposta: ${response.data.runtimeType}');
          
          // Garante que o id existe, se não existir, adiciona um valor padrão temporário
          Map<String, dynamic> responseData;
          if (response.data is Map) {
            responseData = Map<String, dynamic>.from(response.data as Map);
          } else {
            throw ServerException(
              message: 'Resposta do servidor em formato inválido',
              statusCode: response.statusCode,
            );
          }
          
          // Se não tiver id, adiciona um valor temporário (o backend deveria retornar)
          if (!responseData.containsKey('id') || responseData['id'] == null) {
            print('[UsuarioRemoteDataSource] AVISO: id não encontrado na resposta, usando 0 temporariamente');
            responseData['id'] = 0; // Valor temporário, o backend deveria retornar o id
          }
          
          print('[UsuarioRemoteDataSource] Dados processados: $responseData');
          return UsuarioDTO.fromJson(responseData);
        } catch (e, stackTrace) {
          print('[UsuarioRemoteDataSource] Erro ao deserializar resposta: $e');
          print('[UsuarioRemoteDataSource] Stack trace: $stackTrace');
          throw ServerException(
            message: 'Erro ao processar resposta do servidor: ${e.toString()}',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Erro ao criar servidor',
          statusCode: response.statusCode,
        );
      }
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      // O _errorInterceptor já converteu para ValidationException ou ServerException
      if (e.error is ValidationException) {
        throw e.error as ValidationException;
      }
      if (e.error is ServerException) {
        throw e.error as ServerException;
      }
      
      // Se não foi convertido, tenta extrair a mensagem manualmente
      String message = 'Erro ao criar servidor. Verifique os dados informados.';
      Map<String, String>? errors;
      
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          final data = e.response!.data as Map;
          message = data['message'] as String? ?? 
                   data['error'] as String? ?? 
                   message;
          
          // Tenta extrair erros de validação
          if (data['errors'] != null) {
            final errorsData = data['errors'];
            if (errorsData is Map) {
              errors = errorsData.map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              );
            }
          }
        } else if (e.response!.data is String) {
          message = e.response!.data as String;
        }
      }
      
      if (e.response?.statusCode == 400) {
        throw ValidationException(message: message, errors: errors);
      }
      
      throw ServerException(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// PUT /api/usuarios/{id}
  Future<UsuarioDTO> update(int id, UsuarioUpdateDTO dto) async {
    try {
      final response = await _dio.put(
        ApiConstants.usuarioById(id),
        data: dto.toJson(),
      );
      
      if (response.statusCode == 200) {
        return UsuarioDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao atualizar usuário',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao atualizar usuário',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/usuarios/{id}/alterar-senha
  Future<void> changePassword(int id, AlterarSenhaDTO dto) async {
    try {
      final response = await _dio.post(
        ApiConstants.alterarSenha(id),
        data: dto.toJson(),
      );
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao alterar senha',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao alterar senha',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// DELETE /api/usuarios/{id}
  Future<void> delete(int id) async {
    try {
      final response = await _dio.delete(ApiConstants.usuarioById(id));
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao deletar usuário',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao deletar usuário',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

