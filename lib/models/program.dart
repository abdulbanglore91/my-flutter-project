// =============================================================================
// Program Model
// Dart equivalent of the TypeScript Program interface in program-selection-modal.tsx
// =============================================================================

/// A university degree program selectable from the profile screen.
class Program {
  final String id;

  /// Display name, e.g. "BSIT (5th Intake) Sem3".
  final String name;

  /// List of subject names associated with this program.
  final List<String> subjects;

  const Program({
    required this.id,
    required this.name,
    required this.subjects,
  });
}
