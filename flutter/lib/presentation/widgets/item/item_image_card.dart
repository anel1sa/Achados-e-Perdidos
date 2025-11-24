import 'package:flutter/material.dart';
import '../../../data/DTOs/foto_dto.dart';

/// Widget reutilizável para exibir imagem do item
class ItemImageCard extends StatelessWidget {
  final List<FotoDTO> fotos;
  final double height;
  final BorderRadius? borderRadius;

  const ItemImageCard({
    super.key,
    required this.fotos,
    this.height = 200,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: fotos.isNotEmpty
          ? ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              child: Image.network(
                fotos[0].url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultImage();
                },
              ),
            )
          : _buildDefaultImage(),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 80,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
