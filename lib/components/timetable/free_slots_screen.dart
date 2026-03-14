import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../data/timetable_data.dart';
import '../../models/day_schedule.dart';
import '../../models/free_slot.dart';
import '../shared/pulsing_dot.dart';

// =============================================================================
// FreeSlotsScreen
// Displays free campus rooms grouped by time slot — mirrors free-slots-screen.tsx.
//
// Features:
//   • Day-selector pill row to switch between days
//   • Timeline-style list of free-room windows
//   • Live/passed/upcoming status per slot when viewing today
//   • Auto-scroll to the current live slot on load
// =============================================================================

class FreeSlotsScreen extends StatefulWidget {
  final List<DaySchedule> schedule;
  final int todayIndex;

  const FreeSlotsScreen({
    super.key,
    required this.schedule,
    required this.todayIndex,
  });

  @override
  State<FreeSlotsScreen> createState() => _FreeSlotsScreenState();
}

class _FreeSlotsScreenState extends State<FreeSlotsScreen> {
  late int _selectedDayIndex;
  late int _currentMinutes;
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  // We record the scroll offset of the live slot after build completes.
  final Map<int, GlobalKey> _slotKeys = {};

  @override
  void initState() {
    super.initState();
    _selectedDayIndex = widget.todayIndex;
    _currentMinutes = getCurrentTimeInMinutes();

    // Update every 30 seconds — mirrors setInterval(updateTime, 30000)
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() => _currentMinutes = getCurrentTimeInMinutes());
      }
    });

    // Scroll to live slot after first frame — mirrors the 300 ms setTimeout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), _scrollToLive);
    });
  }

  void _scrollToLive() {
    final slots = calculateFreeSlots(widget.schedule, _selectedDayIndex);
    for (int i = 0; i < slots.length; i++) {
      final status = getSlotStatus(
          slots[i].startTime, slots[i].endTime, _currentMinutes);
      if (status == SlotStatus.live) {
        final key = _slotKeys[i];
        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(milliseconds: 400),
            alignment: 0.3,
            curve: Curves.easeOut,
          );
        }
        break;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isToday => _selectedDayIndex == widget.todayIndex;

  @override
  Widget build(BuildContext context) {
    final freeSlots = calculateFreeSlots(widget.schedule, _selectedDayIndex);
    // Pre-assign GlobalKeys for each slot
    for (int i = 0; i < freeSlots.length; i++) {
      _slotKeys.putIfAbsent(i, () => GlobalKey());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildDaySelector(),
        Expanded(child: _buildTimeline(freeSlots)),
      ],
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      // px-6 pt-14 pb-4
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl2,
        AppSpacing.xl6,
        AppSpacing.xl2,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 20,
                color: AppColors.cyan,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Free Rooms',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Find Empty Rooms',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Rooms available throughout the day',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  // ── Day Selector Pills ───────────────────────────────────────────────────────

  Widget _buildDaySelector() {
    return Padding(
      // px-6 pb-4
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl2,
        0,
        AppSpacing.xl2,
        AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.schedule.length, (i) {
            final day = widget.schedule[i];
            final isSelected = _selectedDayIndex == i;
            final dayIsToday = i == widget.todayIndex;

            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedDayIndex = i);
                  Future.delayed(
                    const Duration(milliseconds: 100),
                    _scrollToLive,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cyan
                        : dayIsToday
                            ? AppColors.cyan.withValues(alpha: 0.2)
                            : AppColors.muted,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: dayIsToday && !isSelected
                        ? Border.all(
                            color: AppColors.cyan.withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Text(
                        day.shortDay,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.background
                              : dayIsToday
                                  ? AppColors.cyan
                                  : AppColors.mutedForeground,
                        ),
                      ),
                      // Small dot for "today" pill when not selected
                      if (dayIsToday && !isSelected) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.cyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Timeline ────────────────────────────────────────────────────────────────

  Widget _buildTimeline(List<FreeSlot> freeSlots) {
    if (freeSlots.isEmpty) {
      return _emptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      // pb-28 — bottom padding so content clears the floating nav
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl2,
        0,
        AppSpacing.xl2,
        112,
      ),
      itemCount: freeSlots.length,
      itemBuilder: (context, index) {
        final slot = freeSlots[index];
        final status = _isToday
            ? getSlotStatus(slot.startTime, slot.endTime, _currentMinutes)
            : SlotStatus.upcoming;

        return _SlotCard(
          key: _slotKeys[index],
          slot: slot,
          status: status,
          isToday: _isToday,
        );
      },
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.muted,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_rounded,
              size: 32,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No free rooms available',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'All rooms are occupied today',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.mutedForeground.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _SlotCard (private)
// A single free-slot row in the timeline — one-to-one with the JSX in the
// FreeSlotsScreen map() call.
// =============================================================================

class _SlotCard extends StatelessWidget {
  final FreeSlot slot;
  final SlotStatus status;
  final bool isToday;

  const _SlotCard({
    super.key,
    required this.slot,
    required this.status,
    required this.isToday,
  });

  bool get _isLive => status == SlotStatus.live;
  bool get _isPassed => status == SlotStatus.passed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isPassed ? 0.4 : 1.0,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.xl + 4, // pl-10
          bottom: AppSpacing.lg,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Timeline dot ───────────────────────────────────────────────
            Positioned(
              left: -(AppSpacing.xl + 4),
              top: AppSpacing.lg,
              child: _buildDot(),
            ),

            // ── Time Card ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: _isLive
                  ? AppDecorations.glassCardHighlighted(
                      borderColor: AppColors.cyan,
                      opacity: 0.5,
                    )
                  : AppDecorations.glassCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            formatTime(slot.startTime),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isLive
                                  ? AppColors.cyan
                                  : AppColors.foreground,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm),
                            child: Text(
                              'to',
                              style: GoogleFonts.inter(
                                  color: AppColors.mutedForeground),
                            ),
                          ),
                          Text(
                            formatTime(slot.endTime),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isLive
                                  ? AppColors.cyan
                                  : AppColors.foreground,
                            ),
                          ),
                        ],
                      ),

                      // "Live" badge
                      if (_isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(AppRadius.full),
                            border: Border.all(
                              color: AppColors.cyan.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              PulsingDot(size: 6),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Live',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Duration
                  Text(
                    getDuration(slot.startTime, slot.endTime),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Room pills
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: slot.rooms
                        .map((room) => _RoomPill(
                              room: room,
                              isLive: _isLive,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    if (_isLive) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.cyan,
          shape: BoxShape.circle,
          boxShadow: AppShadows.cyanGlow,
        ),
        child: const Center(
          child: Icon(Icons.circle, size: 8, color: AppColors.background),
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: _isPassed ? AppColors.muted : AppColors.glass,
        shape: BoxShape.circle,
        border: Border.all(
          color: _isPassed ? AppColors.border : AppColors.glassBorder,
        ),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _isPassed
                ? AppColors.mutedForeground
                : AppColors.cyan.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ─── Room Pill ────────────────────────────────────────────────────────────────

class _RoomPill extends StatelessWidget {
  final String room;
  final bool isLive;

  const _RoomPill({required this.room, required this.isLive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm - 2,
      ),
      decoration: BoxDecoration(
        color: isLive
            ? AppColors.cyan.withValues(alpha: 0.15)
            : AppColors.muted,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: isLive ? AppColors.cyan.withValues(alpha: 0.3) : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 14,
            color: isLive ? AppColors.cyan : AppColors.mutedForeground,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            room,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isLive ? AppColors.cyan : AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
