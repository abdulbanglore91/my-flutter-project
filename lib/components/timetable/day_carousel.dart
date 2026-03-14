import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../models/day_schedule.dart';
import 'add_day_card.dart';
import 'day_flashcard.dart';

// =============================================================================
// DayCarousel
// Horizontally scrolling card carousel with page snapping — mirrors day-carousel.tsx.
//
// Implementation notes:
//   • Uses PageView with a fractional viewport (0.85) to show card peek effect.
//   • The focused-index drives the dot-indicator UI and fires [onDayChange].
//   • The last "page" is the AddDayCard — mirrors the extra card at carousel end.
// =============================================================================

class DayCarousel extends StatefulWidget {
  final List<DaySchedule> schedule;
  final int todayIndex;
  final ValueChanged<int> onDayChange;
  final void Function(int dayIndex, DaySchedule updated) onUpdateSchedule;
  final VoidCallback onAddDay;

  const DayCarousel({
    super.key,
    required this.schedule,
    required this.todayIndex,
    required this.onDayChange,
    required this.onUpdateSchedule,
    required this.onAddDay,
  });

  @override
  State<DayCarousel> createState() => _DayCarouselState();
}

class _DayCarouselState extends State<DayCarousel> {
  late PageController _pageController;
  late int _focusedIndex;

  @override
  void initState() {
    super.initState();
    _focusedIndex = widget.todayIndex;
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: widget.todayIndex,
    );
  }

  @override
  void didUpdateWidget(DayCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.todayIndex != widget.todayIndex) {
      _pageController.animateToPage(
        widget.todayIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
      setState(() => _focusedIndex = widget.todayIndex);
    }
  }

  void _onPageChanged(int index) {
    setState(() => _focusedIndex = index);
    if (index < widget.schedule.length) {
      widget.onDayChange(index);
    }
  }

  void _jumpToIndex(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Total pages = schedule days + 1 "Add Day" card
  int get _pageCount => widget.schedule.length + 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Card Carousel ────────────────────────────────────────────────────
        SizedBox(
          // Give the carousel enough height for the tallest card (65vh + padding)
          height: MediaQuery.of(context).size.height * 0.68,
          child: Stack(
            children: [
              // Fade-out gradient on left edge — mirrors the React gradient divs
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 48,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.background,
                          AppColors.background.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Fade-out gradient on right edge
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 48,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          AppColors.background,
                          AppColors.background.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                padEnds: true,
                itemCount: _pageCount,
                itemBuilder: (context, index) {
                  // The last page is the AddDayCard
                  if (index == widget.schedule.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm),
                      child: AddDayCard(onAdd: widget.onAddDay),
                    );
                  }

                  final day = widget.schedule[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: AppSpacing.lg),
                    child: DayFlashcard(
                      schedule: day,
                      isToday: index == widget.todayIndex,
                      isFocused: index == _focusedIndex,
                      onUpdateSchedule: (updated) =>
                          widget.onUpdateSchedule(index, updated),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // ── Dot indicators ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(widget.schedule.length, (i) {
                final isFocused = i == _focusedIndex;
                final isToday = i == widget.todayIndex;
                return GestureDetector(
                  onTap: () => _jumpToIndex(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs),
                    width: isFocused ? 24.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: isFocused
                          ? AppColors.cyan
                          : isToday
                              ? AppColors.cyan.withValues(alpha: 0.5)
                              : AppColors.mutedForeground
                                  .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                );
              }),

              // Dot for the AddDayCard
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                width: _focusedIndex == widget.schedule.length ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _focusedIndex == widget.schedule.length
                      ? AppColors.cyan.withValues(alpha: 0.6)
                      : AppColors.mutedForeground.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
