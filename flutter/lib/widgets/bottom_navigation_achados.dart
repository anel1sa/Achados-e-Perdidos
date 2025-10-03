import 'package:flutter/material.dart';
import '../services/usuario_service.dart';

class BottomNavigationAchados extends StatelessWidget {
  final UsuarioModel usuario;
  final int currentIndex;

  const BottomNavigationAchados({
    super.key,
    required this.usuario,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: const Color(0xFF17603A),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(
              context,
            ).pushReplacementNamed('/achados', arguments: usuario);
          } else if (index == 1) {
            Navigator.of(
              context,
            ).pushReplacementNamed('/perdidos', arguments: usuario);
          } else if (index == 2) {
            Navigator.of(
              context,
            ).pushReplacementNamed('/chat', arguments: usuario);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Achados"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: "Perdidos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}
