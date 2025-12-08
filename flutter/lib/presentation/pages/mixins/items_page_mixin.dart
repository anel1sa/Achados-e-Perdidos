import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:diacritic/diacritic.dart';
import '../../../data/services/item_service.dart';
import '../../../data/services/campus_service.dart';
import '../../../data/services/usuario_service.dart';
import '../../../data/DTOs/item_dto.dart';
import '../../../data/DTOs/campus_dto.dart';
import '../../../data/DTOs/usuario_dto.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/user_utils.dart';
import '../../widgets/app_snackbar.dart';

/// Mixin com lógica comum para páginas de itens (Achados e Perdidos)
mixin ItemsPageMixin<T extends StatefulWidget> on State<T> {
  // Services
  final ItemService itemService = ItemService();
  final UsuarioService usuarioService = UsuarioService();

  // Controllers
  final TextEditingController searchController = TextEditingController();

  // State
  List<ItemDTO> items = [];
  List<ItemDTO> filteredItems = [];
  List<CampusDTO> campi = [];
  CampusDTO? campusSelecionado;
  bool isLoading = true;
  Map<int, String> nomesUsuarios = {};

  // User data
  String nomeUsuario = '';
  String iniciaisUsuario = '';

  /// Inicializa os dados do usuário
  void initializeUserData(UsuarioDTO usuario) {
    nomeUsuario = UserUtils.getFirstName(usuario.nome);
    iniciaisUsuario = UserUtils.generateInitials(usuario.nome);
  }

  /// Carrega dados iniciais da página
  Future<void> loadInitialData() async {
    await Future.wait([loadItems(), loadCampi()]);
  }

  /// Carrega a lista de itens (deve ser implementado nas classes filhas)
  Future<void> loadItems();

  /// Carrega a lista de campi disponíveis
  Future<void> loadCampi() async {
    try {
      final campusService = CampusService();
      final campiList = await campusService.getAllCampus();
      if (mounted) {
        setState(() {
          campi = campiList;
          campusSelecionado = campiList.isNotEmpty ? campiList.first : null;
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

  /// Carrega os nomes dos usuários relatores que não estão disponíveis nos itens
  Future<void> loadUserNames(List<ItemDTO> items) async {
    // Identificar IDs de usuários que precisam ser buscados
    final idsParaBuscar = <int>{};
    for (final item in items) {
      if (item.usuarioRelatorNome == null || item.usuarioRelatorNome!.isEmpty) {
        if (!nomesUsuarios.containsKey(item.usuarioRelatorId)) {
          idsParaBuscar.add(item.usuarioRelatorId);
        }
      } else {
        // Já tem o nome, adicionar ao cache
        nomesUsuarios[item.usuarioRelatorId] = item.usuarioRelatorNome!;
      }
    }

    // Buscar nomes dos usuários em paralelo
    if (idsParaBuscar.isNotEmpty) {
      final futures = idsParaBuscar.map((id) async {
        try {
          final usuario = await usuarioService.getUsuarioById(id);
          return MapEntry(id, usuario.nome);
        } catch (e) {
          debugPrint('Erro ao buscar usuário $id: $e');
          return MapEntry(id, 'Usuário');
        }
      });

      final resultados = await Future.wait(futures);
      for (final entry in resultados) {
        nomesUsuarios[entry.key] = entry.value;
      }

      // Atualizar os itens com os nomes buscados
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        if (item.usuarioRelatorNome == null || item.usuarioRelatorNome!.isEmpty) {
          final nome = nomesUsuarios[item.usuarioRelatorId];
          if (nome != null) {
            // Atualizar o item com o nome encontrado
            items[i] = ItemDTO(
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

  /// Filtra os itens baseado na query de busca
  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        final queryNormalized = removeDiacritics(query.toLowerCase());
        filteredItems = items.where((item) {
          return itemContainsQuery(item, queryNormalized);
        }).toList();
      }
    });
  }

  /// Verifica se o item contém a query de busca (deve ser implementado nas classes filhas)
  bool itemContainsQuery(ItemDTO item, String query);

  /// Seleciona um campus no filtro
  void onCampusSelected(CampusDTO campus) {
    setState(() {
      campusSelecionado = campus;
    });
  }

  /// Trata mensagens de erro para exibição amigável
  String tratarErro(String erro) {
    return ErrorUtils.tratarErroRede(erro);
  }

  /// Determina o ícone baseado na categoria do item (deve ser implementado nas classes filhas)
  IconData getIconeByCategoria(int? categoriaId);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

