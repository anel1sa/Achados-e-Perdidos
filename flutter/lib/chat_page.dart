import 'package:flutter/material.dart';

// Services
import 'services/usuario_service.dart';

// Widgets
import 'widgets/user_header.dart';
import 'widgets/bottom_navigation_achados.dart';
import 'widgets/chat_info_widget.dart';

class ChatPage extends StatefulWidget {
  final UsuarioModel? usuarioLogado;

  const ChatPage({Key? key, this.usuarioLogado}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // User data
  late String _nomeUsuario;
  late String _iniciaisUsuario;

  // State
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _loadInitialData();
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

  /// Carrega dados iniciais da página
  void _loadInitialData() {
    // Adicionar mensagens de exemplo
    _messages.addAll([
      ChatMessage(
        nome: 'Fulano',
        iniciais: 'FU',
        mensagem: 'Opa, achei seu fone!',
        tempo: '10:30',
        isMe: false,
      ),
      ChatMessage(
        nome: 'Ciclaniho',
        iniciais: 'CI',
        mensagem: 'Olá, achei seu fone',
        tempo: '11:15',
        isMe: false,
      ),
    ]);
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Cabeçalho do usuário
          UserHeader(
            usuario: widget.usuarioLogado!,
            nomeUsuario: _nomeUsuario,
            iniciaisUsuario: _iniciaisUsuario,
          ),
          const SizedBox(height: 3),

          // Widget de informação
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ChatInfoWidget(),
          ),

          // Conteúdo principal - Lista de mensagens
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _messages.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma conversa ainda.\\nQuando alguém responder sobre seus itens,\\nas mensagens aparecerão aqui!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        left: 3,
                        right: 3,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageCard(_messages[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationAchados(
        usuario: widget.usuarioLogado!,
        currentIndex: 2, // Chat tab ativo
      ),
    );
  }

  Widget _buildMessageCard(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF17603A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Text(
            message.iniciais,
            style: const TextStyle(
              color: Color(0xFF17603A),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              message.nome,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Text(
              message.tempo,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            message.mensagem,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        onTap: () {
          // TODO: Abrir conversa individual
          _openIndividualChat(message);
        },
      ),
    );
  }

  void _openIndividualChat(ChatMessage message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndividualChatPage(
          contact: message,
          usuarioLogado: widget.usuarioLogado,
        ),
      ),
    );
  }
}

class ChatMessage {
  final String nome;
  final String iniciais;
  final String mensagem;
  final String tempo;
  final bool isMe;

  ChatMessage({
    required this.nome,
    required this.iniciais,
    required this.mensagem,
    required this.tempo,
    this.isMe = false,
  });
}

class IndividualChatPage extends StatefulWidget {
  final ChatMessage contact;
  final UsuarioModel? usuarioLogado;
  final String? mensagemInicial;

  const IndividualChatPage({
    Key? key,
    required this.contact,
    this.usuarioLogado,
    this.mensagemInicial,
  }) : super(key: key);

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<IndividualMessage> _conversation = [];

  @override
  void initState() {
    super.initState();
    // Adicionar mensagem inicial do contato apenas se não estiver vazia
    if (widget.contact.mensagem.isNotEmpty) {
      _conversation.add(
        IndividualMessage(
          text: widget.contact.mensagem,
          isMe: false,
          time: widget.contact.tempo,
        ),
      );
    }

    // Se há mensagem inicial para enviar automaticamente, adicionar
    if (widget.mensagemInicial != null) {
      _conversation.add(
        IndividualMessage(
          text: widget.mensagemInicial!,
          isMe: true,
          time: _getCurrentTimeString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17603A),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Text(
                widget.contact.iniciais,
                style: const TextStyle(
                  color: Color(0xFF17603A),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.contact.nome,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _conversation.length,
              itemBuilder: (context, index) {
                final reversedIndex = _conversation.length - 1 - index;
                return _buildChatBubble(_conversation[reversedIndex]);
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF17603A),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _sendMessage,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(IndividualMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                widget.contact.iniciais,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: message.isMe
                        ? const Color(0xFF17603A)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: message.isMe
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                      bottomRight: message.isMe
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF17603A),
              child: Text(
                widget.usuarioLogado?.nome.split(' ')[0][0].toUpperCase() ??
                    'U',
                style: const TextStyle(
                  color: Colors.white,
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

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _conversation.add(
        IndividualMessage(
          text: _messageController.text.trim(),
          isMe: true,
          time: _getCurrentTimeString(),
        ),
      );
    });

    _messageController.clear();
  }

  String _getCurrentTimeString() {
    final now = TimeOfDay.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

class IndividualMessage {
  final String text;
  final bool isMe;
  final String time;

  IndividualMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}
