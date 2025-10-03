import 'package:flutter/material.dart';
import 'services/item_service.dart';
import 'services/usuario_service.dart';
import 'chat_page.dart';

class ItemAchadoPage extends StatefulWidget {
  final ItemAchadoModel item;
  final UsuarioModel? usuarioLogado;

  const ItemAchadoPage({Key? key, required this.item, this.usuarioLogado})
    : super(key: key);

  @override
  State<ItemAchadoPage> createState() => _ItemAchadoPageState();
}

class _ItemAchadoPageState extends State<ItemAchadoPage> {
  late String _nomeUsuario;
  late String _iniciaisUsuario;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do item
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: widget.item.fotos.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildItemImage(widget.item.fotos[0]),
                    )
                  : _buildDefaultImage(),
            ),
            const SizedBox(height: 24),

            // Nome do item
            Text(
              widget.item.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Descrição
            _buildDetailField('Descrição:', widget.item.descricao),
            const SizedBox(height: 16),

            // Local encontrado
            _buildDetailField('Encontrado em:', widget.item.localEncontrado),
            const SizedBox(height: 16),

            // Horário
            _buildDetailField(
              'Horário que foi encontrado:',
              widget.item.dataEncontrado,
            ),
            const SizedBox(height: 32),

            // Pergunta "Este item é seu?"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Este item é seu?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _mostrarDialogoConfirmacao();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF17603A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sim',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
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
                Navigator.pushReplacementNamed(
                  context,
                  '/chat',
                  arguments: widget.usuarioLogado,
                );
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

  Widget _buildDefaultImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 80,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildItemImage(String imagePath) {
    // Verificar se é uma URL válida
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultImage();
        },
      );
    }
    // Verificar se é um asset local
    else if (imagePath.startsWith('assets/') || !imagePath.contains('/')) {
      try {
        return Image.asset(
          imagePath.startsWith('assets/') ? imagePath : 'assets/$imagePath',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultImage();
          },
        );
      } catch (e) {
        return _buildDefaultImage();
      }
    }
    // Para qualquer outro caso, mostrar imagem padrão
    else {
      return _buildDefaultImage();
    }
  }

  Widget _buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _mostrarDialogoConfirmacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar item'),
          content: const Text(
            'Você confirma que este item é seu? Entre em contato com quem encontrou para combinar a entrega.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmarItem();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF17603A),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarItem() {
    // Criar um objeto ChatMessage para representar quem postou o item
    final ChatMessage contato = ChatMessage(
      nome: widget.item.nomeUsuario ?? 'Usuário',
      iniciais: _getIniciais(widget.item.nomeUsuario ?? 'Usuário'),
      mensagem: '', // Mensagem vazia para não aparecer nada do contato
      tempo: '10:00',
      isMe: false,
    );

    // Navegar para o chat individual com mensagem automática
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndividualChatPage(
          contact: contato,
          usuarioLogado: widget.usuarioLogado,
          mensagemInicial: 'Olá, o ${widget.item.titulo} é meu',
        ),
      ),
    );

    // Mostrar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrindo conversa com quem encontrou o item!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _getIniciais(String nome) {
    final nomes = nome.split(' ');
    if (nomes.length > 1) {
      return (nomes[0][0] + nomes[1][0]).toUpperCase();
    } else {
      return nomes[0].substring(0, nomes[0].length > 1 ? 2 : 1).toUpperCase();
    }
  }
}
