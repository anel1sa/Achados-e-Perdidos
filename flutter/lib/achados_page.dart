import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

// Services
import 'services/usuario_service.dart';
import 'services/item_service.dart';

// Widgets
import 'widgets/user_header.dart';
import 'widgets/search_bar_with_filter.dart';
import 'widgets/item_card.dart';
import 'widgets/add_item_info.dart';
import 'widgets/bottom_navigation_achados.dart';

class AchadosPage extends StatefulWidget {
  final UsuarioModel usuarioLogado;

  const AchadosPage({super.key, required this.usuarioLogado});

  @override
  State<AchadosPage> createState() => _AchadosPageState();
}

class _AchadosPageState extends State<AchadosPage> {
  // User data
  late String _nomeUsuario;
  late String _iniciaisUsuario;

  // Services
  final ItemService _itemService = ItemService();

  // Controllers
  final TextEditingController _searchController = TextEditingController();

  // State
  List<ItemAchadoModel> _itensAchados = [];
  List<ItemAchadoModel> _itensAchadosFiltrados = [];
  List<CampusModel> _campi = [];
  CampusModel? _campusSelecionado;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Inicializa os dados do usuário
  void _initializeUserData() {
    final nomes = widget.usuarioLogado.nome.split(' ');
    _nomeUsuario = nomes[0];
    _iniciaisUsuario = _generateInitials(nomes);
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
  Future<void> _loadInitialData() async {
    await Future.wait([_carregarItensAchados(), _carregarCampi()]);
  }

  /// Carrega a lista de itens achados
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

  /// Carrega a lista de campi disponíveis
  Future<void> _carregarCampi() async {
    try {
      final usuarioService = UsuarioService();
      final campi = await usuarioService.getCampi();
      setState(() {
        _campi = campi;
        _campusSelecionado = campi.isNotEmpty ? campi.first : null;
      });
    } catch (e) {
      print('Erro ao carregar campi: $e');
    }
  }

  /// Filtra os itens baseado na query de busca
  void _filtrarItens(String query) {
    setState(() {
      if (query.isEmpty) {
        _itensAchadosFiltrados = _itensAchados;
      } else {
        final queryNormalized = removeDiacritics(query.toLowerCase());
        _itensAchadosFiltrados = _itensAchados.where((item) {
          return _itemContainsQuery(item, queryNormalized);
        }).toList();
      }
    });
  }

  /// Verifica se o item contém a query de busca
  bool _itemContainsQuery(ItemAchadoModel item, String query) {
    final titulo = removeDiacritics(item.titulo.toLowerCase());
    final descricao = removeDiacritics(item.descricao.toLowerCase());

    return titulo.contains(query) || descricao.contains(query);
  }

  /// Seleciona um campus no filtro
  void _onCampusSelected(CampusModel campus) {
    setState(() {
      _campusSelecionado = campus;
    });
  }

  /// Determina o ícone baseado na categoria do item
  IconData _getIconeByCategoria(int? categoriaId) {
    switch (categoriaId) {
      case 1:
        return Icons.headphones_outlined;
      case 2:
        return Icons.description_outlined;
      case 3:
        return Icons.watch_outlined;
      case 4:
        return Icons.school_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar se há um usuário logado válido
    if (widget.usuarioLogado.id == null || widget.usuarioLogado.nome.isEmpty) {
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
            usuario: widget.usuarioLogado,
            nomeUsuario: _nomeUsuario,
            iniciaisUsuario: _iniciaisUsuario,
          ),
          const SizedBox(height: 20),
          // Barra de pesquisa com filtro
          SearchBarWithFilter(
            searchController: _searchController,
            onSearchChanged: _filtrarItens,
            campi: _campi,
            campusSelecionado: _campusSelecionado,
            onCampusSelected: _onCampusSelected,
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
                          return AddItemInfo(usuario: widget.usuarioLogado);
                        }

                        final item = _itensAchadosFiltrados[index - 1];
                        final icone = _getIconeByCategoria(item.categoriaId);

                        return ItemCard(
                          item: item,
                          usuario: widget.usuarioLogado,
                          icone: icone,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationAchados(
        usuario: widget.usuarioLogado,
      ),
    );
  }
}
