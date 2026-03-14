import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../models/class_session.dart';
import '../shared/type_badge.dart';

// =============================================================================
// NewClassForm
// Inline form to add a new class to a day — mirrors the NewClassForm component
// inside day-flashcard.tsx. Uses Flutter's showTimePicker for the time fields.
// =============================================================================

class NewClassForm extends StatefulWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const NewClassForm({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<NewClassForm> createState() => _NewClassFormState();
}

// ─── Mutable form state exposed to the parent ─────────────────────────────────

class _NewClassFormController {
  String subject = '';
  String teacher = '';
  String room = '';
  ClassType type = ClassType.lecture;
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 30);

  bool get isValid => subject.trim().isNotEmpty;

  String get startTimeString =>
      '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

  String get endTimeString =>
      '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
}

// ─── Widget ───────────────────────────────────────────────────────────────────

class _NewClassFormState extends State<NewClassForm> {
  final _controller = _NewClassFormController();
  final _subjectController = TextEditingController();
  final _teacherController = TextEditingController();
  final _roomController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context, {required bool isStart}) async {
    final initial = isStart ? _controller.startTime : _controller.endTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _controller.startTime = picked;
        } else {
          _controller.endTime = picked;
        }
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // pl-8 pb-6 — left padding for timeline, bottom spacing
      padding: const EdgeInsets.only(
        left: AppSpacing.xl3,
        bottom: AppSpacing.xl2,
      ),
      child: Stack(
        children: [
          // ── Timeline connector ─────────────────────────────────────────────
          Positioned(
            left: -AppSpacing.xl3 + 7,
            top: 8,
            bottom: 0,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.cyan.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Timeline dot (pulsing) ─────────────────────────────────────────
          Positioned(
            left: -AppSpacing.xl3,
            top: 8,
            child: _PulsingTimelineDot(),
          ),

          // ── Form Card ─────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: AppDecorations.glassCardHighlighted(
              borderColor: AppColors.cyan,
              opacity: 0.6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Time Row ────────────────────────────────────────────────
                Row(
                  children: [
                    _TimeChip(
                      label: _formatTimeOfDay(_controller.startTime),
                      onTap: () => _pickTime(context, isStart: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm),
                      child: Text(
                        '—',
                        style: GoogleFonts.inter(
                            color: AppColors.mutedForeground),
                      ),
                    ),
                    _TimeChip(
                      label: _formatTimeOfDay(_controller.endTime),
                      onTap: () => _pickTime(context, isStart: false),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Subject ─────────────────────────────────────────────────
                TextField(
                  controller: _subjectController,
                  autofocus: true,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Subject Name',
                  ),
                  onChanged: (v) => setState(() => _controller.subject = v),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Teacher & Room Row ───────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _teacherController,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.mutedForeground,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Teacher Name',
                        ),
                        onChanged: (v) =>
                            setState(() => _controller.teacher = v),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: AppColors.cyan.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _roomController,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.mutedForeground,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Room',
                            ),
                            onChanged: (v) =>
                                setState(() => _controller.room = v),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Type Selector ────────────────────────────────────────────
                Row(
                  children: ClassType.values
                      .map((type) => Padding(
                            padding:
                                const EdgeInsets.only(right: AppSpacing.sm),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _controller.type = type),
                              child: TypeBadge(
                                type: type,
                                isSelected: _controller.type == type,
                              ),
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Divider ──────────────────────────────────────────────────
                Container(
                  height: 1,
                  color: AppColors.border,
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Action Buttons ───────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel
                    GestureDetector(
                      onTap: widget.onCancel,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.close_rounded,
                                size: 16,
                                color: AppColors.mutedForeground),
                            const SizedBox(width: 4),
                            Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSpacing.sm),

                    // Add Class — disabled when subject is empty
                    GestureDetector(
                      onTap: _controller.isValid ? widget.onSave : null,
                      child: Opacity(
                        opacity: _controller.isValid ? 1.0 : 0.5,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cyan,
                            borderRadius:
                                BorderRadius.circular(AppRadius.full),
                            boxShadow: _controller.isValid
                                ? AppShadows.cyanGlow
                                : [],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_rounded,
                                  size: 16,
                                  color: AppColors.background),
                              const SizedBox(width: 4),
                              Text(
                                'Add Class',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.background,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Exposes the current form state — called by the parent to build a session.
  _NewClassFormController get formData => _controller;
}

// ─── Time Chip ────────────────────────────────────────────────────────────────

class _TimeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TimeChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.cyan.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.cyan,
          ),
        ),
      ),
    );
  }
}

// ─── Pulsing Timeline Dot ─────────────────────────────────────────────────────

class _PulsingTimelineDot extends StatefulWidget {
  @override
  State<_PulsingTimelineDot> createState() => _PulsingTimelineDotState();
}

class _PulsingTimelineDotState extends State<_PulsingTimelineDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.cyan,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cyan, width: 2),
            boxShadow: AppShadows.cyanGlow,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// NewClassFormWrapper
// Stateful wrapper used by DayFlashcard to extract the form data on save.
// =============================================================================

class NewClassFormWrapper extends StatefulWidget {
  /// Called with the new [ClassSession] when the user taps "Add Class".
  final void Function(ClassSession session) onSaved;
  final VoidCallback onCancelled;

  const NewClassFormWrapper({
    super.key,
    required this.onSaved,
    required this.onCancelled,
  });

  @override
  State<NewClassFormWrapper> createState() => _NewClassFormWrapperState();
}

class _NewClassFormWrapperState extends State<NewClassFormWrapper> {
  final GlobalKey<_NewClassFormState> _formKey =
      GlobalKey<_NewClassFormState>();

  @override
  Widget build(BuildContext context) {
    return NewClassForm(
      key: _formKey,
      onSave: _handleSave,
      onCancel: widget.onCancelled,
    );
  }

  void _handleSave() {
    final state = _formKey.currentState;
    if (state == null) return;
    final data = state.formData;
    if (!data.isValid) return;

    final session = ClassSession(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      subject: data.subject.trim(),
      teacher: data.teacher.trim(),
      room: data.room.trim(),
      startTime: data.startTimeString,
      endTime: data.endTimeString,
      type: data.type,
    );
    widget.onSaved(session);
  }
}
