import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';

// =============================================================================
// AddClassButton
// Dashed-border "Add Makeup Class" button — mirrors add-class-button.tsx.
// =============================================================================

class AddClassButton extends StatefulWidget {
  final VoidCallback onTap;

  const AddClassButton({super.key, required this.onTap});

  @override
  State<AddClassButton> createState() => _AddClassButtonState();
}

class _AddClassButtonState extends State<AddClassButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(top: AppSpacing.lg),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.xl2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          border: Border.all(
            color: _isHovered
                ? AppColors.cyan.withValues(alpha: 0.5)
                : AppColors.cyan.withValues(alpha: 0.3),
            width: 1.5,
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.cyan.withValues(alpha: _isHovered ? 0.1 : 0.05),
              AppColors.purple.withValues(alpha: _isHovered ? 0.1 : 0.05),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Circular plus icon ─────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: _isHovered ? 0.3 : 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.cyan.withValues(alpha: _isHovered ? 0.6 : 0.4),
                ),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 18,
                color: AppColors.cyan,
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Text(
              'Add Makeup Class',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isHovered
                    ? AppColors.cyan
                    : AppColors.cyan.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
