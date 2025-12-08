import 'package:flutter/material.dart';

/// Card mostrando contexto do item na conversa
class ItemContextCard extends StatelessWidget {
  final int itemId;
  final String? itemNome;

  const ItemContextCard({
    super.key,
    required this.itemId,
    this.itemNome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark
        ? theme.colorScheme.surfaceVariant
        : theme.colorScheme.primaryContainer;
    final borderColor = isDark
        ? theme.colorScheme.outline
        : theme.colorScheme.primary.withOpacity(0.3);
    final iconColor = theme.colorScheme.primary;
    final titleColor = theme.colorScheme.onSurfaceVariant;
    final itemNameColor = theme.colorScheme.onSurface;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conversa sobre:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  itemNome ?? 'Item #$itemId',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: itemNameColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
