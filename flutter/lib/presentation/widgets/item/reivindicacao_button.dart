import 'package:flutter/material.dart';

/// Botão de reivindicação de item
class ReivindicacaoButton extends StatelessWidget {
  final bool jaReivindicou;
  final VoidCallback onPressed;
  final bool isLoading;

  const ReivindicacaoButton({
    super.key,
    required this.jaReivindicou,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (jaReivindicou) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Você já reivindicou este item',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade900,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check_circle_outline),
        label: const Text(
          'Reivindicar Este Item',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF17603A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),
    );
  }
}
