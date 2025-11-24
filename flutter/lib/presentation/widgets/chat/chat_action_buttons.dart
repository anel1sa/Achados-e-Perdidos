import 'package:flutter/material.dart';

/// Botões de ação contextual no chat (reivindicar/devolver)
class ChatActionButtons extends StatelessWidget {
  final bool jaReivindicou;
  final bool jaDevolvido;
  final bool isLoading;
  final VoidCallback onReivindicar;
  final VoidCallback onConfirmarDevolucao;

  const ChatActionButtons({
    super.key,
    required this.jaReivindicou,
    required this.jaDevolvido,
    required this.isLoading,
    required this.onReivindicar,
    required this.onConfirmarDevolucao,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: const Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Botão Reivindicar (se ainda não reivindicou)
          if (!jaReivindicou && !jaDevolvido)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onReivindicar,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Reivindicar Este Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17603A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

          // Status Reivindicado
          if (jaReivindicou && !jaDevolvido)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Item reivindicado',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Botão Confirmar Devolução (se reivindicou e não devolveu)
          if (jaReivindicou && !jaDevolvido) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onConfirmarDevolucao,
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Confirmar Devolução'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],

          // Status Devolvido
          if (jaDevolvido)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.done_all, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Item devolvido com sucesso!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
