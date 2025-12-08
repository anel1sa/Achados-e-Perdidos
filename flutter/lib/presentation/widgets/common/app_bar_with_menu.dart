import 'package:flutter/material.dart';
import '../../../data/DTOs/usuario_dto.dart';
import '../../../core/utils/user_utils.dart';

/// AppBar reutilizável com menu de configurações
class AppBarWithMenu extends StatelessWidget implements PreferredSizeWidget {
  final UsuarioDTO? usuario;
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AppBarWithMenu({
    super.key,
    this.usuario,
    this.title,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final nomeUsuario = usuario != null 
        ? UserUtils.getFirstName(usuario!.nome)
        : 'Usuário';
    final iniciaisUsuario = usuario != null
        ? UserUtils.generateInitials(usuario!.nome)
        : 'U';

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      title: title != null
          ? Text(title!)
          : Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isDark 
                      ? theme.colorScheme.primary
                      : theme.scaffoldBackgroundColor,
                  child: Text(
                    iniciaisUsuario,
                    style: TextStyle(
                      color: isDark 
                          ? Colors.white
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Olá, $nomeUsuario! :)',
                ),
              ],
            ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(
            Icons.settings, 
            color: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
          ),
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          offset: const Offset(0, 50),
          tooltip: 'Configurações',
          onSelected: (String value) => _handleMenuSelection(context, value),
          itemBuilder: (BuildContext context) => _buildMenuItems(context),
        ),
      ],
    );
  }

  List<PopupMenuItem<String>> _buildMenuItems(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final iconColor = theme.colorScheme.primary;
    
    return [
      PopupMenuItem<String>(
        value: 'perfil',
        child: Row(
          children: [
            Icon(Icons.person_outline, color: iconColor, size: 20),
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
            Icon(Icons.settings_outlined, color: iconColor, size: 20),
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
            Icon(Icons.help_outline, color: iconColor, size: 20),
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
            Icon(Icons.info_outline, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(
              'Sobre nós',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ],
        ),
      ),
    ];
  }

  void _handleMenuSelection(BuildContext context, String value) {
    if (usuario == null) return;

    switch (value) {
      case 'perfil':
        Navigator.pushNamed(
          context,
          '/perfil',
          arguments: usuario,
        );
        break;
      case 'configuracoes':
        Navigator.pushNamed(
          context,
          '/configuracoes',
          arguments: usuario,
        );
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
  }
}

