import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';

// =============================================================================
// AddDayCard
// Full-height card with dashed outline to add a new schedule day.
// Mirrors add-day-card.tsx, preserving the scale/opacity hover effect.
// =============================================================================

class AddDayCard extends StatefulWidget {
  final VoidCallback onAdd;

  const AddDayCard({super.key, required this.onAdd});

  @override
  State<AddDayCard> createState() => _AddDayCardState();
}

class _AddDayCardState extends State<AddDayCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // w-[85vw] max-w-[380px]
    final cardWidth = (screenWidth * 0.85).clamp(0.0, 380.0);
    // min-h-[65vh]
    final cardHeight = MediaQuery.of(context).size.height * 0.65;

    return GestureDetector(
      onTap: widget.onAdd,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        width: cardWidth,
        height: cardHeight,
        // scale-95 opacity-60 default / scale-100 opacity-80 hover
        // We approximate with opacity since Flutter doesn't have layout-level scale snap
        child: Opacity(
          opacity: _isHovered ? 0.8 : 0.6,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl2 + 4),
              border: Border.all(
                color: _isHovered
                    ? AppColors.cyan.withValues(alpha: 0.4)
                    : AppColors.border,
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _isHovered
                      ? AppColors.cyan.withValues(alpha: 0.05)
                      : AppColors.glass,
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Calendar plus icon circle ──────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppColors.cyan.withValues(alpha: 0.1)
                        : AppColors.muted,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.cyan.withValues(alpha: 0.4)
                          : AppColors.border,
                    ),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    size: 40,
                    color: _isHovered
                        ? AppColors.cyan
                        : AppColors.mutedForeground,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl2),

                Text(
                  'Add Day',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _isHovered
                        ? AppColors.foreground
                        : AppColors.mutedForeground,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                SizedBox(
                  width: 200,
                  child: Text(
                    'Add a weekend or special schedule day',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.mutedForeground.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
