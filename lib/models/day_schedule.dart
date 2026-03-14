import 'class_session.dart';

// =============================================================================
// DaySchedule Model
// Dart equivalent of the TypeScript DaySchedule interface in timetable-data.ts
// =============================================================================

/// The schedule for a single day of the week.
class DaySchedule {
  /// Full day name, e.g. "Monday".
  final String day;

  /// Abbreviated day name, e.g. "Mon".
  final String shortDay;

  /// Human-readable date string, e.g. "Mar 17".
  final String date;

  /// Ordered list of class sessions for this day.
  final List<ClassSession> classes;

  const DaySchedule({
    required this.day,
    required this.shortDay,
    required this.date,
    required this.classes,
  });

  DaySchedule copyWith({
    String? day,
    String? shortDay,
    String? date,
    List<ClassSession>? classes,
  }) {
    return DaySchedule(
      day: day ?? this.day,
      shortDay: shortDay ?? this.shortDay,
      date: date ?? this.date,
      classes: classes ?? this.classes,
    );
  }
}
