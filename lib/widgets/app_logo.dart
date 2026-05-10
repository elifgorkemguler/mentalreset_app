import 'package:flutter/material.dart';

import '../core/theme/app_gradients.dart';
import '../core/theme/app_shadows.dart';

/// MindFlow brand mark — gradient circle with a brain glyph in white.
class AppLogo extends StatelessWidget {
  final double size;
  final double iconSize;

  const AppLogo({super.key, this.size = 72, this.iconSize = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppGradients.logo,
        shape: BoxShape.circle,
        boxShadow: AppShadows.button,
      ),
      child: Icon(Icons.psychology_rounded, color: Colors.white, size: iconSize),
    );
  }
}
