import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../DTOs/chat_dto.dart';

class ChatRemoteDataSource {
  final Dio _dio;
  StompClient? _stompClient;
  bool _isConnected = false;
  bool _isConnecting = false;
  DateTime? _lastErrorTime;
  static const Duration _reconnectCooldown = Duration(seconds: 10);

  ChatRemoteDataSource(this._dio);

  /// POST /api/chat/send - Envia mensagem privada
  Future<ChatMessageModel> sendMessageRest(SendChatMessageDTO dto, String destinatarioId, String remetenteId) async {
    try {
      final response = await _dio.post(
        ApiConstants.chatSend,
        data: {
          ...dto.toJson(),
          'id_Usuario_Remetente': remetenteId,
          'id_Usuario_Destino': destinatarioId,
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ChatMessageModel.fromJson(response.data, currentUserId: remetenteId);
      } else {
        throw ServerException(
          message: 'Erro ao enviar mensagem',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao enviar mensagem',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/chat/private - Envia mensagem privada
  Future<ChatMessageModel> sendPrivateMessage(SendChatMessageDTO dto, String destinatarioId) async {
    try {
      final response = await _dio.post(
        ApiConstants.chatPrivate,
        data: {
          ...dto.toJson(),
          'id_Usuario_Destino': destinatarioId,
        },
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ChatMessageModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao enviar mensagem privada',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ValidationException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao enviar mensagem privada',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/chat/messages/{chatId} - Lista mensagens de um chat
  Future<List<ChatMessageModel>> getChatMessages(String chatId) async {
    try {
      final response = await _dio.get(ApiConstants.chatMessages(chatId));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ChatMessageModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Erro ao buscar mensagens do chat',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar mensagens',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/chat/messages/users/{userId1}/{userId2} - Mensagens entre usuários
  Future<List<ChatMessageModel>> getMessagesBetweenUsers(String userId1, String userId2) async {
    try {
      print('[ChatRemoteDataSource] Buscando mensagens entre usuários: $userId1 e $userId2');
      final response = await _dio.get(
        ApiConstants.chatMessagesBetweenUsers(userId1, userId2),
      );
      
      if (response.statusCode == 200) {
        print('[ChatRemoteDataSource] Resposta recebida: ${response.data}');
        print('[ChatRemoteDataSource] Tipo da resposta: ${response.data.runtimeType}');
        
        final List<dynamic> data = response.data is List 
            ? response.data as List<dynamic>
            : [];
        
        print('[ChatRemoteDataSource] Total de mensagens encontradas: ${data.length}');
        
        final messages = <ChatMessageModel>[];
        for (var i = 0; i < data.length; i++) {
          try {
            final json = data[i] as Map<String, dynamic>;
            print('[ChatRemoteDataSource] Parseando mensagem $i: $json');
            
            // Passar userId1 como currentUserId para fallback
            final message = ChatMessageModel.fromJson(json, currentUserId: userId1);
            messages.add(message);
            print('[ChatRemoteDataSource] Mensagem $i parseada com sucesso: id=${message.id}, remetente=${message.idUsuarioRemetente}, destino=${message.idUsuarioDestino}');
          } catch (e, stackTrace) {
            print('[ChatRemoteDataSource] ❌ Erro ao parsear mensagem $i: $e');
            print('[ChatRemoteDataSource] Stack trace: $stackTrace');
            print('[ChatRemoteDataSource] JSON da mensagem: ${data[i]}');
          }
        }
        
        print('[ChatRemoteDataSource] Total de mensagens parseadas: ${messages.length}');
        return messages;
      } else {
        throw ServerException(
          message: 'Erro ao buscar mensagens entre usuários',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('[ChatRemoteDataSource] ❌ DioException ao buscar mensagens: $e');
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar mensagens',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/chat/message/{messageId} - Busca mensagem por ID
  Future<ChatMessageModel> getMessageById(String messageId) async {
    try {
      final response = await _dio.get(ApiConstants.chatMessageById(messageId));
      
      if (response.statusCode == 200) {
        return ChatMessageModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao buscar mensagem',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is NotFoundException) rethrow;
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar mensagem',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/chat/count/{chatId} - Conta mensagens do chat
  Future<int> getMessageCount(String chatId) async {
    try {
      final response = await _dio.get(ApiConstants.chatMessageCount(chatId));
      
      if (response.statusCode == 200) {
        return response.data as int;
      } else {
        throw ServerException(
          message: 'Erro ao contar mensagens',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao contar mensagens',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/chat/chats/{userId} - Lista todas as conversas do usuário
  Future<List<ChatSummaryDTO>> getUserChats(String userId) async {
    try {
      final response = await _dio.get(ApiConstants.chatUserChats(userId));
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('chats')) {
          // Resposta com wrapper {chats: [...], totalCount: ...}
          final chatsList = data['chats'] as List<dynamic>;
          return chatsList
              .map((chat) => ChatSummaryDTO.fromJson(chat as Map<String, dynamic>))
              .toList();
        } else if (data is List) {
          // Resposta direta como lista
          return (data as List<dynamic>)
              .map((chat) => ChatSummaryDTO.fromJson(chat as Map<String, dynamic>))
              .toList();
        } else {
          throw ServerException(
            message: 'Formato de resposta inválido',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar conversas',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar conversas',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// GET /api/chat/unread/{userId} - Lista mensagens não lidas do usuário
  Future<List<ChatMessageModel>> getUnreadMessages(String userId) async {
    try {
      final response = await _dio.get(ApiConstants.chatUnreadMessages(userId));
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return (data as List<dynamic>)
              .map((msg) => ChatMessageModel.fromJson(
                    msg as Map<String, dynamic>,
                    currentUserId: userId,
                  ))
              .toList();
        } else {
          throw ServerException(
            message: 'Formato de resposta inválido',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ServerException(
          message: 'Erro ao buscar mensagens não lidas',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao buscar mensagens não lidas',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// PUT /api/chat/mark-read - Marca mensagens como lidas
  Future<void> markAsRead(String remetenteId, String destinatarioId) async {
    try {
      final response = await _dio.put(
        ApiConstants.chatMarkRead,
        data: {
          'id_Usuario_Remetente': remetenteId,
          'id_Usuario_Destino': destinatarioId,
        },
      );
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Erro ao marcar mensagens como lidas',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.error is ServerException) rethrow;
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erro ao marcar como lidas',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// POST /api/chat/typing - Indica que está digitando
  Future<void> sendTyping(String destinatarioId) async {
    try {
      await _dio.post(
        ApiConstants.chatTyping,
        data: {'id_Usuario_Destino': destinatarioId},
      );
    } on DioException catch (e) {
      // Não lançar exceção para typing indicator
    }
  }

  /// POST /api/chat/stop-typing - Para indicação de digitação
  Future<void> sendStopTyping(String destinatarioId) async {
    try {
      await _dio.post(
        ApiConstants.chatStopTyping,
        data: {'id_Usuario_Destino': destinatarioId},
      );
    } on DioException catch (e) {
      // Não lançar exceção para typing indicator
    }
  }

  /// POST /api/chat/online - Notifica que está online
  Future<void> sendOnline(String destinatarioId) async {
    try {
      await _dio.post(
        ApiConstants.chatOnline,
        data: {'id_Usuario_Destino': destinatarioId},
      );
    } on DioException catch (e) {
      // Não lançar exceção para status online
    }
  }

  /// POST /api/chat/offline - Notifica que está offline
  Future<void> sendOffline(String destinatarioId) async {
    try {
      await _dio.post(
        ApiConstants.chatOffline,
        data: {'id_Usuario_Destino': destinatarioId},
      );
    } on DioException catch (e) {
      // Não lançar exceção para status offline
    }
  }

  /// Conecta ao WebSocket STOMP
  void connectWebSocket({
    required String token,
    required String userId,
    required void Function(ChatMessageModel) onMessageReceived,
    void Function()? onConnect,
    void Function(String)? onError,
  }) {
    if (_isConnected) {
      print('[ChatRemoteDataSource] WebSocket já está conectado');
      return;
    }

    if (_isConnecting) {
      print('[ChatRemoteDataSource] Conexão WebSocket já em andamento');
      return;
    }

    // Evita reconexões muito frequentes após erros
    if (_lastErrorTime != null) {
      final timeSinceLastError = DateTime.now().difference(_lastErrorTime!);
      if (timeSinceLastError < _reconnectCooldown) {
        final remainingSeconds = (_reconnectCooldown - timeSinceLastError).inSeconds;
        print('[ChatRemoteDataSource] Aguardando ${remainingSeconds}s antes de tentar reconectar...');
        return;
      }
    }

    if (token.isEmpty) {
      onError?.call('Token de autenticação não fornecido');
      return;
    }

    _isConnecting = true;

    // URL base do WebSocket - SockJS precisa de HTTP/HTTPS, não WSS/WS
    // O SockJS faz o upgrade automaticamente para WebSocket
    final apiBaseUrl = ApiConstants.BASE_URL;
    
    // Garantir que a URL começa com http:// ou https://
    if (!apiBaseUrl.startsWith('http://') && !apiBaseUrl.startsWith('https://')) {
      final error = 'URL base inválida: $apiBaseUrl. Deve começar com http:// ou https://';
      print('[ChatRemoteDataSource] $error');
      _isConnecting = false;
      _lastErrorTime = DateTime.now();
      onError?.call(error);
      return;
    }
    
    // Remover barra final se houver para evitar dupla barra
    final baseUrlClean = apiBaseUrl.endsWith('/') ? apiBaseUrl.substring(0, apiBaseUrl.length - 1) : apiBaseUrl;
    final wsPath = ApiConstants.wsConnect.startsWith('/') ? ApiConstants.wsConnect : '/${ApiConstants.wsConnect}';
    final wsUrl = '$baseUrlClean$wsPath';

    print('[ChatRemoteDataSource] BASE_URL: $apiBaseUrl');
    print('[ChatRemoteDataSource] wsConnect path: ${ApiConstants.wsConnect}');
    print('[ChatRemoteDataSource] URL final: $wsUrl');
    print('[ChatRemoteDataSource] URL começa com http/https? ${wsUrl.startsWith('http://') || wsUrl.startsWith('https://')}');
    
    // Validação final da URL antes de passar para SockJS
    if (!wsUrl.startsWith('http://') && !wsUrl.startsWith('https://')) {
      final error = 'URL do WebSocket inválida: $wsUrl. Deve começar com http:// ou https://';
      print('[ChatRemoteDataSource] $error');
      _isConnecting = false;
      _lastErrorTime = DateTime.now();
      onError?.call(error);
      return;
    }
    
    print('[ChatRemoteDataSource] Tentando conectar WebSocket (SockJS) em: $wsUrl');

    try {
      // Garantir que a URL está no formato correto para SockJS
      // SockJS precisa de uma URL HTTP/HTTPS válida
      final validatedUrl = Uri.parse(wsUrl).toString();
      
      if (!validatedUrl.startsWith('http://') && !validatedUrl.startsWith('https://')) {
        throw ArgumentError('URL inválida para SockJS: $validatedUrl');
      }
      
      print('[ChatRemoteDataSource] URL validada: $validatedUrl');
      
      _stompClient = StompClient(
        config: StompConfig.sockJS(
          url: validatedUrl,
          onConnect: (StompFrame frame) {
            print('[ChatRemoteDataSource] WebSocket conectado com sucesso');
            _isConnected = true;
            _isConnecting = false;
            _lastErrorTime = null; // Limpa o tempo do último erro em caso de sucesso
            onConnect?.call();

            // Subscreve ao tópico privado do usuário
            final topic = ApiConstants.wsPrivateTopic(userId);
            print('[ChatRemoteDataSource] Inscrevendo-se no tópico: $topic');
            
            _stompClient?.subscribe(
              destination: topic,
              callback: (StompFrame frame) {
                print('[ChatRemoteDataSource] ========== MENSAGEM RECEBIDA VIA WEBSOCKET ==========');
                print('[ChatRemoteDataSource] Command: ${frame.command}');
                print('[ChatRemoteDataSource] Headers: ${frame.headers}');
                print('[ChatRemoteDataSource] Body type: ${frame.body.runtimeType}');
                print('[ChatRemoteDataSource] Body: ${frame.body}');
                
                if (frame.body != null) {
                  try {
                    // Converter body para Map se necessário
                    Map<String, dynamic> messageData;
                    if (frame.body is Map) {
                      messageData = Map<String, dynamic>.from(frame.body as Map);
                    } else if (frame.body is String) {
                      // Tentar fazer parse JSON se for string
                      messageData = Map<String, dynamic>.from(
                        jsonDecode(frame.body as String) as Map,
                      );
                    } else {
                      throw Exception('Formato de body não suportado: ${frame.body.runtimeType}');
                    }
                    
                    print('[ChatRemoteDataSource] Dados da mensagem parseados: $messageData');
                    
                    final message = ChatMessageModel.fromJson(messageData);
                    print('[ChatRemoteDataSource] Mensagem criada: id=${message.id}, remetente=${message.idUsuarioRemetente}, destino=${message.idUsuarioDestino}');
                    
                    onMessageReceived(message);
                    print('[ChatRemoteDataSource] Callback onMessageReceived chamado com sucesso');
                  } catch (e, stackTrace) {
                    print('[ChatRemoteDataSource] ❌ Erro ao processar mensagem: $e');
                    print('[ChatRemoteDataSource] Stack trace: $stackTrace');
                    onError?.call('Erro ao processar mensagem: $e');
                  }
                } else {
                  print('[ChatRemoteDataSource] ⚠️ AVISO: Frame body é null!');
                }
                print('[ChatRemoteDataSource] =======================================================');
              },
            );
            
            print('[ChatRemoteDataSource] ✅ Inscrição no tópico $topic realizada com sucesso');
          },
          onWebSocketError: (dynamic error) {
            _isConnected = false;
            _isConnecting = false;
            _lastErrorTime = DateTime.now();
            print('[ChatRemoteDataSource] Erro no WebSocket: $error');
            // Só chama onError se não for um erro de reconexão automática
            if (onError != null) {
              onError('Erro no WebSocket: $error');
            }
          },
          onStompError: (StompFrame frame) {
            _isConnected = false;
            _isConnecting = false;
            _lastErrorTime = DateTime.now();
            print('[ChatRemoteDataSource] Erro STOMP: ${frame.body}');
            if (onError != null) {
              onError('Erro STOMP: ${frame.body}');
            }
          },
          onDisconnect: (StompFrame frame) {
            print('[ChatRemoteDataSource] WebSocket desconectado');
            _isConnected = false;
            _isConnecting = false;
          },
          // Adiciona headers de autenticação
          stompConnectHeaders: {
            'Authorization': 'Bearer $token',
          },
          webSocketConnectHeaders: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      _stompClient?.activate();
    } catch (e) {
      print('[ChatRemoteDataSource] Erro ao criar cliente WebSocket: $e');
      _isConnected = false;
      _isConnecting = false;
      _lastErrorTime = DateTime.now();
      if (onError != null) {
        onError('Erro ao criar conexão WebSocket: $e');
      }
    }
  }

  /// Envia mensagem via WebSocket STOMP
  void sendMessageViaWebSocket({
    required String conversaId,
    required String conteudo,
  }) {
    if (!_isConnected) {
      throw ConnectionException(message: 'WebSocket não conectado');
    }

    _stompClient?.send(
      destination: '/app/chat/$conversaId',
      body: SendChatMessageDTO(conteudo: conteudo).toJson().toString(),
    );
  }

  /// Desconecta do WebSocket
  void disconnectWebSocket() {
    if (_stompClient != null) {
      _stompClient?.deactivate();
      _stompClient = null;
      _isConnected = false;
      _isConnecting = false;
      _lastErrorTime = null;
    }
  }

  /// Verifica se está conectado
  bool get isConnected => _isConnected;
}
