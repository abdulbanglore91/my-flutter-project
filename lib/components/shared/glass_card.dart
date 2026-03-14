import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app_theme.dart';

// =============================================================================
// GlassCard
// Reusable glassmorphism container — mirrors the `.glass-card` CSS class.
// Uses BackdropFilter for the frosted-glass blur effect.
// =============================================================================

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final double borderOpacity;
  final double blurSigma;
  final List<BoxShadow>? boxShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppRadius.xl2,
    this.borderColor,
    this.borderOpacity = 1.0,
    this.blurSigma = 20.0,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorder =
        (borderColor ?? AppColors.glassBorder).withValues(alpha: borderOpacity);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: effectiveBorder, width: 1),
            boxShadow: boxShadow ?? AppShadows.card,
          ),
          child: child,
        ),
      ),
    );
  }
}
