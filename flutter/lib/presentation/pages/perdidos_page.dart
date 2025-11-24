import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:diacritic/diacritic.dart';

// Services
import '../../data/services/item_service.dart';
import '../../data/services/campus_service.dart';
import '../../data/services/usuario_service.dart';

// Widgets
import '../widgets/common/user_header.dart';
import '../widgets/common/search_bar_with_filter.dart';
import '../widgets/common/item_card.dart';
import '../widgets/common/bottom_navigation_achados.dart';
import '../widgets/app_snackbar.dart';

// Models
import '../../data/DTOs/item_dto.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/campus_dto.dart';

/// Página que exibe os itens perdidos
class PerdidosPage extends StatefulWidget {
  final UsuarioDTO usuarioLogado;

  const PerdidosPage({super.key, required this.usuarioLogado});

  @override
  State<PerdidosPage> createState() => _PerdidosPageState();
}

class _PerdidosPageState extends State<PerdidosPage> {
  // User data
  late String _nomeUsuario;
  late String _iniciaisUsuario;

  // Services
  final ItemService _itemService = ItemService();
  final UsuarioService _usuarioService = UsuarioService();

  // Controllers
  final TextEditingController _searchController = TextEditingController();

  // State
  List<ItemDTO> _itensPerdidos = [];
  List<ItemDTO> _itensPerdidosFiltrados = [];
  List<CampusDTO> _campi = [];
  CampusDTO? _campusSelecionado;
  bool _isLoading = true;
  Map<int, String> _nomesUsuarios = {}; // Cache de nomes de usuários por ID

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _loadInitialData();
  }

  /// Inicializa os dados do usuário
  void _initializeUserData() {
    final nomes = widget.usuarioLogado.nome.split(' ');
    _nomeUsuario = nomes[0];
    _iniciaisUsuario = _generateInitials(nomes);
  }

  /// Gera as iniciais do usuário
  String _generateInitials(List<String> nomes) {
    if (nomes.isEmpty || nomes[0].isEmpty) {
      return '?';
    }
    
    if (nomes.length > 1 && nomes[1].isNotEmpty) {
      return (nomes[0][0] + nomes[1][0]).toUpperCase();
    } else {
      final nome = nomes[0];
      if (nome.isEmpty) return '?';
      final maxLength = nome.length > 1 ? 2 : 1;
      return nome.substring(0, maxLength).toUpperCase();
    }
  }

  /// Carrega dados iniciais da página
  Future<void> _loadInitialData() async {
    await Future.wait([_carregarItensPerdidos(), _carregarCampi()]);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carrega a lista de itens perdidos
  Future<void> _carregarItensPerdidos() async {
    try {
      final itens = await _itemService.getAllItens();
      
      // Buscar nomes dos usuários relatores que não estão disponíveis
      await _carregarNomesUsuarios(itens);
      
      if (mounted) {
        setState(() {
          _itensPerdidos = itens;
          _itensPerdidosFiltrados = itens;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackBar.showError(
          context,
          _tratarErro(e.toString()),
        );
      }
    }
  }

  /// Carrega os nomes dos usuários relatores que não estão disponíveis nos itens
  Future<void> _carregarNomesUsuarios(List<ItemDTO> itens) async {
    // Identificar IDs de usuários que precisam ser buscados
    final idsParaBuscar = <int>{};
    for (final item in itens) {
      if (item.usuarioRelatorNome == null || item.usuarioRelatorNome!.isEmpty) {
        if (!_nomesUsuarios.containsKey(item.usuarioRelatorId)) {
          idsParaBuscar.add(item.usuarioRelatorId);
        }
      } else {
        // Já tem o nome, adicionar ao cache
        _nomesUsuarios[item.usuarioRelatorId] = item.usuarioRelatorNome!;
      }
    }

    // Buscar nomes dos usuários em paralelo
    if (idsParaBuscar.isNotEmpty) {
      final futures = idsParaBuscar.map((id) async {
        try {
          final usuario = await _usuarioService.getUsuarioById(id);
          return MapEntry(id, usuario.nome);
        } catch (e) {
          debugPrint('Erro ao buscar usuário $id: $e');
          return MapEntry(id, 'Usuário');
        }
      });

      final resultados = await Future.wait(futures);
      for (final entry in resultados) {
        _nomesUsuarios[entry.key] = entry.value;
      }

      // Atualizar os itens com os nomes buscados
      for (var i = 0; i < itens.length; i++) {
        final item = itens[i];
        if (item.usuarioRelatorNome == null || item.usuarioRelatorNome!.isEmpty) {
          final nome = _nomesUsuarios[item.usuarioRelatorId];
          if (nome != null) {
            // Atualizar o item com o nome encontrado
            // Como ItemDTO é imutável, vamos criar uma nova instância
            itens[i] = ItemDTO(
              id: item.id,
              nome: item.nome,
              descricao: item.descricao,
              tipoItem: item.tipoItem,
              descLocalItem: item.descLocalItem,
              usuarioRelatorId: item.usuarioRelatorId,
              dtaCriacao: item.dtaCriacao,
              flgInativo: item.flgInativo,
              dtaRemocao: item.dtaRemocao,
              usuarioRelatorNome: nome,
              statusId: item.statusId,
              fotos: item.fotos,
            );
          }
        }
      }
    }
  }

  /// Carrega a lista de campi disponíveis
  Future<void> _carregarCampi() async {
    try {
      final campusService = CampusService();
      final campi = await campusService.getAllCampus();
      if (mounted) {
        setState(() {
          _campi = campi;
          _campusSelecionado = campi.isNotEmpty ? campi.first : null;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showWarning(
          context,
          'Não foi possível carregar os campus',
        );
      }
    }
  }

  /// Trata mensagens de erro para exibição amigável
  String _tratarErro(String erro) {
    if (erro.contains('SocketException') || 
        erro.contains('Failed host lookup') ||
        erro.contains('Network is unreachable')) {
      return 'Sem conexão com a internet';
    } else if (erro.contains('TimeoutException') || erro.contains('timeout')) {
      return 'Tempo esgotado. Tente novamente';
    } else if (erro.contains('404')) {
      return 'Dados não encontrados';
    } else if (erro.contains('500') || erro.contains('502') || erro.contains('503')) {
      return 'Erro no servidor. Tente mais tarde';
    } else if (erro.contains('401') || erro.contains('403')) {
      return 'Acesso não autorizado';
    }
    return 'Erro ao carregar dados';
  }

  /// Filtra os itens baseado na query de busca
  void _filtrarItens(String query) {
    setState(() {
      if (query.isEmpty) {
        _itensPerdidosFiltrados = _itensPerdidos;
      } else {
        final queryNormalized = removeDiacritics(query.toLowerCase());
        _itensPerdidosFiltrados = _itensPerdidos.where((item) {
          return _itemContainsQuery(item, queryNormalized);
        }).toList();
      }
    });
  }

  /// Verifica se o item contém a query de busca
  bool _itemContainsQuery(ItemDTO item, String query) {
    final nome = removeDiacritics((item.nome ?? '').toLowerCase());
    final descricao = removeDiacritics((item.descricao ?? '').toLowerCase());
    final local = removeDiacritics((item.descLocalItem).toLowerCase());

    return nome.contains(query) ||
        descricao.contains(query) ||
        local.contains(query);
  }

  /// Seleciona um campus no filtro
  void _onCampusSelected(CampusDTO campus) {
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
        return Icons.account_balance_wallet_outlined;
      case 3:
        return Icons.visibility_outlined;
      case 4:
        return Icons.school_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationAchados(
        usuario: widget.usuarioLogado,
        currentIndex: 1, // Perdidos tab ativo
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        _buildSearchBar(),
        _buildContent(),
      ],
    );
  }

  Widget _buildHeader() {
    return UserHeader(
      usuario: widget.usuarioLogado,
      nomeUsuario: _nomeUsuario,
      iniciaisUsuario: _iniciaisUsuario,
    );
  }

  Widget _buildSearchBar() {
    return SearchBarWithFilter(
      searchController: _searchController,
      onSearchChanged: _filtrarItens,
      campi: _campi,
      campusSelecionado: _campusSelecionado,
      onCampusSelected: _onCampusSelected,
      onAddItem: () {
        Navigator.of(context).pushNamed(
          '/cadastro-item-perdido',
          arguments: widget.usuarioLogado,
        );
      },
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _isLoading ? _buildLoading() : _buildItemsList(),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildItemsList() {
    if (_itensPerdidosFiltrados.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16, left: 3, right: 3),
      itemCount: _itensPerdidosFiltrados.length,
      itemBuilder: (context, index) {
        final item = _itensPerdidosFiltrados[index];
        final icone = _getIconeByCategoria(item.statusId);

        return ItemCard(
          item: item,
          usuario: widget.usuarioLogado!,
          icone: icone,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum item encontrado',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

