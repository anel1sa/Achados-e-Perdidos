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
  static const String itensPerdidosActive = '/api/itens-perdidos/active';
  static String itemPerdidoById(int id) => '/api/itens-perdidos/$id';
  static String itemPerdidoByItemId(int itemId) => '/api/itens-perdidos/item/$itemId';
  
  // Itens Achados (NEW - Endpoints especializados)  
  static const String itensAchados = '/api/itens/achados'; // Usa /api/itens/achados (multipart obrigatório)
  static const String itensAchadosActive = '/api/itens-achados/active';
  static String itemAchadoById(int id) => '/api/itens-achados/$id';
  static String itemAchadoByItemId(int itemId) => '/api/itens-achados/item/$itemId';
  
  // Itens Doados
  static const String itensDoados = '/api/itens-doados';
  static const String itensDoadosActive = '/api/itens-doados/active';
  
  // Items filtering (mantido para compatibilidade)
  static String itensByCampus(int campusId) => '/api/itens/campus/$campusId';
  static String itensByUser(int userId) => '/api/itens/user/$userId';
  static String itensByEmpresa(int empresaId) => '/api/itens/empresa/$empresaId';
  static const String itensSearch = '/api/itens/search';
  
  // Item actions
  static String itemDoar(int id) => '/api/itens/$id/doar';
  static String itemDevolver(int id) => '/api/itens/$id/devolver';

  // Reivindicações Endpoints (NEW - Sistema de reivindicação de itens perdidos)
  static const String reivindicacoes = '/api/reivindicacoes';
  static String reivindicacaoById(int id) => '/api/reivindicacoes/$id';
  static String reivindicacoesByItem(int itemId) =>
      '/api/reivindicacoes/item/$itemId';
  static String reivindicacoesByUsuario(int userId) =>
      '/api/reivindicacoes/user/$userId';
  static String reivindicacoesByProprietario(int proprietarioId) =>
      '/api/reivindicacoes/proprietario/$proprietarioId';
  static String reivindicacaoByItemAndUser(int itemId, int userId) =>
      '/api/reivindicacoes/item/$itemId/user/$userId';
  
  // Itens Devolvidos Endpoints (NEW - Sistema de confirmação de devolução)
  static const String itensDevolvidos = '/api/itens-devolvidos';
  static String itemDevolvidoById(int id) => '/api/itens-devolvidos/$id';
  static String itensDevolvidosByItem(int itemId) =>
      '/api/itens-devolvidos/item/$itemId';

  // Campus Endpoints
  static const String campus = '/api/campus';
  static const String campusActive = '/api/campus/active';
  static String campusById(int id) => '/api/campus/$id';
  static String campusByInstituicao(int instituicaoId) =>
      '/api/campus/institution/$instituicaoId';

  // Usuario Campus Endpoints
  static const String usuarioCampus = '/api/usuario-campus';
  static String usuarioCampusByUsuario(int usuarioId) => '/api/usuario-campus/usuario/$usuarioId';

  // Instituição Endpoints
  static const String instituicoes = '/api/instituicao';
  static const String instituicoesActive = '/api/instituicao/active';
  static String instituicaoById(int id) => '/api/instituicao/$id';
  static String instituicoesByTipo(String tipo) => '/api/instituicao/type/$tipo';

  // Empresa Endpoints
  static const String empresas = '/api/empresa';
  static const String empresasActive = '/api/empresa/active';
  static String empresaById(int id) => '/api/empresa/$id';

  // Local Endpoints - REMOVIDO: Tabela locais foi removida do banco de dados

  // Endereço Endpoints
  static const String enderecos = '/api/enderecos';
  static String enderecoById(int id) => '/api/enderecos/$id';
  static String enderecosByCidade(int cidadeId) => '/api/enderecos/cidade/$cidadeId';

  // Cidade Endpoints
  static const String cidades = '/api/cidades';
  static String cidadeById(int id) => '/api/cidades/$id';
  static String cidadesByEstado(int estadoId) => '/api/cidades/estado/$estadoId';

  // Estado Endpoints
  static const String estados = '/api/estados';
  static String estadoById(int id) => '/api/estados/$id';
  static String estadoByUf(String uf) => '/api/estados/uf/$uf';

  // Fotos Endpoints
  static const String fotos = '/api/fotos';
  static const String fotosActive = '/api/fotos/active';
  static String fotoById(int id) => '/api/fotos/$id';
  static String fotosByUser(int userId) => '/api/fotos/user/$userId';
  static String fotosByItem(int itemId) => '/api/fotos/item/$itemId';
  static String profilePhotos(int userId) => '/api/fotos/profile/$userId';
  static String itemPhotos(int itemId) => '/api/fotos/item-photos/$itemId';
  static String mainItemPhoto(int itemId) => '/api/fotos/main-item-photo/$itemId';
  static String profilePhoto(int userId) => '/api/fotos/profile-photo/$userId';
  static const String uploadProfilePhoto = '/api/fotos/upload/profile';
  static const String uploadItemPhoto = '/api/fotos/upload/item';
  static const String uploadPhoto = '/api/fotos/upload';
  static String downloadPhoto(int id) => '/api/fotos/download/$id';
  static String deletePhoto(int id) => '/api/fotos/delete/$id';

  // Role Endpoints
  static const String roles = '/api/roles';
  static const String rolesActive = '/api/roles/active';
  static String roleById(int id) => '/api/roles/$id';
  static String roleByNome(String nome) => '/api/roles/nome/$nome';

  // Status Item Endpoints
  static const String statusItem = '/api/status-item';
  static String statusItemById(int id) => '/api/status-item/$id';

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
  static String chatMessagesSystem(String userId) => '/api/chat/messages/system/$userId';
  static String chatMessagesReadAll(String userId) => '/api/chat/messages/read-all/$userId';
  static String chatUserChats(String userId) => '/api/chat/chats/$userId';
  static String chatUnreadMessages(String userId) => '/api/chat/unread/$userId';
  
  // Device Tokens (Push Notifications - NEW)
  static const String deviceTokens = '/api/device-tokens';
  static const String deviceTokensRegister = '/api/device-tokens/register';
  static const String deviceTokensActive = '/api/device-tokens/active';
  static String deviceTokenById(int id) => '/api/device-tokens/$id';
  static String deviceTokensByUsuario(int usuarioId) => '/api/device-tokens/usuario/$usuarioId';
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
