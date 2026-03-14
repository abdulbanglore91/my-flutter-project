import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../models/class_session.dart';

// =============================================================================
// TypeBadge
// Pill badge showing the class type (Lecture / Practical / Combined).
// Colors mirror the getTypeStyles() helper used in class-node.tsx and
// day-flashcard.tsx from the React source.
// =============================================================================

class TypeBadge extends StatelessWidget {
  final ClassType type;

  /// When false, applies 40% opacity — mirrors the `opacity-40` in the React source.
  final bool isSelected;

  const TypeBadge({
    super.key,
    required this.type,
    this.isSelected = true,
  });

  _TypeStyle get _style {
    switch (type) {
      case ClassType.practical:
        return _TypeStyle(
          background: AppColors.practicalBackground,
          textColor: AppColors.purpleLight,
          borderColor: AppColors.purple.withValues(alpha: 0.3),
        );
      case ClassType.combined:
        return _TypeStyle(
          background: AppColors.combinedBackground,
          textColor: AppColors.cyan,
          borderColor: AppColors.cyan.withValues(alpha: 0.3),
        );
      case ClassType.lecture:
        return _TypeStyle(
          background: AppColors.lectureBackground,
          textColor: AppColors.mutedForeground,
          borderColor: AppColors.border,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return Opacity(
      opacity: isSelected ? 1.0 : 0.4,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: style.borderColor, width: 1),
        ),
        child: Text(
          type.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: style.textColor,
          ),
        ),
      ),
    );
  }
}

/// Internal style container for a class type.
class _TypeStyle {
  final Color background;
  final Color textColor;
  final Color borderColor;

  const _TypeStyle({
    required this.background,
    required this.textColor,
    required this.borderColor,
  });
}
