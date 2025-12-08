import 'package:flutter/material.dart';
import 'dart:io';

/// Widget reutilizável para exibir grid de imagens selecionadas
class ImageGridPicker extends StatelessWidget {
  final List<File> images;
  final VoidCallback onAddImage;
  final VoidCallback onRemoveAll;
  final Function(int) onRemoveImage;
  final bool showUploadProgress;
  final double uploadProgress;
  final String addButtonText;
  final String removeAllText;

  const ImageGridPicker({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemoveAll,
    required this.onRemoveImage,
    this.showUploadProgress = false,
    this.uploadProgress = 0.0,
    this.addButtonText = 'Selecionar Imagens',
    this.removeAllText = 'Remover todas as imagens',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: onAddImage,
            child: Text(
              images.isEmpty ? addButtonText : 'Adicionar Mais Imagens',
            ),
          ),
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            '${images.length} imagem(ns) selecionada(s)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _buildImageGrid(),
          const SizedBox(height: 16),
          if (showUploadProgress) _buildUploadProgress() else _buildRemoveButton(),
        ],
      ],
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final theme = Theme.of(context);
        return AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 200),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    images[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onRemoveImage(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadProgress() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: uploadProgress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  uploadProgress < 1.0 ? Colors.orange : Colors.green,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              uploadProgress < 1.0 ? Icons.upload : Icons.check_circle,
              color: uploadProgress < 1.0 ? Colors.orange : Colors.green,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${(uploadProgress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 12,
            color: uploadProgress < 1.0 ? Colors.orange : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return TextButton(
      onPressed: onRemoveAll,
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
      ),
      child: Text(
        removeAllText,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

