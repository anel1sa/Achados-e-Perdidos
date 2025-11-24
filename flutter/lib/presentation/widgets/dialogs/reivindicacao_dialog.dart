import 'package:flutter/material.dart';

/// Dialog para reivindicar item
class ReivindicacaoDialog extends StatefulWidget {
  final Function(String descricao) onConfirm;

  const ReivindicacaoDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<ReivindicacaoDialog> createState() => _ReivindicacaoDialogState();

  static Future<void> show(
    BuildContext context,
    Function(String descricao) onConfirm,
  ) {
    return showDialog(
      context: context,
      builder: (context) => ReivindicacaoDialog(onConfirm: onConfirm),
    );
  }
}

class _ReivindicacaoDialogState extends State<ReivindicacaoDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reivindicar Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descreva por que este item é seu (opcional):',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controller,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Ex: Perdi na biblioteca no dia 10/01',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onConfirm(_controller.text.trim());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF17603A),
            foregroundColor: Colors.white,
          ),
          child: const Text('Enviar Reivindicação'),
        ),
      ],
    );
  }
}
