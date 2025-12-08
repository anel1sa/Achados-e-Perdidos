import 'package:flutter/material.dart';
import '../../../data/DTOs/campus_dto.dart';

/// Widget reutilizável para barra de pesquisa com filtro de campus
class SearchBarWithFilter extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final List<CampusDTO> campi;
  final CampusDTO? campusSelecionado;
  final Function(CampusDTO) onCampusSelected;
  final VoidCallback? onAddItem;

  const SearchBarWithFilter({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.campi,
    required this.campusSelecionado,
    required this.onCampusSelected,
    this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildCampusFilter(context),
          if (onAddItem != null) ...[
            const SizedBox(width: 8),
            _buildAddButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.add, 
          color: theme.colorScheme.onPrimary, 
          size: 28,
        ),
        onPressed: onAddItem,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCampusFilter(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<CampusDTO>(
      onSelected: onCampusSelected,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      offset: const Offset(0, 48),
      itemBuilder: (context) => campi.map((campus) {
        return PopupMenuItem<CampusDTO>(
          value: campus,
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: theme.colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                campus.nome,
                style: TextStyle(
                  color: theme.colorScheme.onSurface, 
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              campusSelecionado?.nome ?? 'Todos',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.filter_list, 
              color: theme.colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}


