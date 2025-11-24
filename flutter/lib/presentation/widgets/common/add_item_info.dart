import 'package:flutter/material.dart';
import '../../../data/DTOs/usuario_dto.dart';

/// Widget informativo para adicionar item achado
class AddItemInfo extends StatelessWidget {
  final UsuarioDTO usuario;

  const AddItemInfo({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF17603A),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 32),
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed('/cadastro-item', arguments: usuario);
              },
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Se você encontrou um item, clique no ícone para publicá-lo. Caso tenha perdido algo, vá até a página 'Perdidos' e registre o item que está procurando.",
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}


