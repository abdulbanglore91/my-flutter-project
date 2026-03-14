import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../models/class_session.dart';
import '../../models/day_schedule.dart';
import 'add_class_button.dart';
import 'class_node.dart';
import 'new_class_form.dart';

// =============================================================================
// DayFlashcard
// Full-height scrollable card for a single day — mirrors day-flashcard.tsx.
//
// Layout:
//   • Day header (name + date + optional "Today" badge)
//   • Scrollable class timeline or empty-state
//   • Optional inline "add class" form
//   • Footer class count
// =============================================================================

class DayFlashcard extends StatefulWidget {
  final DaySchedule schedule;
  final bool isToday;

  /// When false the card is dimmed and slightly scaled down — mirrors isFocused.
  final bool isFocused;

  final void Function(DaySchedule updated)? onUpdateSchedule;

  const DayFlashcard({
    super.key,
    required this.schedule,
    required this.isToday,
    required this.isFocused,
    this.onUpdateSchedule,
  });

  @override
  State<DayFlashcard> createState() => _DayFlashcardState();
}

class _DayFlashcardState extends State<DayFlashcard> {
  bool _isAddingClass = false;

  // Key into the NewClassFormWrapper so we can trigger save programmatically.
  final _newClassKey = GlobalKey<_NewClassFormWrapperState>();

  void _handleAddClass() => setState(() => _isAddingClass = true);

  void _handleSaveNewClass(ClassSession session) {
    final updated = widget.schedule.copyWith(
      classes: [...widget.schedule.classes, session]
        ..sort((a, b) => a.startTime.compareTo(b.startTime)),
    );
    widget.onUpdateSchedule?.call(updated);
    setState(() => _isAddingClass = false);
  }

  void _handleCancelNewClass() => setState(() => _isAddingClass = false);

  void _handleUpdateClass(ClassSession updated) {
    final updatedClasses = widget.schedule.classes
        .map((c) => c.id == updated.id ? updated : c)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    widget.onUpdateSchedule?.call(
      widget.schedule.copyWith(classes: updatedClasses),
    );
  }

  void _handleDeleteClass(String id) {
    widget.onUpdateSchedule?.call(
      widget.schedule.copyWith(
        classes: widget.schedule.classes.where((c) => c.id != id).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The PageView in DayCarousel (viewportFraction: 0.85) already constrains
    // each page to 85 % of the viewport width and the full SizedBox height.
    // We therefore let the card fill those tight constraints and avoid setting
    // an explicit width or minHeight — that would fight the PageView layout
    // and cause Expanded to receive an unbounded vertical axis.
    //
    // isFocused → opacity 1.0, unfocused → opacity 0.6 (mirrors scale-95/opacity-60).
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: widget.isFocused ? 1.0 : 0.6,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: AppDecorations.glassCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xl2),
            // Expanded fills the remaining bounded height given by PageView.
            Expanded(child: _buildBody()),
            if (widget.schedule.classes.isNotEmpty) _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.schedule.day,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: AppColors.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.schedule.date,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),

        // "Today" badge — mirrors the <span> with uppercase tracking
        if (widget.isToday)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm - 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: AppColors.cyan.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'TODAY',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.cyan,
              ),
            ),
          ),
      ],
    );
  }

  // ── Body ────────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    final hasClasses = widget.schedule.classes.isNotEmpty;

    if (!hasClasses && !_isAddingClass) {
      return _emptyState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...widget.schedule.classes.map(
            (session) => ClassNode(
              session: session,
              isToday: widget.isToday,
              onUpdate: _handleUpdateClass,
              onDelete: _handleDeleteClass,
            ),
          ),

          // Inline new-class form
          if (_isAddingClass)
            _NewClassFormWrapper(
              key: _newClassKey,
              onSaved: _handleSaveNewClass,
              onCancelled: _handleCancelNewClass,
            ),

          // Add class button (only shown when not adding)
          if (!_isAddingClass)
            AddClassButton(onTap: _handleAddClass),
        ],
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.muted,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.free_breakfast_rounded,
            size: 32,
            color: AppColors.cyan,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          'Day Off',
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: AppSpacing.sm),

        SizedBox(
          width: 200,
          child: Text(
            'No classes scheduled. Take some time to rest or catch up on assignments.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.xl2),

        AddClassButton(onTap: _handleAddClass),
      ],
    );
  }

  // ── Footer ──────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    final count = widget.schedule.classes.length;
    final plural = count != 1 ? 'es' : '';

    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        Container(height: 1, color: AppColors.border),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Text(
            '$count class$plural scheduled',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// _NewClassFormWrapper (private)
// Bridges the DayFlashcard state and the NewClassFormWrapper widget.
// Exposes a [GlobalKey] so the parent can read the form data on save.
// =============================================================================

class _NewClassFormWrapper extends StatefulWidget {
  final void Function(ClassSession session) onSaved;
  final VoidCallback onCancelled;

  const _NewClassFormWrapper({
    super.key,
    required this.onSaved,
    required this.onCancelled,
  });

  @override
  State<_NewClassFormWrapper> createState() => _NewClassFormWrapperState();
}

class _NewClassFormWrapperState extends State<_NewClassFormWrapper> {
  @override
  Widget build(BuildContext context) {
    return NewClassFormWrapper(
      onSaved: widget.onSaved,
      onCancelled: widget.onCancelled,
    );
  }
}
