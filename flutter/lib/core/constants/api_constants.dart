import '../config/env_config.dart';

class ApiConstants {
  // Base URL (configurável via .env)
  static String get BASE_URL => EnvConfig.apiBaseUrl;
  
  // Auth Endpoints
  static const String login = '/api/usuarios/login';
  static const String googleAuthLogin = '/api/google-auth/login';
  static const String googleAuthCallback = '/api/google-auth/callback';

  // User Endpoints
  static const String usuarios = '/api/usuarios';
  static const String usuariosActive = '/api/usuarios/active';
  static const String usuariosAluno = '/api/usuarios/aluno';
  static const String usuariosServidor = '/api/usuarios/servidor';
  static String usuarioById(int id) => '/api/usuarios/$id';
  static String usuarioByEmail(String email) => '/api/usuarios/email/$email';
  static String alterarSenha(int id) => '/api/usuarios/$id/alterar-senha';

  // Items Endpoints (Base - mantido para compatibilidade)
  static const String itens = '/api/itens';
  static const String itensActive = '/api/itens/active';
  static String itemById(int id) => '/api/itens/$id';
  
  // Itens Perdidos (NEW - Endpoints especializados)
  static const String itensPerdidos = '/api/itens/perdidos';
  
  // Itens Achados (NEW - Endpoints especializados)  
  static const String itensAchados = '/api/itens/achados'; // Usa /api/itens/achados (multipart obrigatório)
  
  // Itens Doados
  static const String itensDoados = '/api/itens-doados';
  
  // Items filtering (mantido para compatibilidade)
  static String itensByCampus(int campusId) => '/api/itens/campus/$campusId';
  static String itensByUser(int userId) => '/api/itens/user/$userId';
  static String itensByEmpresa(int empresaId) => '/api/itens/empresa/$empresaId';
  static const String itensSearch = '/api/itens/search';


  // Campus Endpoints
  static const String campus = '/api/campus';
  static const String campusActive = '/api/campus/active';
  static String campusById(int id) => '/api/campus/$id';
  static String campusByInstituicao(int instituicaoId) =>
      '/api/campus/institution/$instituicaoId';

  // Local Endpoints - REMOVIDO: Tabela locais foi removida do banco de dados

  // Fotos Endpoints
  static const String uploadItemPhoto = '/api/fotos/upload/item';
  static String fotosByItem(int itemId) => '/api/fotos/item/$itemId';


  // Chat REST + WebSocket Endpoints (Híbrido)
  static const String chatSend = '/api/chat/send';
  static const String chatPrivate = '/api/chat/private';
  static const String chatOnline = '/api/chat/online';
  static const String chatOffline = '/api/chat/offline';
  static const String chatTyping = '/api/chat/typing';
  static const String chatStopTyping = '/api/chat/stop-typing';
  static String chatMessages(String chatId) => '/api/chat/messages/$chatId';
  static String chatMessagesBetweenUsers(String userId1, String userId2) =>
      '/api/chat/messages/users/$userId1/$userId2';
  static const String chatMarkRead = '/api/chat/mark-read';
  static String chatMessageById(String messageId) => '/api/chat/message/$messageId';
  static String chatMessageCount(String chatId) => '/api/chat/count/$chatId';
  static String chatMessagesReadAll(String userId) => '/api/chat/messages/read-all/$userId';
  static String chatUserChats(String userId) => '/api/chat/chats/$userId';
  static String chatUnreadMessages(String userId) => '/api/chat/unread/$userId';
  
  // Device Tokens (Push Notifications - NEW)
  static const String deviceTokens = '/api/device-tokens';
  static const String deviceTokensRegister = '/api/device-tokens/register';
  static String deviceTokenById(int id) => '/api/device-tokens/$id';
  static String deviceTokensActiveByUsuario(int usuarioId) => '/api/device-tokens/usuario/$usuarioId/active';

  // Deadline Endpoints
  static const String deadlineNearDeadline = '/api/deadline/near-deadline';
  static const String deadlineExpired = '/api/deadline/expired';
  static String deadlineMarkDonated(int itemId) => '/api/deadline/mark-donated/$itemId';
  static const String deadlineNotify = '/api/deadline/notify-deadlines';
  static const String deadlineMarkExpiredDonated = '/api/deadline/mark-expired-donated';
  static const String deadlineStats = '/api/deadline/stats';

  // WebSocket
  static const String wsConnect = '/ws';
  static const String wsChatDestination = '/app/chat';
  static String wsPrivateTopic(String userId) => '/topic/private.$userId';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String contentTypeHeader = 'Content-Type';
  static const String contentTypeJson = 'application/json';
}
