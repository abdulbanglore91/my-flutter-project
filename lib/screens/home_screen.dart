import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../data/sample_programs.dart';
import '../data/timetable_data.dart';
import '../models/day_schedule.dart';
import '../components/navigation/floating_nav.dart';
import '../components/timetable/contextual_header.dart';
import '../components/timetable/day_carousel.dart';
import '../components/timetable/free_slots_screen.dart';
import '../components/timetable/program_selection_modal.dart';

// =============================================================================
// HomeScreen
// Root screen of UniSchedule — the Dart/Flutter equivalent of page.tsx.
//
// State mirrors the React component exactly:
//   • [_schedule]         ↔ schedule state (weekSchedule)
//   • [_todayIndex]       ↔ todayIndex state
//   • [_currentDayIndex]  ↔ currentDayIndex state
//   • [_activeNav]        ↔ activeNav state
// =============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<DaySchedule> _schedule;
  late int _todayIndex;
  late int _currentDayIndex;
  NavItem _activeNav = NavItem.home;

  @override
  void initState() {
    super.initState();
    _schedule = List.from(weekSchedule);

    // Derive today's index — mirrors the useEffect in page.tsx.
    // DateTime.now().weekday: Mon=1 … Sun=7
    // Our schedule: Mon=0 … Sun=6
    final weekday = DateTime.now().weekday; // 1=Mon … 7=Sun
    final scheduleIndex = weekday - 1; // 0=Mon … 6=Sun
    _todayIndex = scheduleIndex.clamp(0, _schedule.length - 1);
    _currentDayIndex = _todayIndex;

    // Status bar: transparent background, light icons (matches dark theme)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  void _handleDayChange(int index) {
    setState(() => _currentDayIndex = index);
  }

  void _handleUpdateSchedule(int dayIndex, DaySchedule updated) {
    setState(() {
      final newSchedule = List<DaySchedule>.from(_schedule);
      newSchedule[dayIndex] = updated;
      _schedule = newSchedule;
    });
  }

  void _handleAddDay() {
    // Find the next weekday not already in the schedule.
    final existingDays =
        _schedule.map((s) => s.day.toLowerCase()).toSet();

    final nextDay = orderedDays.firstWhere(
      (d) => !existingDays.contains(d),
      orElse: () => '',
    );

    if (nextDay.isEmpty) return; // All 7 days already exist.

    final names = dayNames[nextDay]!;
    final newDay = DaySchedule(
      day: names['full']!,
      shortDay: names['short']!,
      date: 'Custom',
      classes: const [],
    );

    setState(() {
      _schedule = [..._schedule, newDay];
    });
  }

  Future<void> _openProgramModal() async {
    final selectedId = await showProgramSelectionModal(
      context,
      programs: samplePrograms,
    );
    if (selectedId != null) {
      // In a full implementation this would load the program's timetable.
      debugPrint('Selected program: $selectedId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final todaySchedule = _schedule[_todayIndex];
    final currentDay = _schedule[_currentDayIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Ambient background orbs ──────────────────────────────────────
          _AmbientBackground(),

          // ── Content ─────────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: _buildActiveScreen(todaySchedule, currentDay),
          ),

          // ── Floating Nav ─────────────────────────────────────────────────
          FloatingNav(
            activeItem: _activeNav,
            onNavigate: (item) => setState(() => _activeNav = item),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveScreen(DaySchedule todaySchedule, DaySchedule currentDay) {
    switch (_activeNav) {
      case NavItem.home:
        return Column(
          children: [
            ContextualHeader(
              todayClasses: todaySchedule.classes,
              currentDay: currentDay.day,
            ),
            Expanded(
              child: DayCarousel(
                schedule: _schedule,
                todayIndex: _todayIndex,
                onDayChange: _handleDayChange,
                onUpdateSchedule: _handleUpdateSchedule,
                onAddDay: _handleAddDay,
              ),
            ),
          ],
        );

      case NavItem.freeSlots:
        return FreeSlotsScreen(
          schedule: _schedule,
          todayIndex: _todayIndex,
        );

      case NavItem.profile:
        return _ProfileScreen(onUploadTap: _openProgramModal);
    }
  }
}

// =============================================================================
// _ProfileScreen (private)
// Simple profile tab — mirrors the profile JSX block in page.tsx.
// =============================================================================

class _ProfileScreen extends StatelessWidget {
  final VoidCallback onUploadTap;

  const _ProfileScreen({required this.onUploadTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar placeholder
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.muted,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'P',
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Manage your timetable',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.mutedForeground,
              ),
            ),

            const SizedBox(height: AppSpacing.xl2),

            // Upload Timetable PDF button — cyan pill with glow
            GestureDetector(
              onTap: onUploadTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl2,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  borderRadius: BorderRadius.circular(AppRadius.xl2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4D66FCF1),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.upload_rounded,
                      size: 20,
                      color: AppColors.background,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Upload Timetable PDF',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// _AmbientBackground (private)
// The two soft radial glow orbs fixed behind all content — mirrors the
// fixed div with two blurred circles in the React source.
// =============================================================================

class _AmbientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Top-right orb — bg-[#66FCF1]/5 w-[600px] blur-[120px]
            Positioned(
              top: -size.height * 0.25,
              right: -size.width * 0.25,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Bottom-left orb — bg-[#7B2CBF]/5 w-[500px] blur-[100px]
            Positioned(
              bottom: -size.height * 0.25,
              left: -size.width * 0.25,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.purple.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
