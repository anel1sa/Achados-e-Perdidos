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
          _buildCampusFilter(),
          if (onAddItem != null) ...[
            const SizedBox(width: 8),
            _buildAddButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFF17603A),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: onAddItem,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCampusFilter() {
    return PopupMenuButton<CampusDTO>(
      onSelected: onCampusSelected,
      color: const Color(0xFF17603A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      offset: const Offset(0, 48),
      itemBuilder: (context) => campi.map((campus) {
        return PopupMenuItem<CampusDTO>(
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
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF17603A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              campusSelecionado?.nome ?? 'Todos',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.filter_list, color: Colors.white),
          ],
        ),
      ),
    );
  }
}


