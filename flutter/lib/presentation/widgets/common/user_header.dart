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
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 8, left: 16, right: 16),
      color: const Color(0xFF17603A),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Text(
                  iniciaisUsuario,
                  style: const TextStyle(
                    color: Color(0xFF17603A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Olá, $nomeUsuario! :)",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Ícone de notificações
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: Colors.white),
                    // Badge de notificações não lidas (pode ser implementado depois)
                    // Positioned(
                    //   right: 0,
                    //   top: 0,
                    //   child: Container(
                    //     width: 8,
                    //     height: 8,
                    //     decoration: const BoxDecoration(
                    //       color: Colors.red,
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notificacoes', arguments: usuario);
                },
                tooltip: 'Notificações',
              ),
              _buildSettingsMenu(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.settings, color: Colors.white),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 50),
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
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'perfil',
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Color(0xFF17603A)),
              SizedBox(width: 12),
              Text(
                'Perfil',
                style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'configuracoes',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, color: Color(0xFF17603A)),
              SizedBox(width: 12),
              Text(
                'Configurações',
                style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'ajuda',
          child: Row(
            children: [
              Icon(Icons.help_outline, color: Color(0xFF17603A)),
              SizedBox(width: 12),
              Text(
                'Ajuda',
                style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'sobre',
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF17603A)),
              SizedBox(width: 12),
              Text(
                'Sobre nós',
                style: TextStyle(color: Color(0xFF17603A), fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


