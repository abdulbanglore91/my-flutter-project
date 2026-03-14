import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../data/timetable_data.dart';
import '../../models/class_session.dart';
import '../shared/pulsing_dot.dart';
import '../shared/type_badge.dart';

// =============================================================================
// ClassNode
// A single class entry in the timeline — mirrors class-node.tsx.
//
// Features:
//   • Live status updates every 30 seconds when [isToday] is true
//   • Tap to enter edit mode (same UX as the React version)
//   • Inline edit form with time, subject, teacher, room and type fields
//   • Delete button with confirmation
// =============================================================================

class ClassNode extends StatefulWidget {
  final ClassSession session;

  /// When true, class status is derived from the current time.
  final bool isToday;

  final void Function(ClassSession updated)? onUpdate;
  final void Function(String id)? onDelete;

  const ClassNode({
    super.key,
    required this.session,
    required this.isToday,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<ClassNode> createState() => _ClassNodeState();
}

class _ClassNodeState extends State<ClassNode> {
  ClassStatus _status = ClassStatus.upcoming;
  bool _isEditing = false;
  Timer? _statusTimer;

  // Edit-mode controllers
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TextEditingController _subjectCtrl;
  late TextEditingController _teacherCtrl;
  late TextEditingController _roomCtrl;
  late ClassType _selectedType;

  @override
  void initState() {
    super.initState();
    _initEditState();
    _updateStatus();
    if (widget.isToday) {
      // Mirror: setInterval(updateStatus, 30000)
      _statusTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => _updateStatus(),
      );
    }
  }

  void _initEditState() {
    final s = widget.session;
    _subjectCtrl = TextEditingController(text: s.subject);
    _teacherCtrl = TextEditingController(text: s.teacher);
    _roomCtrl = TextEditingController(text: s.room);
    _selectedType = s.type;
    _startTime = _parseTime(s.startTime);
    _endTime = _parseTime(s.endTime);
  }

  TimeOfDay _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _timeOfDayToString(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String _formatTimeOfDay(TimeOfDay t) {
    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _updateStatus() {
    if (!mounted) return;
    setState(() {
      if (!widget.isToday) {
        _status = ClassStatus.upcoming;
      } else {
        _status = getClassStatus(
          widget.session.startTime,
          widget.session.endTime,
          getCurrentTimeInMinutes(),
        );
      }
    });
  }

  Future<void> _pickTime(BuildContext context, {required bool isStart}) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _handleSave() {
    widget.onUpdate?.call(widget.session.copyWith(
      subject: _subjectCtrl.text.trim(),
      teacher: _teacherCtrl.text.trim(),
      room: _roomCtrl.text.trim(),
      type: _selectedType,
      startTime: _timeOfDayToString(_startTime),
      endTime: _timeOfDayToString(_endTime),
    ));
    setState(() => _isEditing = false);
  }

  void _handleCancel() {
    // Reset edit state to original session values
    setState(() {
      _subjectCtrl.text = widget.session.subject;
      _teacherCtrl.text = widget.session.teacher;
      _roomCtrl.text = widget.session.room;
      _selectedType = widget.session.type;
      _startTime = _parseTime(widget.session.startTime);
      _endTime = _parseTime(widget.session.endTime);
      _isEditing = false;
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _subjectCtrl.dispose();
    _teacherCtrl.dispose();
    _roomCtrl.dispose();
    super.dispose();
  }

  // ── Dot colour logic ────────────────────────────────────────────────────────

  Color get _dotColor {
    if (widget.isToday && _status == ClassStatus.active) return AppColors.cyan;
    if (widget.isToday && _status == ClassStatus.passed) return AppColors.muted;
    return const Color(0xFF1a1d24);
  }

  Color get _dotBorderColor {
    if (widget.isToday && _status == ClassStatus.active) return AppColors.cyan;
    if (widget.isToday && _status == ClassStatus.passed) return AppColors.border;
    return AppColors.cyan.withValues(alpha: 0.5);
  }

  // ── Card opacity (passed classes fade) ─────────────────────────────────────

  double get _cardOpacity {
    if (widget.isToday && _status == ClassStatus.passed) return 0.5;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _cardOpacity,
      child: Padding(
        // pl-8 pb-6 — left space for the timeline column
        padding: const EdgeInsets.only(
          left: AppSpacing.xl3,
          bottom: AppSpacing.xl2,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Timeline vertical connector ──────────────────────────────────
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

            // ── Timeline dot ─────────────────────────────────────────────────
            Positioned(
              left: -AppSpacing.xl3,
              top: 8,
              child: widget.isToday && _status == ClassStatus.active
                  ? const PulsingDot(size: 16)
                  : Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: _dotBorderColor, width: 2),
                      ),
                    ),
            ),

            // ── Class Card ───────────────────────────────────────────────────
            GestureDetector(
              onTap: _isEditing ? null : () => setState(() => _isEditing = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: _isEditing || (_status == ClassStatus.active && widget.isToday)
                    ? AppDecorations.glassCardHighlighted(
                        borderColor: AppColors.cyan,
                        opacity: _isEditing ? 0.6 : 0.4,
                      )
                    : AppDecorations.glassCard,
                child: _isEditing ? _editView(context) : _viewMode(),
              ),
            ),

            // ── Active gradient overlay ──────────────────────────────────────
            if (_status == ClassStatus.active && widget.isToday && !_isEditing)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.xl2),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.cyan.withValues(alpha: 0.05),
                          AppColors.purple.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── View Mode ───────────────────────────────────────────────────────────────

  Widget _viewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${formatTime(widget.session.startTime)} — ${formatTime(widget.session.endTime)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.cyan,
              ),
            ),
            TypeBadge(type: widget.session.type),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        // Subject
        Text(
          widget.session.subject,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: AppSpacing.sm),

        // Teacher & Room
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.session.teacher,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 14,
                  color: AppColors.cyan.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.session.room,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ── Edit Mode ───────────────────────────────────────────────────────────────

  Widget _editView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time row
        Row(
          children: [
            _TimeChip(
              label: _formatTimeOfDay(_startTime),
              onTap: () => _pickTime(context, isStart: true),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text('—',
                  style:
                      GoogleFonts.inter(color: AppColors.mutedForeground)),
            ),
            _TimeChip(
              label: _formatTimeOfDay(_endTime),
              onTap: () => _pickTime(context, isStart: false),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Subject
        TextField(
          controller: _subjectCtrl,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
          decoration: const InputDecoration(hintText: 'Subject Name'),
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Teacher & Room
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _teacherCtrl,
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.mutedForeground),
                decoration: const InputDecoration(hintText: 'Teacher Name'),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Row(
              children: [
                Icon(Icons.location_on_rounded,
                    size: 14,
                    color: AppColors.cyan.withValues(alpha: 0.7)),
                const SizedBox(width: AppSpacing.xs),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _roomCtrl,
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppColors.mutedForeground),
                    decoration: const InputDecoration(hintText: 'Room'),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Type selector
        Row(
          children: ClassType.values
              .map((type) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: TypeBadge(
                        type: type,
                        isSelected: _selectedType == type,
                      ),
                    ),
                  ))
              .toList(),
        ),

        const SizedBox(height: AppSpacing.md),

        Container(height: 1, color: AppColors.border),

        const SizedBox(height: AppSpacing.md),

        // Action row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Delete button
            GestureDetector(
              onTap: () => widget.onDelete?.call(widget.session.id),
              child: Row(
                children: [
                  const Icon(Icons.delete_outline_rounded,
                      size: 16, color: AppColors.danger),
                  const SizedBox(width: 4),
                  Text(
                    'Delete',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                // Cancel
                GestureDetector(
                  onTap: _handleCancel,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.close_rounded,
                            size: 16, color: AppColors.mutedForeground),
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

                // Save
                GestureDetector(
                  onTap: _handleSave,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cyan,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: AppShadows.cyanGlow,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_rounded,
                            size: 16, color: AppColors.background),
                        const SizedBox(width: 4),
                        Text(
                          'Save',
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
              ],
            ),
          ],
        ),
      ],
    );
  }
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
