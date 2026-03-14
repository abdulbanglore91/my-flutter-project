// =============================================================================
// ClassSession Model
// Dart equivalent of the TypeScript ClassSession interface in timetable-data.ts
// =============================================================================

/// The type of a university class session.
enum ClassType {
  lecture,
  practical,
  combined;

  /// Display label — uppercase, matches the React badge text.
  String get label => name.toUpperCase();

  /// Parse from a raw string, defaulting to [ClassType.lecture].
  static ClassType fromString(String? value) {
    return ClassType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ClassType.lecture,
    );
  }
}

/// A single university class session.
class ClassSession {
  final String id;
  final String subject;
  final String teacher;
  final String room;

  /// 24-hour "HH:mm" formatted start time, e.g. "09:00".
  final String startTime;

  /// 24-hour "HH:mm" formatted end time, e.g. "10:30".
  final String endTime;

  final ClassType type;

  const ClassSession({
    required this.id,
    required this.subject,
    required this.teacher,
    required this.room,
    required this.startTime,
    required this.endTime,
    this.type = ClassType.lecture,
  });

  ClassSession copyWith({
    String? id,
    String? subject,
    String? teacher,
    String? room,
    String? startTime,
    String? endTime,
    ClassType? type,
  }) {
    return ClassSession(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      room: room ?? this.room,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassSession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
