import 'package:flutter/material.dart';

/// Dialog para confirmar devolução de item
class DevolucaoDialog extends StatefulWidget {
  final Function(String detalhes) onConfirm;

  const DevolucaoDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<DevolucaoDialog> createState() => _DevolucaoDialogState();

  static Future<void> show(
    BuildContext context,
    Function(String detalhes) onConfirm,
  ) {
    return showDialog(
      context: context,
      builder: (context) => DevolucaoDialog(onConfirm: onConfirm),
    );
  }
}

class _DevolucaoDialogState extends State<DevolucaoDialog> {
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
      title: const Text('Confirmar Devolução'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descreva onde e como o item foi devolvido:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mínimo 20 caracteres',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _controller,
              maxLines: 4,
              maxLength: 500,
              validator: (value) {
                if (value == null || value.trim().length < 20) {
                  return 'Mínimo 20 caracteres';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText:
                    'Ex: Item devolvido na portaria do campus às 14h do dia 15/01',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
              widget.onConfirm(_controller.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirmar Devolução'),
        ),
      ],
    );
  }
}
