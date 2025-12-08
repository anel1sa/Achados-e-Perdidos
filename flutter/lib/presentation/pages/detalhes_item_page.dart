import 'package:flutter/material.dart';

// Services
import '../../data/services/item_service.dart';
import '../../data/services/usuario_service.dart';

// Widgets
import '../widgets/common/bottom_navigation_achados.dart';
import '../widgets/item/item_widgets.dart';

// Models
import '../../data/DTOs/item_dto.dart';
import '../../data/DTOs/usuario_dto.dart';

class DetalhesItemPage extends StatefulWidget {
  final ItemDTO item;
  final UsuarioDTO? usuarioLogado;

  const DetalhesItemPage({super.key, required this.item, this.usuarioLogado});

  @override
  State<DetalhesItemPage> createState() => _DetalhesItemPageState();
}

class _DetalhesItemPageState extends State<DetalhesItemPage> {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                _iniciaisUsuario,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Olá, $_nomeUsuario! :)',
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.settings, 
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
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
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'perfil',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Perfil'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'configuracoes',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'ajuda',
                child: ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Ajuda'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sobre',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Sobre nós'),
                  contentPadding: EdgeInsets.zero,
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
            ItemImageCard(fotos: widget.item.fotos ?? []),
            const SizedBox(height: 24),

            // Nome do item
            Text(
              widget.item.nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Descrição
            ItemDetailField(
              label: 'Descrição:',
              value: widget.item.descricao,
              icon: Icons.description,
            ),
            const SizedBox(height: 16),

            // Local encontrado
            ItemDetailField(
              label: 'Encontrado em:',
              value: widget.item.descLocalItem,
              icon: Icons.location_on,
            ),
            const SizedBox(height: 16),

            // Data de cadastro
            ItemDetailField(
              label: 'Data de cadastro:',
              value: widget.item.dtaCriacao != null
                  ? '${widget.item.dtaCriacao!.day}/${widget.item.dtaCriacao!.month}/${widget.item.dtaCriacao!.year}'
                  : 'Não informado',
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 32),

            // Botões de Ação
            // Botão de reivindicação removido - funcionalidade não está mais disponível
            
            const SizedBox(height: 16),

            ContatoButton(onPressed: _abrirChat),

            const SizedBox(height: 24),

            // Pergunta "Este item é seu?" (mantida para compatibilidade)
            // Botão de reivindicação removido
            if (false)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Este item é seu?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: TextButton(
                        onPressed: () {}, // Funcionalidade removida
                        child: const Text(
                          'Sim',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF17603A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationAchados(
        usuario: widget.usuarioLogado!,
        currentIndex: 0, // Default para Achados
      ),
    );
  }

  // Funcionalidades de reivindicação removidas - rotas da API não estão mais disponíveis
  void _mostrarFormularioReivindicacao() {
    // Removido
  }

  // Funcionalidade de reivindicação removida
  Future<void> _enviarReivindicacao(String descricao) async {
    // Removido - rotas da API não estão mais disponíveis
  }

  void _abrirChat() {
    if (widget.usuarioLogado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar logado para entrar em contato'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'usuario': widget.usuarioLogado,
        'itemId': widget.item.id,
        'itemNome': widget.item.nome,
      },
    );
  }
}

