import 'package:flutter/material.dart';

/// Campo de texto padronizado do app
class AppTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isObscured;
  final String? errorText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final double width;
  final bool enabled;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isObscured = false,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.width = 240.0,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        obscureText: isObscured,
        keyboardType: keyboardType,
        validator: validator ?? _defaultValidator,
        enabled: enabled,
        maxLines: maxLines,
        textInputAction: textInputAction,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          errorText: errorText,
          enabled: enabled,
        ),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
