import 'package:flutter/material.dart';

/// Botão para entrar em contato via chat
class ContatoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ContatoButton({
    super.key,
    required this.onPressed,
    this.text = 'Entrar em Contato',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.chat_bubble_outline),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.scaffoldBackgroundColor,
          foregroundColor: const Color(0xFF17603A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF17603A), width: 2),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
