import 'package:flutter/material.dart';

/// Wrapper que anima transições de tema suavemente
class AnimatedThemeWrapper extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const AnimatedThemeWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      child: child,
    );
  }
}

/// Widget que anima mudanças de cor suavemente
class AnimatedColorContainer extends StatelessWidget {
  final Color color;
  final Widget child;
  final Duration duration;

  const AnimatedColorContainer({
    super.key,
    required this.color,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      color: color,
      child: child,
    );
  }
}

