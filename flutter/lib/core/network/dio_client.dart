import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import '../error/exceptions.dart';
import '../cache/cache_service.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final Logger _logger = Logger();

  // URL base da API
  static const String baseUrl = 'https://api-achadosperdidos.com.br';
  static const int timeout = 30000; // 30 segundos

  DioClient({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage {

    _dio = Dio(
      BaseOptions(
        baseUrl: DioClient.baseUrl,
        connectTimeout: Duration(milliseconds: DioClient.timeout),
        receiveTimeout: Duration(milliseconds: DioClient.timeout),
        headers: {
          ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
        },
        // Garante que o Dio sempre tente parsear o response, mesmo em caso de erro
        validateStatus: (status) {
          // Permite que o Dio processe todos os status codes
          // O tratamento de erro será feito no interceptor
          return status != null && status < 600;
        },
      ),
    );

    _dio.interceptors.addAll([
      _authInterceptor(),
      _loggerInterceptor(),
      _errorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  // Auth Interceptor - Adiciona token JWT automaticamente
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Se for FormData, remove Content-Type para o Dio definir automaticamente com boundary
        if (options.data is FormData) {
          options.headers.remove(ApiConstants.contentTypeHeader);
        }
        
        // Não adiciona token para endpoints de autenticação e cadastro
        final path = options.path.toLowerCase();
        if (path.contains('/login') || 
            path.contains('/google-auth') ||
            path.contains('/cadastro') ||
            path.contains('/usuarios/aluno') ||
            path.contains('/usuarios/servidor')) {
          return handler.next(options);
        }

        // Adiciona token JWT
        final token = await _secureStorage.read(key: StorageKeys.accessToken);
        if (token != null) {
          options.headers[ApiConstants.authorizationHeader] = 
              '${ApiConstants.bearerPrefix}$token';
        }

        return handler.next(options);
      },
    );
  }

  // Logger Interceptor - Log de requisições e respostas
  InterceptorsWrapper _loggerInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('''
        ┌─────────────────────────────────────────────────────────────────
        │ REQUEST
        ├─────────────────────────────────────────────────────────────────
        │ Method: ${options.method}
        │ URL: ${options.baseUrl}${options.path}
        │ Headers: ${options.headers}
        │ Query Parameters: ${options.queryParameters}
        │ Body: ${options.data}
        └─────────────────────────────────────────────────────────────────
        ''');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('''
        ┌─────────────────────────────────────────────────────────────────
        │ RESPONSE
        ├─────────────────────────────────────────────────────────────────
        │ Status Code: ${response.statusCode}
        │ URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}
        │ Data: ${response.data}
        └─────────────────────────────────────────────────────────────────
        ''');
        return handler.next(response);
      },
      onError: (error, handler) {
        String dataStr = 'null';
        if (error.response?.data != null) {
          if (error.response!.data is Map) {
            dataStr = error.response!.data.toString();
          } else if (error.response!.data is String) {
            dataStr = error.response!.data as String;
          } else {
            dataStr = error.response!.data.toString();
          }
        }
        
        _logger.e('''
        ┌─────────────────────────────────────────────────────────────────
        │ ERROR
        ├─────────────────────────────────────────────────────────────────
        │ Status Code: ${error.response?.statusCode}
        │ URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}
        │ Message: ${error.message}
        │ Data: $dataStr
        │ Headers: ${error.response?.headers}
        └─────────────────────────────────────────────────────────────────
        ''');
        return handler.next(error);
      },
    );
  }

  // Error Interceptor - Trata erros HTTP
  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: NetworkException(
                message: 'Timeout de conexão. Verifique sua internet.',
              ),
            ),
          );
        }

        if (error.type == DioExceptionType.connectionError) {
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: NetworkException(
                message: 'Erro de conexão. Verifique sua internet.',
              ),
            ),
          );
        }

        final statusCode = error.response?.statusCode;

        switch (statusCode) {
          case 401:
            // Token expirado ou inválido - limpa storage e cache, força login
            await _secureStorage.delete(key: StorageKeys.accessToken);
            await _secureStorage.delete(key: StorageKeys.userId);
            // Limpar cache ao fazer logout/expirar sessão
            try {
              await CacheService.clearAll();
            } catch (e) {
              // Ignorar erros na limpeza de cache
            }
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: AuthenticationException(
                  message: 'Sessão expirada. Faça login novamente.',
                ),
              ),
            );

          case 403:
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: UnauthorizedException(
                  message: 'Você não tem permissão para esta ação.',
                ),
              ),
            );

          case 404:
            String? message;
            if (error.response?.data is Map) {
              message = error.response!.data['message'] as String?;
            } else if (error.response?.data is String) {
              message = error.response!.data as String;
            }
            
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: NotFoundException(
                  message: message ?? 'Recurso não encontrado.',
                ),
              ),
            );

          case 400:
            Map<String, String>? parsedErrors;
            String? message;
            
            // Tenta acessar o data de diferentes formas
            dynamic responseData = error.response?.data;
            
            if (responseData != null) {
              if (responseData is Map) {
                final data = responseData as Map;
                
                // Extrai mensagem de diferentes campos possíveis
                message = data['message'] as String? ?? 
                         data['error'] as String? ?? 
                         data['mensagem'] as String?;
                
                // Extrai erros de validação
                if (data['errors'] != null) {
                  try {
                    final errorsData = data['errors'];
                    if (errorsData is Map) {
                      parsedErrors = errorsData.map(
                        (key, value) => MapEntry(key.toString(), value.toString()),
                      );
                    } else if (errorsData is List) {
                      // Se errors for uma lista, converte para Map
                      parsedErrors = {};
                      for (var i = 0; i < errorsData.length; i++) {
                        parsedErrors['error_$i'] = errorsData[i].toString();
                      }
                    }
                  } catch (e) {
                    parsedErrors = null;
                  }
                }
              } else if (responseData is String) {
                message = responseData as String;
              } else {
                // Tenta converter para string
                message = responseData.toString();
              }
            }
            
            // Se ainda não tem mensagem, tenta pegar do statusMessage
            if (message == null || message.isEmpty) {
              message = error.response?.statusMessage;
            }
            
            // Mensagem padrão baseada no contexto se ainda estiver vazia
            if (message == null || message.isEmpty) {
              // Tenta inferir a mensagem baseado no endpoint
              final path = error.requestOptions.path.toLowerCase();
              if (path.contains('/usuarios/aluno') || path.contains('/usuarios/servidor')) {
                // Verifica se pode ser email duplicado baseado no body da requisição
                try {
                  final requestData = error.requestOptions.data;
                  if (requestData is Map) {
                    final email = requestData['email'] as String?;
                    if (email != null) {
                      message = 'Este email já está cadastrado. Tente fazer login ou use outro email.';
                    } else {
                      message = 'Dados inválidos. Verifique os campos preenchidos.';
                    }
                  } else {
                    message = 'Dados inválidos. Verifique os campos preenchidos.';
                  }
                } catch (_) {
                  message = 'Dados inválidos. Verifique os campos preenchidos.';
                }
              } else {
                message = 'Dados inválidos. Verifique os campos preenchidos.';
              }
            }
            
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: ValidationException(
                  message: message,
                  errors: parsedErrors,
                ),
              ),
            );

          case 500:
          case 502:
          case 503:
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: ServerException(
                  message: 'Erro no servidor. Tente novamente mais tarde.',
                  statusCode: statusCode,
                ),
              ),
            );

          default:
            return handler.next(error);
        }
      },
    );
  }

  // Métodos HTTP

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Upload de arquivos
  Future<Response> uploadFile(
    String path,
    String filePath, {
    String fileKey = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });

      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      rethrow;
    }
  }
}
