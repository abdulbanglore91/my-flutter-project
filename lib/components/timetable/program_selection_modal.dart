import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app_theme.dart';
import '../../models/program.dart';

// =============================================================================
// ProgramSelectionModal
// Bottom-sheet modal to select a university program — mirrors program-selection-modal.tsx.
//
// Use [showProgramSelectionModal] to display it imperatively, matching the
// React pattern of `isOpen` controlled from the parent.
// =============================================================================

/// Displays the [ProgramSelectionModal] as a modal bottom sheet.
/// Returns the selected [Program] id, or null if dismissed.
Future<String?> showProgramSelectionModal(
  BuildContext context, {
  required List<Program> programs,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (_) => ProgramSelectionModal(programs: programs),
  );
}

// =============================================================================
// ProgramSelectionModal Widget
// =============================================================================

class ProgramSelectionModal extends StatefulWidget {
  final List<Program> programs;

  const ProgramSelectionModal({super.key, required this.programs});

  @override
  State<ProgramSelectionModal> createState() => _ProgramSelectionModalState();
}

class _ProgramSelectionModalState extends State<ProgramSelectionModal> {
  String? _selectedId;

  void _handleSave() {
    if (_selectedId != null) {
      Navigator.of(context).pop(_selectedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // The backdrop blur is applied at the route level via barrierColor.
    // The modal itself mirrors the rgba(26,29,36,0.85) + blur(24px) style.
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
      child: Padding(
        // Ensure the modal clears the keyboard
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: const Color(0xD91A1D24), // rgba(26,29,36,0.85)
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl2 + 4),
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x80000000),
                blurRadius: 50,
                offset: Offset(0, -25),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl2 + 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Container(height: 1, color: AppColors.border),
                Flexible(child: _buildProgramList()),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl2,
        AppSpacing.xl2,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.description_rounded,
              size: 20,
              color: AppColors.cyan,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Your Program',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  'Only 1 program can be saved',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),

          // Close button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: AppColors.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Program List ─────────────────────────────────────────────────────────────

  Widget _buildProgramList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl2,
        vertical: AppSpacing.lg,
      ),
      itemCount: widget.programs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final program = widget.programs[i];
        final isSelected = _selectedId == program.id;

        return GestureDetector(
          onTap: () => setState(() => _selectedId = program.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.cyan.withValues(alpha: 0.1)
                  : AppColors.muted,
              borderRadius: BorderRadius.circular(AppRadius.xl2),
              border: Border.all(
                color: isSelected
                    ? AppColors.cyan.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.cyan.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(top: 2),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cyan : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColors.mutedForeground,
                            width: 2,
                          ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.5),
                              blurRadius: 12,
                            ),
                          ]
                        : [],
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: AppColors.background,
                        )
                      : null,
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Program name
                      Text(
                        program.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.cyan
                              : AppColors.foreground,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xs),

                      // Subject list — mirrors the subjects.slice(0,4) map
                      Text.rich(
                        TextSpan(
                          children: _buildSubjectSpans(program.subjects),
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.mutedForeground,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<InlineSpan> _buildSubjectSpans(List<String> subjects) {
    final shown = subjects.take(4).toList();
    final spans = <InlineSpan>[];
    for (int i = 0; i < shown.length; i++) {
      if (i > 0) {
        spans.add(TextSpan(
          text: ' • ',
          style: TextStyle(
            color: AppColors.mutedForeground.withValues(alpha: 0.5),
          ),
        ));
      }
      spans.add(TextSpan(text: shown[i]));
    }
    return spans;
  }

  // ── Footer ──────────────────────────────────────────────────────────────────

  Widget _buildFooter() {
    final isEnabled = _selectedId != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl2,
        AppSpacing.lg,
        AppSpacing.xl2,
        AppSpacing.xl2,
      ),
      child: GestureDetector(
        onTap: isEnabled ? _handleSave : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: isEnabled ? AppColors.cyan : AppColors.muted,
            borderRadius: BorderRadius.circular(AppRadius.xl2),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Gloss overlay — mirrors the linear-gradient(180deg,...) shine
              if (isEnabled)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.xl2),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),

              Text(
                'Save Timetable',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isEnabled
                      ? AppColors.background
                      : AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
