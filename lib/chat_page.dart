import 'package:flutter/material.dart';
import 'services/usuario_service.dart';

class ChatPage extends StatefulWidget {
  final UsuarioModel? usuarioLogado;

  const ChatPage({Key? key, this.usuarioLogado}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String _nomeUsuario;
  late String _iniciaisUsuario;
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    if (widget.usuarioLogado != null) {
      _nomeUsuario = widget.usuarioLogado!.nome.split(' ')[0];
      final nomes = widget.usuarioLogado!.nome.split(' ');
      if (nomes.length > 1) {
        _iniciaisUsuario = nomes[0][0] + nomes[1][0];
      } else {
        _iniciaisUsuario = nomes[0].substring(0, nomes[0].length > 1 ? 2 : 1);
      }
      _iniciaisUsuario = _iniciaisUsuario.toUpperCase();
    } else {
      _nomeUsuario = 'Usuário';
      _iniciaisUsuario = 'U';
    }

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17603A),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Text(
                _iniciaisUsuario,
                style: const TextStyle(
                  color: Color(0xFF17603A),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Olá, $_nomeUsuario! :)',
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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings, color: Colors.white),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 50),
            onSelected: (String value) {
              switch (value) {
                case 'perfil':
                  Navigator.pushNamed(
                    context,
                    '/perfil',
                    arguments: widget.usuarioLogado,
                  );
                  break;
                case 'configuracoes':
                  Navigator.pushNamed(
                    context,
                    '/configuracoes',
                    arguments: widget.usuarioLogado,
                  );
                  break;
                case 'ajuda':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ajuda em desenvolvimento')),
                  );
                  break;
                case 'sobre':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sobre nós em desenvolvimento'),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'perfil',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Color(0xFF17603A)),
                    SizedBox(width: 12),
                    Text(
                      'Perfil',
                      style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'configuracoes',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: Color(0xFF17603A)),
                    SizedBox(width: 12),
                    Text(
                      'Configurações',
                      style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'ajuda',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Color(0xFF17603A)),
                    SizedBox(width: 12),
                    Text(
                      'Ajuda',
                      style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sobre',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF17603A)),
                    SizedBox(width: 12),
                    Text(
                      'Sobre nós',
                      style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Header com informações
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: const Text(
              'Fique de olho nas respostas e atualizações.\nEsperamos que seu item seja encontrado em breve!',
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),

          // Lista de mensagens
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma conversa ainda.\nQuando alguém responder sobre seus itens,\nas mensagens aparecerão aqui!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageCard(_messages[index]);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: 2, // Chat tab ativo
          backgroundColor: const Color(0xFF17603A),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(
                  context,
                  '/achados',
                  arguments: widget.usuarioLogado,
                );
                break;
              case 1:
                Navigator.pushReplacementNamed(
                  context,
                  '/perdidos',
                  arguments: widget.usuarioLogado,
                );
                break;
              case 2:
                // Já está na página de chat
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Achados'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: 'Perdidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
          ],
        ),
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
