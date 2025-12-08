import 'package:flutter/material.dart';
import '../../../data/DTOs/usuario_dto.dart';

/// BottomNavigationBar reutilizável para navegação principal
class AppBottomNavigation extends StatelessWidget {
  final UsuarioDTO usuario;
  final int currentIndex;

  const AppBottomNavigation({
    super.key,
    required this.usuario,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: isDark 
            ? theme.colorScheme.surface
            : theme.colorScheme.primary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isDark
            ? theme.colorScheme.primary
            : Colors.white,
        unselectedItemColor: isDark
            ? theme.colorScheme.onSurfaceVariant
            : Colors.white70,
        onTap: (index) => _handleNavigation(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Achados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'Perdidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/achados',
          arguments: usuario,
        );
        break;
      case 1:
        Navigator.pushReplacementNamed(
          context,
          '/perdidos',
          arguments: usuario,
        );
        break;
      case 2:
        Navigator.pushReplacementNamed(
          context,
          '/chat',
          arguments: usuario,
        );
        break;
    }
  }
}

