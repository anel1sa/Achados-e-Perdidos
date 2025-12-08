import 'package:flutter/material.dart';

/// Widget informativo para a página de chat
class ChatInfoWidget extends StatelessWidget {
  const ChatInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 2),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Text(
              "Fique de olho nas respostas e atualizações. Esperamos que seu item seja encontrado em breve!",
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

