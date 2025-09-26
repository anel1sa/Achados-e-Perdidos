import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
import 'services/usuario_service.dart';
import 'services/item_service.dart';

class AchadosPage extends StatefulWidget {
  final UsuarioModel usuarioLogado;

  const AchadosPage({super.key, required this.usuarioLogado});

  @override
  State<AchadosPage> createState() => _AchadosPageState();
}

class _AchadosPageState extends State<AchadosPage> {
  late String _nomeUsuario;
  late String _iniciaisUsuario;
  final ItemService _itemService = ItemService();
  List<ItemAchadoModel> _itensAchados = [];
  List<ItemAchadoModel> _itensAchadosFiltrados = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  List<CampusModel> _campi = [];
  CampusModel? _campusSelecionado;

  @override
  void initState() {
    super.initState();
    _nomeUsuario = widget.usuarioLogado.nome.split(' ')[0];
    final nomes = widget.usuarioLogado.nome.split(' ');
    if (nomes.length > 1) {
      _iniciaisUsuario = nomes[0][0] + nomes[1][0];
    } else {
      _iniciaisUsuario = nomes[0].substring(0, nomes[0].length > 1 ? 2 : 1);
    }
    _iniciaisUsuario = _iniciaisUsuario.toUpperCase();
    _carregarItensAchados();
    _carregarCampi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarItensAchados() async {
    try {
      final itens = await _itemService.getItensAchados();
      setState(() {
        _itensAchados = itens;
        _itensAchadosFiltrados = itens;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar itens achados: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _carregarCampi() async {
    final usuarioService = UsuarioService();
    final campi = await usuarioService.getCampi();
    setState(() {
      _campi = campi;
      if (_campi.isNotEmpty) {
        _campusSelecionado = _campi.first;
      }
    });
  }

  void _filtrarItens(String query) {
    setState(() {
      String querySemAcento = removeDiacritics(query.toLowerCase());
      if (query.isEmpty) {
        _itensAchadosFiltrados = _itensAchados;
      } else {
        _itensAchadosFiltrados = _itensAchados
            .where(
              (item) =>
                  removeDiacritics(
                    item.titulo.toLowerCase(),
                  ).contains(querySemAcento) ||
                  removeDiacritics(
                    item.descricao.toLowerCase(),
                  ).contains(querySemAcento),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verificar se há um usuário logado válido
    if (widget.usuarioLogado.id == null || widget.usuarioLogado.nome.isEmpty) {
      // Se não houver usuário válido, redirecionar para a página de login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });

      // Exibir tela de carregamento enquanto redireciona
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Construir a página normalmente se houver um usuário logado
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Cabeçalho do usuário com fundo verde
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            color: const Color(0xFF17603A),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar e saudação do usuário
                Row(
                  children: [
                    // Avatar do usuário
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Text(
                        _iniciaisUsuario,
                        style: const TextStyle(
                          color: Color(0xFF17603A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Saudação
                    Text(
                      "Olá, $_nomeUsuario! :)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                // Menu de configurações
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
                          const SnackBar(
                            content: Text('Ajuda em desenvolvimento'),
                          ),
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
                            style: TextStyle(
                              color: Color(0xFF17603A),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'configuracoes',
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            color: Color(0xFF17603A),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Configurações',
                            style: TextStyle(
                              color: Color(0xFF17603A),
                              fontSize: 16,
                            ),
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
                            style: TextStyle(
                              color: Color(0xFF17603A),
                              fontSize: 16,
                            ),
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
                            style: TextStyle(
                              color: Color(0xFF17603A),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ), // Espaço maior entre cabeçalho e campo de pesquisa
          // Campo de busca
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filtrarItens,
                      decoration: const InputDecoration(
                        hintText: 'Pesquisar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Color(0xFF17603A)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Substitua o PopupMenuButton<CampusModel> do filtro por:
                PopupMenuButton<CampusModel>(
                  onSelected: (campus) {
                    setState(() {
                      _campusSelecionado = campus;
                    });
                  },
                  color: const Color(0xFF17603A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  offset: const Offset(0, 48),
                  itemBuilder: (context) => _campi.map((campus) {
                    return PopupMenuItem<CampusModel>(
                      value: campus,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            campus.nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17603A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _campusSelecionado?.nome ?? 'Campus',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.filter_list, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Conteúdo principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        left: 3,
                        right: 3,
                      ),
                      itemCount: _itensAchadosFiltrados.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Texto informativo com botão flutuante centralizado
                          return Container(
                            margin: const EdgeInsets.only(top: 4, bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF17603A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        '/cadastro-item',
                                        arguments: widget.usuarioLogado,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    "Se você encontrou um item, clique no ícone para publicá-lo. Caso tenha perdido algo, vá até a página 'Perdidos' e registre o item que está procurando.",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        final item = _itensAchadosFiltrados[index - 1];
                        // Determinar o ícone com base na categoria
                        IconData icone = Icons.category_outlined;
                        switch (item.categoriaId) {
                          case 1:
                            icone = Icons.headphones_outlined;
                            break;
                          case 2:
                            icone = Icons.description_outlined;
                            break;
                          case 3:
                            icone = Icons.watch_outlined;
                            break;
                          case 4:
                            icone = Icons.school_outlined;
                            break;
                        }
                        return _buildItemCard(item: item, icone: icone);
                      },
                    ),
            ),
          ),
        ],
      ),

      // Barra de navegação inferior arredondada
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: 0, // Sempre seleciona Achados nesta página
          backgroundColor: const Color(0xFF17603A),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 1) {
              Navigator.of(context).pushReplacementNamed(
                '/perdidos',
                arguments: widget.usuarioLogado,
              );
            } else if (index == 2) {
              Navigator.of(
                context,
              ).pushReplacementNamed('/chat', arguments: widget.usuarioLogado);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Achados"),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: "Perdidos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "Chat",
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
      ),
    );
  }

  // Widget para construir card de item
  Widget _buildItemCard({
    required ItemAchadoModel item,
    IconData icone = Icons.category_outlined,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detalhes-item',
          arguments: {'item': item, 'usuario': widget.usuarioLogado},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF17603A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icone,
                      size: 28,
                      color: const Color(0xFF17603A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.descricao,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF17603A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.nomeUsuario ?? "Usuário",
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
