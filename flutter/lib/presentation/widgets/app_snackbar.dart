import 'package:flutter/material.dart';

/// Tipos de notificação do sistema
enum SnackBarType {
  success,
  error,
  warning,
  info,
}

/// Widget padronizado para exibir notificações no app
class AppSnackBar {
  /// Exibe uma notificação de sucesso
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, SnackBarType.success);
  }

  /// Exibe uma notificação de erro
  static void showError(BuildContext context, String message) {
    _show(context, message, SnackBarType.error);
  }

  /// Exibe uma notificação de aviso
  static void showWarning(BuildContext context, String message) {
    _show(context, message, SnackBarType.warning);
  }

  /// Exibe uma notificação informativa
  static void showInfo(BuildContext context, String message) {
    _show(context, message, SnackBarType.info);
  }

  /// Método interno para exibir a notificação
  static void _show(
    BuildContext context,
    String message,
    SnackBarType type,
  ) {
    // Verifica se o context ainda está montado
    if (!context.mounted) return;

    final config = _getConfig(type);

    // Remove qualquer SnackBar anterior antes de mostrar o novo
    try {
      ScaffoldMessenger.of(context).clearSnackBars();
    } catch (e) {
      // Ignora se o context já foi desmontado
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(config.icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Retorna a configuração de acordo com o tipo
  static _SnackBarConfig _getConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          icon: Icons.check_circle,
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          icon: Icons.error,
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 4),
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          icon: Icons.warning,
          backgroundColor: Colors.orange.shade600,
          duration: const Duration(seconds: 3),
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          icon: Icons.info,
          backgroundColor: Colors.blue.shade600,
          duration: const Duration(seconds: 3),
        );
    }
  }
}

/// Configuração interna do SnackBar
class _SnackBarConfig {
  final IconData icon;
  final Color backgroundColor;
  final Duration duration;

  _SnackBarConfig({
    required this.icon,
    required this.backgroundColor,
    required this.duration,
  });
}
