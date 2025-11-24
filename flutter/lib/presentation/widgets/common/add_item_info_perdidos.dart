import 'package:flutter/material.dart';
import '../../../data/DTOs/usuario_dto.dart';

/// Widget informativo para adicionar item perdido
class AddItemInfoPerdidos extends StatelessWidget {
  final UsuarioDTO usuario;

  const AddItemInfoPerdidos({super.key, required this.usuario});

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
                ).pushNamed('/cadastro-item-perdido', arguments: usuario);
              },
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Descreva aqui o que você está procurando. Quanto mais detalhes você fornecer (como cor, marca, local e data aproximada da perda), maiores são as chances de alguém reconhecer e devolver.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


