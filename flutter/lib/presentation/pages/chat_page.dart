import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../data/services/chat_service.dart';
import '../../data/services/usuario_service.dart';
import '../../data/DTOs/chat_dto.dart';
import '../../core/constants/storage_keys.dart';
import '../../core/error/exceptions.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../widgets/common/user_header.dart';
import '../widgets/common/bottom_navigation_achados.dart';
import '../widgets/common/chat_info_widget.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/chat/chat_widgets.dart';
import '../widgets/dialogs/dialogs.dart';

class ChatPage extends StatefulWidget {
  final UsuarioDTO? usuarioLogado;

  const ChatPage({super.key, required this.usuarioLogado});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Services
  final _secureStorage = const FlutterSecureStorage();
  final _chatService = ChatService();
  final _usuarioService = UsuarioService();

  // User data
  late String _nomeUsuario;
  late String _iniciaisUsuario;
  String? _currentUserId;

  // State
  bool _isLoading = true;
  Map<String, ConversaInfo> _conversas = {};

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _loadChats();
    _connectWebSocket();
  }

  @override
  void dispose() {
    _chatService.disconnectWebSocket();
    super.dispose();
  }

  /// Inicializa os dados do usuário
  void _initializeUserData() {
    if (widget.usuarioLogado != null) {
      final nomes = widget.usuarioLogado!.nome.split(' ');
      _nomeUsuario = nomes[0];
      _iniciaisUsuario = _generateInitials(nomes);
    } else {
      _nomeUsuario = 'Usuário';
      _iniciaisUsuario = 'U';
    }
  }

  /// Gera as iniciais do usuário
  String _generateInitials(List<String> nomes) {
    if (nomes.length > 1) {
      return (nomes[0][0] + nomes[1][0]).toUpperCase();
    } else {
      final nome = nomes[0];
      return nome.substring(0, nome.length > 1 ? 2 : 1).toUpperCase();
    }
  }

  /// Carrega lista de conversas
  Future<void> _loadChats() async {
    if (!mounted) return;

    try {
      setState(() => _isLoading = true);

      // Pega o ID do usuário do storage
      _currentUserId = await _secureStorage.read(key: StorageKeys.userId);
      if (_currentUserId == null) {
        throw UnauthorizedException(message: 'Usuário não autenticado');
      }

      // Buscar histórico de conversas do usuário
      final chats = await _chatService.getUserChats(_currentUserId!);
      
      // Converter ChatSummaryDTO para ConversaInfo
      _conversas.clear();
      for (final chat in chats) {
        // Filtrar chats do tipo "system" ou sem nome de usuário
        if (chat.chatId == 'system' || 
            chat.otherUserId == 'system' ||
            chat.otherUserName.isEmpty ||
            chat.otherUserId.isEmpty) {
          continue; // Pular chats do sistema
        }
        
        try {
          // Gerar iniciais do outro usuário
          final nomes = chat.otherUserName.trim().split(' ').where((n) => n.isNotEmpty).toList();
          String iniciais;
          if (nomes.isEmpty) {
            iniciais = 'U'; // Fallback se não houver nome
          } else if (nomes.length > 1) {
            iniciais = (nomes[0][0] + nomes[1][0]).toUpperCase();
          } else {
            final nome = nomes[0];
            iniciais = nome.substring(0, nome.length > 1 ? 2 : 1).toUpperCase();
          }
          
          _conversas[chat.chatId] = ConversaInfo(
            userId: chat.otherUserId,
            nome: chat.otherUserName,
            iniciais: iniciais,
            ultimaMensagem: chat.lastMessage,
            horario: _formatarHorario(chat.lastMessageDate),
            naoLidas: chat.unreadCount,
          );
        } catch (e) {
          debugPrint('⚠️ Erro ao processar chat ${chat.chatId}: $e');
          // Continuar com próximo chat em caso de erro
        }
      }

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _tratarErro(e);
    }
  }

  /// Formata horário para exibição
  String _formatarHorario(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inMinutes < 1) {
      return 'Agora';
    } else if (diferenca.inMinutes < 60) {
      return '${diferenca.inMinutes}min';
    } else if (diferenca.inHours < 24) {
      return '${diferenca.inHours}h';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays}d';
    } else {
      return '${data.day}/${data.month}';
    }
  }

  /// Conecta ao WebSocket para receber mensagens em tempo real
  Future<void> _connectWebSocket() async {
    try {
      final token = await _secureStorage.read(key: StorageKeys.accessToken);
      final userId = await _secureStorage.read(key: StorageKeys.userId);

      if (token == null || userId == null) {
        throw UnauthorizedException(message: 'Credenciais não encontradas');
      }

      _chatService.connectWebSocket(
        token: token,
        userId: userId,
        onMessageReceived: _onMessageReceived,
        onConnect: () {
          debugPrint('WebSocket conectado com sucesso');
        },
        onError: (error) {
          debugPrint('Erro no WebSocket: $error');
        },
      );
    } catch (e) {
      _tratarErro(e);
    }
  }

  /// Callback chamado quando uma nova mensagem chega via WebSocket
  void _onMessageReceived(ChatMessageModel message) {
    if (!mounted) return;

    setState(() {
      // Usar chatId (conversaId) como chave, se disponível
      final chatId = message.conversaId;
      final outroUsuarioId = message.idUsuarioRemetente == _currentUserId
          ? message.idUsuarioDestino
          : message.idUsuarioRemetente;

      // Tentar encontrar conversa pelo chatId primeiro, depois pelo userId
      ConversaInfo? conversa;
      if (chatId != null && _conversas.containsKey(chatId)) {
        conversa = _conversas[chatId];
      } else if (_conversas.containsKey(outroUsuarioId)) {
        conversa = _conversas[outroUsuarioId];
      }

      if (conversa != null) {
        // Atualizar conversa existente
        conversa.ultimaMensagem = message.conteudo;
        conversa.horario = _formatarHorario(message.dataEnvio);
        if (message.idUsuarioRemetente != _currentUserId) {
          conversa.naoLidas++;
        }
        // Se a conversa estava indexada por userId e agora temos chatId, reindexar
        if (chatId != null && !_conversas.containsKey(chatId)) {
          _conversas.remove(outroUsuarioId);
          _conversas[chatId] = conversa;
        }
      } else {
        // Nova conversa - recarregar lista completa para obter dados do usuário
        _loadChats();
      }
    });
  }

  /// Carrega informações do usuário para nova conversa
  /// NOTA: Este método não é mais usado pois recarregamos a lista completa via _loadChats()
  /// Mantido para compatibilidade caso seja necessário em algum caso específico
  @Deprecated('Use _loadChats() para recarregar lista completa')
  Future<void> _loadUsuarioInfo(String userId, ChatMessageModel message) async {
    try {
      final usuario = await _usuarioService.getUsuarioById(int.parse(userId));
      if (!mounted) return;

      setState(() {
        _conversas[userId] = ConversaInfo(
          userId: userId,
          nome: usuario.nome,
          iniciais: _generateInitials(usuario.nome.split(' ')),
          ultimaMensagem: message.conteudo,
          horario: _formatarHorario(message.dataEnvio),
          naoLidas: message.idUsuarioRemetente != _currentUserId ? 1 : 0,
        );
      });
    } catch (e) {
      debugPrint('Erro ao carregar info do usuário: $e');
    }
  }

  /// Formata DateTime para string de horário
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Ontem';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  /// Trata erros e exibe mensagens amigáveis
  void _tratarErro(Object error) {
    String mensagem = 'Erro desconhecido';
    
    debugPrint('❌ Erro ao carregar conversas: $error');
    if (error is Exception) {
      debugPrint('❌ Tipo de erro: ${error.runtimeType}');
    }

    if (error is NetworkException) {
      mensagem = 'Sem conexão com a internet. Verifique sua rede.';
    } else if (error is TimeoutException) {
      mensagem = 'Tempo esgotado. Tente novamente.';
    } else if (error is ServerException) {
      mensagem = error.message ?? 'Erro no servidor. Tente mais tarde.';
    } else if (error is UnauthorizedException) {
      mensagem = 'Sessão expirada. Faça login novamente.';
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      });
    } else {
      mensagem = 'Erro ao carregar conversas';
    }

    if (mounted) {
      AppSnackBar.showError(context, mensagem);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar se há um usuário logado válido
    if (widget.usuarioLogado == null ||
        widget.usuarioLogado!.id == null ||
        widget.usuarioLogado!.nome.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationAchados(
        usuario: widget.usuarioLogado!,
        currentIndex: 2,
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 3),
        _buildInfoWidget(),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildHeader() {
    return UserHeader(
      usuario: widget.usuarioLogado!,
      nomeUsuario: _nomeUsuario,
      iniciaisUsuario: _iniciaisUsuario,
    );
  }

  Widget _buildInfoWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ChatInfoWidget(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_conversas.isEmpty) {
      return _buildEmptyState();
    }

    return _buildChatList();
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'Nenhuma conversa ainda.\nQuando alguém responder sobre seus itens,\nas mensagens aparecerão aqui!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildChatList() {
    final conversasList = _conversas.values.toList()
      ..sort((a, b) => b.horario.compareTo(a.horario));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16, left: 3, right: 3),
        itemCount: conversasList.length,
        itemBuilder: (context, index) {
          return _buildMessageCard(conversasList[index]);
        },
      ),
    );
  }

  Widget _buildMessageCard(ConversaInfo conversa) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark
        ? theme.colorScheme.surfaceVariant
        : theme.colorScheme.primary;
    final textColor = isDark
        ? theme.colorScheme.onSurfaceVariant
        : Colors.white;
    final avatarBgColor = isDark
        ? theme.colorScheme.surface
        : theme.scaffoldBackgroundColor;
    final avatarTextColor = theme.colorScheme.primary;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: avatarBgColor,
          child: Text(
            conversa.iniciais,
            style: TextStyle(
              color: avatarTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversa.nome,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            Text(
              conversa.horario,
              style: TextStyle(
                color: textColor.withOpacity(0.8), 
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  conversa.ultimaMensagem,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor.withOpacity(0.9), 
                    fontSize: 14,
                  ),
                ),
              ),
              if (conversa.naoLidas > 0) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: theme.colorScheme.error,
                  child: Text(
                    conversa.naoLidas > 9 ? '9+' : conversa.naoLidas.toString(),
                    style: TextStyle(
                      color: theme.colorScheme.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        onTap: () => _openIndividualChat(conversa),
      ),
    );
  }

  void _openIndividualChat(ConversaInfo conversa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndividualChatPage(
          conversaInfo: conversa,
          usuarioLogado: widget.usuarioLogado,
          currentUserId: _currentUserId!,
        ),
      ),
    ).then((_) {
      // Marcar como lidas quando voltar
      if (conversa.naoLidas > 0) {
        setState(() => conversa.naoLidas = 0);
        _chatService.markAsRead(_currentUserId!, conversa.userId);
      }
    });
  }
}

/// Modelo de informação da conversa
class ConversaInfo {
  final String userId;
  final String nome;
  final String iniciais;
  String ultimaMensagem;
  String horario;
  int naoLidas;

  ConversaInfo({
    required this.userId,
    required this.nome,
    required this.iniciais,
    required this.ultimaMensagem,
    required this.horario,
    this.naoLidas = 0,
  });
}

/// Página de chat individual com integração WebSocket
class IndividualChatPage extends StatefulWidget {
  final ConversaInfo conversaInfo;
  final UsuarioDTO? usuarioLogado;
  final String currentUserId;
  final String? mensagemInicial;
  final int? itemId; // Contexto do item na conversa
  final String? itemNome; // Nome do item

  const IndividualChatPage({
    super.key,
    required this.conversaInfo,
    required this.usuarioLogado,
    required this.currentUserId,
    this.mensagemInicial,
    this.itemId,
    this.itemNome,
  });

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  final _secureStorage = const FlutterSecureStorage();
  final _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = true;
  List<ChatMessageModel> _messages = [];
  String? _conversaId; // Mudado de int? para String? pois id_Chat é String no formato "chat_{userId1}_{userId2}"

  @override
  void initState() {
    super.initState();
    
    _loadMessages();
    _connectWebSocket();
    
    // Enviar mensagem inicial se fornecida
    if (widget.mensagemInicial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('📝 Mensagem inicial detectada: ${widget.mensagemInicial}');
        debugPrint('📝 Destinatário (conversaInfo.userId): ${widget.conversaInfo.userId}');
        debugPrint('📝 Remetente (currentUserId): ${widget.currentUserId}');
        _messageController.text = widget.mensagemInicial!;
        // Aguardar um pouco para garantir que o histórico foi carregado
        Future.delayed(const Duration(milliseconds: 500), () {
          _sendMessage();
        });
      });
    }
  }


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Carrega histórico de mensagens
  Future<void> _loadMessages() async {
    if (!mounted) return;

    try {
      debugPrint('📥 Carregando histórico de mensagens entre ${widget.currentUserId} e ${widget.conversaInfo.userId}');
      debugPrint('📥 ConversaInfo.userId: ${widget.conversaInfo.userId}');
      debugPrint('📥 CurrentUserId: ${widget.currentUserId}');
      setState(() => _isLoading = true);

      final messages = await _chatService.getMessagesBetweenUsers(
        widget.currentUserId,
        widget.conversaInfo.userId,
      );
      
      debugPrint('📥 Mensagens recebidas da API: ${messages.length}');

      debugPrint('📥 Mensagens recebidas da API: ${messages.length}');

      if (!mounted) return;
      
      // Corrigir idUsuarioRemetente nas mensagens carregadas se for null ou vazio
      final messagesCorrigidas = messages.map((msg) {
        if (msg.idUsuarioRemetente.isEmpty || msg.idUsuarioRemetente == 'null') {
          debugPrint('⚠️ Mensagem sem remetente: ${msg.id}, corrigindo...');
          // Se o remetente está vazio, verificar se é do currentUserId ou do outro usuário
          // Se o destino é o currentUserId, então o remetente é o outro usuário
          final remetenteId = msg.idUsuarioDestino == widget.currentUserId
              ? widget.conversaInfo.userId
              : widget.currentUserId;
          
          debugPrint('✅ Remetente corrigido para: $remetenteId');
          return ChatMessageModel(
            id: msg.id,
            conteudo: msg.conteudo,
            idUsuarioRemetente: remetenteId,
            idUsuarioDestino: msg.idUsuarioDestino,
            dataEnvio: msg.dataEnvio,
            lida: msg.lida,
            conversaId: msg.conversaId,
          );
        }
        return msg;
      }).toList();
      
      debugPrint('📥 Total de mensagens após correção: ${messagesCorrigidas.length}');
      
      // Ordenar mensagens: mais recentes primeiro (para aparecer no topo com reverse: true)
      messagesCorrigidas.sort((a, b) => b.dataEnvio.compareTo(a.dataEnvio));
      
      debugPrint('📋 Mensagens ordenadas (primeira: ${messagesCorrigidas.first.conteudo}, última: ${messagesCorrigidas.last.conteudo})');
      
      setState(() {
        _messages = messagesCorrigidas;
        if (_messages.isNotEmpty) {
          _conversaId = _messages.first.conversaId;
          debugPrint('✅ Histórico carregado: ${_messages.length} mensagens');
          debugPrint('✅ Conversa ID: $_conversaId');
          debugPrint('✅ Primeira mensagem: ${_messages.first.conteudo}');
          debugPrint('✅ Última mensagem: ${_messages.last.conteudo}');
        } else {
          debugPrint('⚠️ Nenhuma mensagem encontrada no histórico');
        }
        _isLoading = false;
      });
      
      debugPrint('🔄 setState chamado, _messages.length = ${_messages.length}');
    } catch (e, stackTrace) {
      debugPrint('❌ Erro ao carregar histórico: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      if (!mounted) return;
      setState(() => _isLoading = false);
      _tratarErro(e);
    }
  }

  /// Conecta ao WebSocket
  Future<void> _connectWebSocket() async {
    try {
      final token = await _secureStorage.read(key: StorageKeys.accessToken);
      if (token == null) {
        debugPrint('⚠️ Token não encontrado. WebSocket não conectado.');
        return;
      }

      debugPrint('🔌 Conectando WebSocket para usuário: ${widget.currentUserId}');
      _chatService.connectWebSocket(
        token: token,
        userId: widget.currentUserId,
        onMessageReceived: _onMessageReceived,
        onConnect: () {
          debugPrint('✅ WebSocket conectado com sucesso na página de chat');
        },
        onError: (error) {
          debugPrint('❌ Erro no WebSocket: $error');
        },
      );
    } catch (e) {
      debugPrint('❌ Erro ao conectar WebSocket: $e');
    }
  }

  /// Callback para mensagens recebidas
  void _onMessageReceived(ChatMessageModel message) {
    if (!mounted) return;

    // Verificar se a mensagem é desta conversa
    final isFromThisChat =
        (message.idUsuarioRemetente == widget.conversaInfo.userId &&
            message.idUsuarioDestino == widget.currentUserId) ||
        (message.idUsuarioRemetente == widget.currentUserId &&
            message.idUsuarioDestino == widget.conversaInfo.userId);

    if (isFromThisChat) {
      // Corrigir idUsuarioRemetente se for null ou vazio
      final messageCorrigida = (message.idUsuarioRemetente.isEmpty || message.idUsuarioRemetente == 'null')
          ? ChatMessageModel(
              id: message.id,
              conteudo: message.conteudo,
              idUsuarioRemetente: widget.currentUserId,
              idUsuarioDestino: message.idUsuarioDestino,
              dataEnvio: message.dataEnvio,
              lida: message.lida,
              conversaId: message.conversaId,
            )
          : message;
      
      setState(() {
        _messages.insert(0, messageCorrigida);
        if (_conversaId == null) {
          _conversaId = messageCorrigida.conversaId;
        }
      });

      // Marcar como lida se for do outro usuário
      if (messageCorrigida.idUsuarioRemetente == widget.conversaInfo.userId) {
        _chatService.markAsRead(widget.currentUserId, widget.conversaInfo.userId);
      }
    }
  }

  /// Envia mensagem
  Future<void> _sendMessage() async {
    final texto = _messageController.text.trim();
    if (texto.isEmpty) return;

    try {
      _messageController.clear();

      debugPrint('📤 Enviando mensagem: "$texto"');
      debugPrint('📤 Destinatário: ${widget.conversaInfo.userId}');
      debugPrint('📤 Remetente: ${widget.currentUserId}');

      if (_conversaId != null) {
        // Enviar via WebSocket (mas também via REST para garantir persistência)
        // Como o WebSocket pode não estar conectado, sempre usa REST
        final dto = SendChatMessageDTO(conteudo: texto);
        final mensagem = await _chatService.sendMessage(dto, widget.conversaInfo.userId, widget.currentUserId);
        
        debugPrint('✅ Mensagem enviada com sucesso');
        debugPrint('✅ ID da mensagem: ${mensagem.id}');
        debugPrint('✅ Destinatário recebido: ${mensagem.idUsuarioDestino}');
        debugPrint('✅ Remetente recebido: ${mensagem.idUsuarioRemetente}');

        if (!mounted) return;
        
        // Corrigir idUsuarioRemetente se for null ou vazio (usar currentUserId como fallback)
        final mensagemCorrigida = (mensagem.idUsuarioRemetente.isEmpty || mensagem.idUsuarioRemetente == 'null')
            ? ChatMessageModel(
                id: mensagem.id,
                conteudo: mensagem.conteudo,
                idUsuarioRemetente: widget.currentUserId,
                idUsuarioDestino: mensagem.idUsuarioDestino,
                dataEnvio: mensagem.dataEnvio,
                lida: mensagem.lida,
                conversaId: mensagem.conversaId,
              )
            : mensagem;
        
        setState(() {
          // Verificar se a mensagem já não está na lista (evitar duplicação)
          final jaExiste = _messages.any((m) => m.id == mensagemCorrigida.id);
          if (!jaExiste) {
            _messages.insert(0, mensagemCorrigida);
            debugPrint('✅ Mensagem adicionada à lista. Total: ${_messages.length}');
          } else {
            debugPrint('⚠️ Mensagem já existe na lista, não duplicando');
          }
          if (_conversaId == null && mensagemCorrigida.conversaId != null) {
            _conversaId = mensagemCorrigida.conversaId;
          }
        });
      } else {
        // Primeira mensagem - enviar via REST
        final dto = SendChatMessageDTO(conteudo: texto);
        final mensagem = await _chatService.sendMessage(dto, widget.conversaInfo.userId, widget.currentUserId);
        
        debugPrint('✅ Primeira mensagem enviada com sucesso');
        debugPrint('✅ ID da mensagem: ${mensagem.id}');
        debugPrint('✅ Destinatário recebido: ${mensagem.idUsuarioDestino}');
        debugPrint('✅ Remetente recebido: ${mensagem.idUsuarioRemetente}');

        if (!mounted) return;
        
        // Corrigir idUsuarioRemetente se for null ou vazio (usar currentUserId como fallback)
        final mensagemCorrigida = (mensagem.idUsuarioRemetente.isEmpty || mensagem.idUsuarioRemetente == 'null')
            ? ChatMessageModel(
                id: mensagem.id,
                conteudo: mensagem.conteudo,
                idUsuarioRemetente: widget.currentUserId,
                idUsuarioDestino: mensagem.idUsuarioDestino,
                dataEnvio: mensagem.dataEnvio,
                lida: mensagem.lida,
                conversaId: mensagem.conversaId,
              )
            : mensagem;
        
        setState(() {
          // Verificar se a mensagem já não está na lista (evitar duplicação)
          final jaExiste = _messages.any((m) => m.id == mensagemCorrigida.id);
          if (!jaExiste) {
            _messages.insert(0, mensagemCorrigida);
            debugPrint('✅ Primeira mensagem adicionada à lista. Total: ${_messages.length}');
          } else {
            debugPrint('⚠️ Mensagem já existe na lista, não duplicando');
          }
          _conversaId = mensagemCorrigida.conversaId;
        });
      }
    } catch (e) {
      _tratarErro(e);
    }
  }

  /// Trata erros
  void _tratarErro(Object error) {
    String mensagem = 'Erro desconhecido';

    if (error is NetworkException) {
      mensagem = 'Sem conexão com a internet';
    } else if (error is TimeoutException) {
      mensagem = 'Tempo esgotado. Tente novamente';
    } else if (error is ServerException) {
      mensagem = error.message ?? 'Erro no servidor';
    } else if (error is DioException && error.type == DioExceptionType.connectionError) {
      mensagem = 'WebSocket desconectado. Reconectando...';
      _connectWebSocket();
    }

    if (mounted) {
      AppSnackBar.showError(context, mensagem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Card de contexto do item (se houver)
          if (widget.itemId != null)
            ItemContextCard(
              itemId: widget.itemId!,
              itemNome: widget.itemNome,
            ),
          
          Expanded(child: _buildMessageList()),
          
          // Botões de ação contextual removidos - funcionalidades de reivindicação e devolução não estão mais disponíveis
          
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appBarColor = isDark
        ? theme.colorScheme.surface
        : theme.colorScheme.primary;
    final textColor = isDark
        ? theme.colorScheme.onSurface
        : Colors.white;
    final avatarBgColor = isDark
        ? theme.colorScheme.primary
        : theme.scaffoldBackgroundColor;
    final avatarTextColor = isDark
        ? Colors.white
        : theme.colorScheme.primary;
    
    return AppBar(
      backgroundColor: appBarColor,
      title: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: avatarBgColor,
            child: Text(
              widget.conversaInfo.iniciais,
              style: TextStyle(
                color: avatarTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.conversaInfo.nome,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMessageList() {
    debugPrint('🎨 _buildMessageList chamado - _isLoading: $_isLoading, _messages.length: ${_messages.length}');
    
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_messages.isEmpty) {
      debugPrint('⚠️ Lista de mensagens está vazia');
      return Center(
        child: Text(
          'Inicie a conversa com ${widget.conversaInfo.nome}',
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    debugPrint('📝 Renderizando ${_messages.length} mensagens no ListView');
    debugPrint('📝 currentUserId: ${widget.currentUserId}');
    debugPrint('📝 Primeira mensagem - remetente: ${_messages.first.idUsuarioRemetente}, conteúdo: ${_messages.first.conteudo}');
    debugPrint('📝 Última mensagem - remetente: ${_messages.last.idUsuarioRemetente}, conteúdo: ${_messages.last.conteudo}');

    // Remover duplicatas baseado no ID da mensagem
    final mensagensUnicas = <ChatMessageModel>[];
    final idsVistos = <String>{};
    for (var msg in _messages) {
      if (!idsVistos.contains(msg.id)) {
        idsVistos.add(msg.id);
        mensagensUnicas.add(msg);
      }
    }
    
    if (mensagensUnicas.length != _messages.length) {
      debugPrint('⚠️ Removidas ${_messages.length - mensagensUnicas.length} mensagens duplicadas');
      setState(() {
        _messages = mensagensUnicas;
      });
    }

    return ListView.builder(
      key: ValueKey('message_list_${mensagensUnicas.length}'), // Key para forçar rebuild
      padding: const EdgeInsets.all(16),
      reverse: true, // ListView invertido: mensagens mais recentes no final aparecem primeiro
      itemCount: mensagensUnicas.length,
      itemBuilder: (context, index) {
        final message = mensagensUnicas[index];
        // Garantir comparação correta convertendo ambos para String
        final isMe = message.idUsuarioRemetente.toString() == widget.currentUserId.toString();
        
        // Log apenas para as primeiras 3 mensagens para não poluir
        if (index < 3) {
          debugPrint('💬 Renderizando mensagem $index: remetente=${message.idUsuarioRemetente}, currentUserId=${widget.currentUserId}, isMe=$isMe, conteúdo=${message.conteudo}');
        }
        
        final iniciais = isMe
            ? (widget.usuarioLogado?.nome.split(' ')[0][0].toUpperCase() ?? 'U')
            : widget.conversaInfo.iniciais;
        
        return MessageBubble(
          key: ValueKey('message_${message.id}_$index'), // Key única para cada mensagem
          conteudo: message.conteudo,
          horario: _formatTime(message.dataEnvio),
          isMe: isMe,
          iniciaisRemetente: iniciais,
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message) {
    final theme = Theme.of(context);
    final isMe = message.idUsuarioRemetente == widget.currentUserId;
    final time = _formatTime(message.dataEnvio);
    final isDark = theme.brightness == Brightness.dark;
    final bubbleColor = isMe 
        ? theme.colorScheme.primary
        : (isDark 
            ? theme.colorScheme.surfaceVariant
            : Colors.white);
    final textColor = isMe
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;
    final avatarColor = theme.colorScheme.primary;
    final avatarTextColor = theme.colorScheme.onPrimary;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: avatarColor,
              child: Text(
                widget.conversaInfo.iniciais,
                style: TextStyle(
                  color: avatarTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft:
                          isMe ? const Radius.circular(18) : const Radius.circular(4),
                      bottomRight:
                          isMe ? const Radius.circular(4) : const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.conteudo,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant, 
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: avatarColor,
              child: Text(
                widget.usuarioLogado?.nome.split(' ')[0][0].toUpperCase() ?? 'U',
                style: TextStyle(
                  color: avatarTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inputBgColor = isDark
        ? theme.colorScheme.surface
        : Colors.white;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.05);
    // Adicionar padding bottom considerando a área segura do sistema
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + bottomPadding, // Adiciona padding extra acima das ações do sistema
      ),
      decoration: BoxDecoration(
        color: inputBgColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem...',
                hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: isDark
                    ? theme.colorScheme.surfaceVariant
                    : theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary, 
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            backgroundColor: theme.colorScheme.primary,
            mini: true,
            child: Icon(
              Icons.send, 
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Card de contexto do item
  Widget _buildItemContextCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark
        ? theme.colorScheme.surfaceVariant
        : theme.colorScheme.primaryContainer;
    final borderColor = isDark
        ? theme.colorScheme.outline
        : theme.colorScheme.primary.withOpacity(0.3);
    final iconColor = theme.colorScheme.primary;
    final titleColor = theme.colorScheme.onSurfaceVariant;
    final itemNameColor = theme.colorScheme.onSurface;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conversa sobre:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.itemNome ?? 'Item #${widget.itemId}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: itemNameColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Botões de ação contextual
  Widget _buildActionButtons() {
    // Funcionalidades de reivindicação e devolução removidas
    return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark
        ? theme.colorScheme.surface
        : Colors.white;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.05);
    final successColor = isDark
        ? theme.colorScheme.primaryContainer
        : Colors.green.shade50;
    final successBorderColor = isDark
        ? theme.colorScheme.primary
        : Colors.green.shade300;
    final successIconColor = isDark
        ? theme.colorScheme.primary
        : Colors.green.shade700;
    final successTextColor = isDark
        ? theme.colorScheme.onPrimaryContainer
        : Colors.green.shade900;
    final infoColor = isDark
        ? theme.colorScheme.primaryContainer
        : Colors.blue.shade50;
    final infoBorderColor = isDark
        ? theme.colorScheme.primary
        : Colors.blue.shade300;
    final infoIconColor = isDark
        ? theme.colorScheme.primary
        : Colors.blue.shade700;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: containerColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: const SizedBox.shrink(), // Funcionalidades de reivindicação e devolução removidas
    );
  }

  // Funcionalidades de reivindicação e devolução removidas - rotas da API não estão mais disponíveis
}

