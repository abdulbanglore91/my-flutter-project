import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';

// =============================================================================
// FloatingNav
// Bottom floating navigation bar — mirrors floating-nav.tsx.
// Displays Home, Free Slots, and Profile tabs with an animated label reveal
// on the active tab (width: auto / 0 transition from the React source).
// =============================================================================

/// The navigation destination identifiers — mirrors the `NavItem` type alias.
enum NavItem { home, freeSlots, profile }

class FloatingNav extends StatelessWidget {
  final NavItem activeItem;
  final ValueChanged<NavItem> onNavigate;

  const FloatingNav({
    super.key,
    required this.activeItem,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppSpacing.xl2,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: AppDecorations.floatingNav,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NavButton(
                item: NavItem.home,
                icon: Icons.home_rounded,
                label: 'Home',
                activeItem: activeItem,
                onTap: onNavigate,
              ),
              _NavButton(
                item: NavItem.freeSlots,
                icon: Icons.access_time_rounded,
                label: 'Free Slots',
                activeItem: activeItem,
                onTap: onNavigate,
              ),
              _NavButton(
                item: NavItem.profile,
                icon: Icons.person_rounded,
                label: 'Profile',
                activeItem: activeItem,
                onTap: onNavigate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Private Nav Button ───────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final NavItem item;
  final IconData icon;
  final String label;
  final NavItem activeItem;
  final ValueChanged<NavItem> onTap;

  const _NavButton({
    required this.item,
    required this.icon,
    required this.label,
    required this.activeItem,
    required this.onTap,
  });

  bool get _isActive => activeItem == item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: _isActive
              ? AppColors.cyan.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: _isActive ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Icon(
                icon,
                size: 20,
                color: _isActive
                    ? AppColors.cyan
                    : AppColors.mutedForeground,
              ),
            ),
            // Animated label — mirrors the w-0/w-auto + opacity-0/opacity-100 CSS
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: _isActive
                  ? Row(
                      children: [
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.cyan,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
