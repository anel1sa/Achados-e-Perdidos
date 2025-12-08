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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark 
        ? theme.colorScheme.surfaceVariant
        : theme.colorScheme.primary;
    final textColor = isDark
        ? theme.colorScheme.onSurfaceVariant
        : Colors.white;
    
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
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildItemContent(context, textColor), _buildItemFooter(context, textColor)],
        ),
      ),
    );
  }

  Widget _buildItemContent(BuildContext context, Color textColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconBgColor = isDark
        ? theme.colorScheme.surface
        : Colors.white;
    final iconColor = isDark
        ? theme.colorScheme.primary
        : theme.colorScheme.primary;
    
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
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.fotos![0].url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceVariant,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceVariant,
                        child: Icon(icone, size: 28, color: iconColor),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icone, size: 28, color: iconColor),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.descricao ?? 'Sem descrição',
                  style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemFooter(BuildContext context, Color textColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final footerColor = isDark
        ? theme.colorScheme.surface
        : theme.colorScheme.primary;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: footerColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline, 
            size: 14, 
            color: isDark 
                ? theme.colorScheme.onSurfaceVariant
                : textColor.withOpacity(0.8),
          ),
          const SizedBox(width: 4),
          Text(
            // Priorizar usuarioRelatorNome (nome do dono do post)
            // Se não estiver disponível e o item for do usuário logado, usar nome do usuário logado
            // Caso contrário, mostrar "Usuário"
            item.usuarioRelatorNome ?? 
                (item.usuarioRelatorId == usuario.id ? usuario.nome : "Usuário"),
            style: TextStyle(
              fontSize: 12, 
              color: isDark 
                  ? theme.colorScheme.onSurfaceVariant
                  : textColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}


