import 'package:flutter/material.dart';
import '../../../data/DTOs/usuario_dto.dart';

/// Widget reutilizável para exibir o cabeçalho do usuário
class UserHeader extends StatelessWidget {
  final UsuarioDTO usuario;
  final String nomeUsuario;
  final String iniciaisUsuario;

  const UserHeader({
    super.key,
    required this.usuario,
    required this.nomeUsuario,
    required this.iniciaisUsuario,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headerColor = isDark 
        ? theme.colorScheme.surface
        : theme.colorScheme.primary;
    final textColor = isDark
        ? theme.colorScheme.onSurface
        : Colors.white;
    
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 8, left: 16, right: 16),
      color: headerColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isDark
                    ? theme.colorScheme.primary
                    : Colors.white,
                child: Text(
                  iniciaisUsuario,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Olá, $nomeUsuario! :)",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone de notificações
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: textColor, size: 24),
                iconSize: 24,
                onPressed: () {
                  Navigator.pushNamed(context, '/notificacoes', arguments: usuario);
                },
                tooltip: 'Notificações',
              ),
              _buildSettingsMenu(context, theme, textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context, ThemeData theme, Color iconColor) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings, color: iconColor, size: 24),
      iconSize: 24,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 50),
      tooltip: 'Configurações',
      padding: EdgeInsets.zero,
      onSelected: (String value) {
        switch (value) {
          case 'perfil':
            Navigator.pushNamed(context, '/perfil', arguments: usuario);
            break;
          case 'configuracoes':
            Navigator.pushNamed(context, '/configuracoes', arguments: usuario);
            break;
          case 'ajuda':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ajuda em desenvolvimento')),
            );
            break;
          case 'sobre':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sobre nós em desenvolvimento')),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        final textColor = theme.colorScheme.onSurface;
        final menuIconColor = theme.colorScheme.primary;
        
        return [
          PopupMenuItem<String>(
            value: 'perfil',
            child: Row(
              children: [
                Icon(Icons.person_outline, color: menuIconColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Perfil',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'configuracoes',
            child: Row(
              children: [
                Icon(Icons.settings_outlined, color: menuIconColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Configurações',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'ajuda',
            child: Row(
              children: [
                Icon(Icons.help_outline, color: menuIconColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Ajuda',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'sobre',
            child: Row(
              children: [
                Icon(Icons.info_outline, color: menuIconColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Sobre nós',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}


