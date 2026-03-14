// =============================================================================
// FreeSlot Model
// Dart equivalent of the TypeScript FreeSlot interface in timetable-data.ts
// =============================================================================

/// A contiguous time window where at least one campus room is available.
class FreeSlot {
  /// 24-hour "HH:mm" start time.
  final String startTime;

  /// 24-hour "HH:mm" end time.
  final String endTime;

  /// Names of rooms that are free during this window.
  final List<String> rooms;

  const FreeSlot({
    required this.startTime,
    required this.endTime,
    required this.rooms,
  });
}
