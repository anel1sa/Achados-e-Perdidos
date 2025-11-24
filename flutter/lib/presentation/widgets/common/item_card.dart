import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/DTOs/item_dto.dart';
import '../../../data/DTOs/usuario_dto.dart';

/// Widget reutilizável para exibir um card de item
class ItemCard extends StatelessWidget {
  final ItemDTO item;
  final UsuarioDTO usuario;
  final IconData icone;

  const ItemCard({
    super.key,
    required this.item,
    required this.usuario,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detalhes-item',
          arguments: {'item': item, 'usuario': usuario},
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
          children: [_buildItemContent(), _buildItemFooter()],
        ),
      ),
    );
  }

  Widget _buildItemContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Mostrar foto se disponível, senão mostrar ícone
          item.fotos?.isNotEmpty == true
              ? Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.fotos![0].url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF17603A)),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(icone, size: 28, color: const Color(0xFF17603A)),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icone, size: 28, color: const Color(0xFF17603A)),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.descricao ?? 'Sem descrição',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemFooter() {
    return Container(
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
          const Icon(Icons.person_outline, size: 14, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            // Priorizar usuarioRelatorNome (nome do dono do post)
            // Se não estiver disponível e o item for do usuário logado, usar nome do usuário logado
            // Caso contrário, mostrar "Usuário"
            item.usuarioRelatorNome ?? 
                (item.usuarioRelatorId == usuario.id ? usuario.nome : "Usuário"),
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}


