import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// COLOR PALETTE
// Directly translated from the React/Tailwind source.
// Every hex value is taken verbatim from the original CSS.
// =============================================================================

abstract final class AppColors {
  // ── Backgrounds ────────────────────────────────────────────────────────────
  /// Main scaffold background: bg-[#0B0C10]
  static const Color background = Color(0xFF0B0C10);

  /// Glass card surface: rgba(255,255,255,0.10)
  static const Color glass = Color(0x1AFFFFFF);

  /// Glass card border: rgba(255,255,255,0.12)
  static const Color glassBorder = Color(0x1FFFFFFF);

  /// Elevated surface used for muted containers
  static const Color surface = Color(0xFF1A1D24);

  /// Muted fill — bg-[var(--muted)]
  static const Color muted = Color(0xFF1F2333);

  /// Subtle borders — border-[var(--border)]
  static const Color border = Color(0xFF2A2D3A);

  // ── Accent ─────────────────────────────────────────────────────────────────
  /// Primary cyan accent: #66FCF1
  static const Color cyan = Color(0xFF66FCF1);

  /// Cyan hover: #7FFFD4
  static const Color cyanHover = Color(0xFF7FFFD4);

  /// Secondary purple: #7B2CBF
  static const Color purple = Color(0xFF7B2CBF);

  /// Light purple for labels: #C77DFF
  static const Color purpleLight = Color(0xFFC77DFF);

  // ── Semantic ───────────────────────────────────────────────────────────────
  /// Danger / delete: #FF6B6B
  static const Color danger = Color(0xFFFF6B6B);

  // ── Text ───────────────────────────────────────────────────────────────────
  /// Primary text: text-foreground (~#E8E8E8)
  static const Color foreground = Color(0xFFE8E8E8);

  /// Subdued text: text-[var(--muted-foreground)]
  static const Color mutedForeground = Color(0xFF6B7280);

  // ── Ambient gradients (used for background orbs) ──────────────────────────
  /// Top-right orb: bg-[#66FCF1]/5
  static const Color ambientCyan = Color(0x0D66FCF1);

  /// Bottom-left orb: bg-[#7B2CBF]/5
  static const Color ambientPurple = Color(0x0D7B2CBF);

  // ── Class-type badge fills ─────────────────────────────────────────────────
  /// lecture type bg — bg-[var(--muted)]
  static const Color lectureBackground = Color(0xFF1F2333);

  /// practical type bg — bg-[#7B2CBF]/20
  static const Color practicalBackground = Color(0x337B2CBF);

  /// combined type bg — bg-[#66FCF1]/15
  static const Color combinedBackground = Color(0x2666FCF1);
}

// =============================================================================
// SPACING
// Mirrors Tailwind's spacing scale (1 unit = 4 px).
// =============================================================================

abstract final class AppSpacing {
  static const double xs = 4.0;   // 1
  static const double sm = 8.0;   // 2
  static const double md = 12.0;  // 3
  static const double lg = 16.0;  // 4
  static const double xl = 20.0;  // 5
  static const double xl2 = 24.0; // 6
  static const double xl3 = 32.0; // 8
  static const double xl4 = 40.0; // 10
  static const double xl5 = 48.0; // 12
  static const double xl6 = 56.0; // 14 — used for top padding (pt-14)
  static const double xl8 = 96.0; // 24 — bottom nav clearance (h-24)
}

// =============================================================================
// BORDER RADII
// =============================================================================

abstract final class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xl2 = 24.0; // rounded-3xl (approximately)
  static const double full = 999.0; // rounded-full
}

// =============================================================================
// BOX SHADOWS
// =============================================================================

abstract final class AppShadows {
  /// card-shadow equivalent
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Cyan glow — used on active elements: 0 0 20px rgba(102,252,241,0.3)
  static const List<BoxShadow> cyanGlow = [
    BoxShadow(
      color: Color(0x4D66FCF1),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  /// Floating nav shadow
  static const List<BoxShadow> floatingNav = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
  ];
}

// =============================================================================
// REUSABLE BOX DECORATIONS
// =============================================================================

abstract final class AppDecorations {
  /// Standard glass card — glass-card class from the React source.
  static BoxDecoration get glassCard => BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(color: AppColors.glassBorder, width: 1),
        boxShadow: AppShadows.card,
      );

  /// Active glass card with a coloured border (e.g., during edit).
  static BoxDecoration glassCardHighlighted({
    Color borderColor = AppColors.cyan,
    double opacity = 0.4,
  }) =>
      BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(
          color: borderColor.withValues(alpha: opacity),
          width: 1.5,
        ),
        boxShadow: AppShadows.card,
      );

  /// Floating navigation bar — glass-nav class.
  static BoxDecoration get floatingNav => BoxDecoration(
        color: const Color(0xE61A1D24),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.glassBorder, width: 1),
        boxShadow: AppShadows.floatingNav,
      );

  /// Dashed outline card — used by AddClassButton and AddDayCard.
  static BoxDecoration dashedOutline({
    Color color = AppColors.cyan,
    double opacity = 0.3,
    double radius = AppRadius.xl2,
  }) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        // Flutter doesn't natively support dashed borders; we simulate with
        // a solid semi-transparent border and gradient fill.
        border: Border.all(
          color: color.withValues(alpha: opacity),
          width: 1.5,
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.cyan.withValues(alpha: 0.05),
            AppColors.purple.withValues(alpha: 0.05),
          ],
        ),
      );
}

// =============================================================================
// THEME DATA
// =============================================================================

abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.cyan,
        secondary: AppColors.purple,
        surface: AppColors.surface,
        error: AppColors.danger,
        onPrimary: AppColors.background,
        onSecondary: AppColors.foreground,
        onSurface: AppColors.foreground,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      inputDecorationTheme: _inputDecorationTheme,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.interTextTheme(base).copyWith(
      // text-3xl font-semibold tracking-tight — main greeting
      displaySmall: GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
        letterSpacing: -0.5,
      ),
      // text-2xl font-bold — day card header
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
        letterSpacing: -0.4,
      ),
      // text-xl font-semibold — modal headers
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
      ),
      // text-lg font-semibold — class subject
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
        height: 1.2,
      ),
      // text-base font-medium — body
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.foreground,
      ),
      // text-base — regular body
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: AppColors.foreground,
        height: 1.6,
      ),
      // text-sm — muted body
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.mutedForeground,
      ),
      // text-xs — small labels
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.mutedForeground,
      ),
      // uppercase tracking-wider — type badges
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.mutedForeground,
      ),
    );
  }

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.cyan.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.mutedForeground.withValues(alpha: 0.5),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.only(bottom: 4),
      );
}
