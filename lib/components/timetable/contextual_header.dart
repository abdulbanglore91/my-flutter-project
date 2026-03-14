import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../data/timetable_data.dart';
import '../../models/class_session.dart';
import '../shared/pulsing_dot.dart';

// =============================================================================
// ContextualHeader
// Live time display, greeting, and class-count message — mirrors contextual-header.tsx.
// Updates every second via a Timer.periodic (same as setInterval in the React source).
// =============================================================================

class ContextualHeader extends StatefulWidget {
  /// Today's list of class sessions — used to compute remaining classes.
  final List<ClassSession> todayClasses;

  /// Full name of the currently viewed day, e.g. "Monday".
  final String currentDay;

  const ContextualHeader({
    super.key,
    required this.todayClasses,
    required this.currentDay,
  });

  @override
  State<ContextualHeader> createState() => _ContextualHeaderState();
}

class _ContextualHeaderState extends State<ContextualHeader> {
  late String _currentTime;
  late String _greeting;
  late int _remainingClasses;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Tick every second — same as setInterval(updateTime, 1000) in the React source.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void didUpdateWidget(ContextualHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todayClasses != widget.todayClasses) {
      _updateTime();
    }
  }

  void _updateTime() {
    if (!mounted) return;
    final now = DateTime.now();
    setState(() {
      // Format: "9:05 AM" — mirrors toLocaleTimeString with hour12: true
      final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final minute = now.minute.toString().padLeft(2, '0');
      final period = now.hour >= 12 ? 'PM' : 'AM';
      _currentTime = '$hour:$minute $period';
      _greeting = getGreeting();
      _remainingClasses =
          getRemainingClasses(widget.todayClasses, getCurrentTimeInMinutes());
    });
  }

  String get _message {
    if (widget.todayClasses.isEmpty) {
      return 'No classes today. Enjoy your day off!';
    }
    if (_remainingClasses == 0) {
      return 'All classes done for today!';
    }
    final plural = _remainingClasses != 1 ? 'es' : '';
    return 'You have $_remainingClasses class$plural left today.';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // px-6 pt-14 pb-6
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl2,
        AppSpacing.xl6,
        AppSpacing.xl2,
        AppSpacing.xl2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Time Row ──────────────────────────────────────────────────────
          Row(
            children: [
              const PulsingDot(size: 8),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _currentTime,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.cyan,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '• ${widget.currentDay}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Greeting ──────────────────────────────────────────────────────
          Text(
            _greeting,
            style: Theme.of(context).textTheme.displaySmall,
          ),

          const SizedBox(height: AppSpacing.xs),

          // ── Context Message ───────────────────────────────────────────────
          Text(
            _message,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.mutedForeground,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
