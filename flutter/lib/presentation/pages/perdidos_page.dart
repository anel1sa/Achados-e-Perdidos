import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

// Widgets
import '../widgets/common/user_header.dart';
import '../widgets/common/search_bar_with_filter.dart';
import '../widgets/common/item_card.dart';
import '../widgets/common/app_bottom_navigation.dart';
import '../widgets/app_snackbar.dart';

// Models
import '../../data/DTOs/item_dto.dart';
import '../../data/DTOs/usuario_dto.dart';
import '../../data/DTOs/campus_dto.dart';

// Mixins
import 'mixins/items_page_mixin.dart';

/// Página que exibe os itens perdidos
class PerdidosPage extends StatefulWidget {
  final UsuarioDTO usuarioLogado;

  const PerdidosPage({super.key, required this.usuarioLogado});

  @override
  State<PerdidosPage> createState() => _PerdidosPageState();
}

class _PerdidosPageState extends State<PerdidosPage> with ItemsPageMixin {
  @override
  void initState() {
    super.initState();
    initializeUserData(widget.usuarioLogado);
    loadInitialData();
  }

  @override
  Future<void> loadItems() async {
    try {
      final itens = await itemService.getAllItens();
      
      // Buscar nomes dos usuários relatores que não estão disponíveis
      await loadUserNames(itens);
      
      if (mounted) {
        setState(() {
          items = itens;
          filteredItems = itens;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        AppSnackBar.showError(
          context,
          tratarErro(e.toString()),
        );
      }
    }
  }

  @override
  bool itemContainsQuery(ItemDTO item, String query) {
    final nome = removeDiacritics((item.nome ?? '').toLowerCase());
    final descricao = removeDiacritics((item.descricao ?? '').toLowerCase());
    final local = removeDiacritics((item.descLocalItem).toLowerCase());

    return nome.contains(query) ||
        descricao.contains(query) ||
        local.contains(query);
  }

  @override
  IconData getIconeByCategoria(int? categoriaId) {
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
      bottomNavigationBar: AppBottomNavigation(
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
      nomeUsuario: nomeUsuario,
      iniciaisUsuario: iniciaisUsuario,
    );
  }

  Widget _buildSearchBar() {
    return SearchBarWithFilter(
      searchController: searchController,
      onSearchChanged: filterItems,
      campi: campi,
      campusSelecionado: campusSelecionado,
      onCampusSelected: onCampusSelected,
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
        child: isLoading ? _buildLoading() : _buildItemsList(),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildItemsList() {
    if (filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16, left: 3, right: 3),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final icone = getIconeByCategoria(item.statusId);

        return ItemCard(
          item: item,
          usuario: widget.usuarioLogado,
          icone: icone,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum item encontrado',
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

