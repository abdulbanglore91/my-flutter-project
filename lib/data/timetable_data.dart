import '../models/class_session.dart';
import '../models/day_schedule.dart';
import '../models/free_slot.dart';

// =============================================================================
// TIMETABLE DATA & UTILITY FUNCTIONS
// A faithful Dart translation of lib/timetable-data.ts from the React source.
// Every function signature, data value, and algorithmic detail is preserved.
// =============================================================================

// ─── Campus Rooms ─────────────────────────────────────────────────────────────

/// All available rooms on campus — mirrors the `allRooms` export in timetable-data.ts.
const List<String> allRooms = [
  'LH-201',
  'LH-105',
  'LH-302',
  'LH-401',
  'CS-Lab 1',
  'CS-Lab 2',
  'CS-Lab 3',
  'MAB CR-162',
  'MAB CR-224',
  'NAB CR-101',
  'NAB CR-224',
];

// ─── Sample Weekly Schedule ────────────────────────────────────────────────────

/// The full sample week schedule — mirrors the `weekSchedule` export.
final List<DaySchedule> weekSchedule = [
  DaySchedule(
    day: 'Monday',
    shortDay: 'Mon',
    date: 'Mar 17',
    classes: [
      const ClassSession(
        id: 'mon-1',
        subject: 'Data Structures & Algorithms',
        teacher: 'Dr. Sarah Chen',
        room: 'LH-201',
        startTime: '09:00',
        endTime: '10:30',
        type: ClassType.lecture,
      ),
      const ClassSession(
        id: 'mon-2',
        subject: 'Machine Learning',
        teacher: 'Prof. James Mitchell',
        room: 'CS-Lab 3',
        startTime: '11:00',
        endTime: '12:30',
        type: ClassType.practical,
      ),
      const ClassSession(
        id: 'mon-3',
        subject: 'Database Systems',
        teacher: 'Dr. Emily Watson',
        room: 'LH-105',
        startTime: '14:00',
        endTime: '15:30',
        type: ClassType.combined,
      ),
    ],
  ),
  DaySchedule(
    day: 'Tuesday',
    shortDay: 'Tue',
    date: 'Mar 18',
    classes: [
      const ClassSession(
        id: 'tue-1',
        subject: 'Computer Networks',
        teacher: 'Dr. Michael Brown',
        room: 'LH-302',
        startTime: '08:30',
        endTime: '10:00',
        type: ClassType.lecture,
      ),
      const ClassSession(
        id: 'tue-2',
        subject: 'Software Engineering',
        teacher: 'Prof. Lisa Park',
        room: 'LH-201',
        startTime: '10:30',
        endTime: '12:00',
        type: ClassType.lecture,
      ),
      const ClassSession(
        id: 'tue-3',
        subject: 'Web Development Lab',
        teacher: 'Mr. David Kim',
        room: 'CS-Lab 1',
        startTime: '14:00',
        endTime: '16:00',
        type: ClassType.practical,
      ),
    ],
  ),
  DaySchedule(
    day: 'Wednesday',
    shortDay: 'Wed',
    date: 'Mar 19',
    classes: [
      const ClassSession(
        id: 'wed-1',
        subject: 'Operating Systems',
        teacher: 'Dr. Robert Taylor',
        room: 'LH-401',
        startTime: '09:00',
        endTime: '10:30',
        type: ClassType.lecture,
      ),
      const ClassSession(
        id: 'wed-2',
        subject: 'Artificial Intelligence',
        teacher: 'Prof. Anna Lee',
        room: 'LH-201',
        startTime: '11:00',
        endTime: '12:30',
        type: ClassType.combined,
      ),
      const ClassSession(
        id: 'wed-3',
        subject: 'Cloud Computing',
        teacher: 'Dr. Chris Anderson',
        room: 'CS-Lab 2',
        startTime: '15:00',
        endTime: '17:00',
        type: ClassType.practical,
      ),
    ],
  ),
  DaySchedule(
    day: 'Thursday',
    shortDay: 'Thu',
    date: 'Mar 20',
    classes: [
      const ClassSession(
        id: 'thu-1',
        subject: 'Data Structures & Algorithms',
        teacher: 'Dr. Sarah Chen',
        room: 'CS-Lab 3',
        startTime: '09:00',
        endTime: '11:00',
        type: ClassType.practical,
      ),
      const ClassSession(
        id: 'thu-2',
        subject: 'Computer Networks',
        teacher: 'Dr. Michael Brown',
        room: 'LH-302',
        startTime: '11:30',
        endTime: '13:00',
        type: ClassType.lecture,
      ),
      const ClassSession(
        id: 'thu-3',
        subject: 'Cybersecurity Fundamentals',
        teacher: 'Prof. Rachel Green',
        room: 'LH-105',
        startTime: '14:30',
        endTime: '16:00',
        type: ClassType.lecture,
      ),
    ],
  ),
  DaySchedule(
    day: 'Friday',
    shortDay: 'Fri',
    date: 'Mar 21',
    classes: [
      const ClassSession(
        id: 'fri-1',
        subject: 'Machine Learning',
        teacher: 'Prof. James Mitchell',
        room: 'LH-201',
        startTime: '10:00',
        endTime: '11:30',
        type: ClassType.lecture,
      ),
      const ClassSession(
        id: 'fri-2',
        subject: 'Database Systems Lab',
        teacher: 'Dr. Emily Watson',
        room: 'CS-Lab 1',
        startTime: '13:00',
        endTime: '15:00',
        type: ClassType.practical,
      ),
    ],
  ),
  DaySchedule(
    day: 'Saturday',
    shortDay: 'Sat',
    date: 'Mar 22',
    classes: [
      const ClassSession(
        id: 'sat-1',
        subject: 'Project Workshop',
        teacher: 'Prof. Lisa Park',
        room: 'CS-Lab 2',
        startTime: '10:00',
        endTime: '13:00',
        type: ClassType.practical,
      ),
    ],
  ),
  const DaySchedule(
    day: 'Sunday',
    shortDay: 'Sun',
    date: 'Mar 23',
    classes: [],
  ),
];

// ─── Day Name Lookup ──────────────────────────────────────────────────────────

/// Full and short names for each weekday key.
const Map<String, Map<String, String>> dayNames = {
  'monday': {'full': 'Monday', 'short': 'Mon'},
  'tuesday': {'full': 'Tuesday', 'short': 'Tue'},
  'wednesday': {'full': 'Wednesday', 'short': 'Wed'},
  'thursday': {'full': 'Thursday', 'short': 'Thu'},
  'friday': {'full': 'Friday', 'short': 'Fri'},
  'saturday': {'full': 'Saturday', 'short': 'Sat'},
  'sunday': {'full': 'Sunday', 'short': 'Sun'},
};

/// Ordered list of day keys — used when adding a new day.
const List<String> orderedDays = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

// ─── Time Utilities ────────────────────────────────────────────────────────────

/// Converts a "HH:mm" string to total minutes since midnight.
/// Mirrors `getTimeInMinutes` in timetable-data.ts.
int getTimeInMinutes(String time) {
  final parts = time.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  return hours * 60 + minutes;
}

/// Returns the current time as minutes since midnight.
/// Mirrors `getCurrentTimeInMinutes` in timetable-data.ts.
int getCurrentTimeInMinutes() {
  final now = DateTime.now();
  return now.hour * 60 + now.minute;
}

/// Converts minutes since midnight back to a "HH:mm" string.
/// Mirrors `minutesToTime` in timetable-data.ts.
String minutesToTime(int minutes) {
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
}

/// Formats a "HH:mm" 24-hour string into 12-hour AM/PM display.
/// Mirrors `formatTime` in timetable-data.ts.
String formatTime(String time) {
  final parts = time.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final period = hours >= 12 ? 'PM' : 'AM';
  final displayHours = hours % 12 == 0 ? 12 : hours % 12;
  return '$displayHours:${minutes.toString().padLeft(2, '0')} $period';
}

// ─── Class Status ─────────────────────────────────────────────────────────────

/// Possible states for a class relative to the current time.
enum ClassStatus { passed, active, upcoming }

/// Derives the [ClassStatus] of a session given the current time in minutes.
/// Mirrors `getClassStatus` in timetable-data.ts.
ClassStatus getClassStatus(
  String startTime,
  String endTime,
  int currentMinutes,
) {
  final start = getTimeInMinutes(startTime);
  final end = getTimeInMinutes(endTime);

  if (currentMinutes > end) return ClassStatus.passed;
  if (currentMinutes >= start && currentMinutes <= end) return ClassStatus.active;
  return ClassStatus.upcoming;
}

// ─── Free Slot Status ─────────────────────────────────────────────────────────

/// Possible states for a free-room slot relative to current time.
enum SlotStatus { passed, live, upcoming }

/// Derives the [SlotStatus] of a time window given the current time in minutes.
/// Mirrors `getSlotStatus` in timetable-data.ts.
SlotStatus getSlotStatus(
  String startTime,
  String endTime,
  int currentMinutes,
) {
  final start = getTimeInMinutes(startTime);
  final end = getTimeInMinutes(endTime);

  if (currentMinutes >= end) return SlotStatus.passed;
  if (currentMinutes >= start && currentMinutes < end) return SlotStatus.live;
  return SlotStatus.upcoming;
}

// ─── Greeting ─────────────────────────────────────────────────────────────────

/// Returns a time-of-day greeting string.
/// Mirrors `getGreeting` in timetable-data.ts.
String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

// ─── Remaining Classes ────────────────────────────────────────────────────────

/// Counts classes that haven't ended yet relative to [currentMinutes].
/// Mirrors `getRemainingClasses` in timetable-data.ts.
int getRemainingClasses(List<ClassSession> classes, int currentMinutes) {
  return classes
      .where((c) => getTimeInMinutes(c.endTime) > currentMinutes)
      .length;
}

// ─── Free Slot Calculation ────────────────────────────────────────────────────

/// Determines which rooms are occupied during a time window on a given day.
/// Mirrors `getOccupiedRooms` in timetable-data.ts.
List<String> getOccupiedRooms(
  List<DaySchedule> allSchedules,
  int dayIndex,
  int startMin,
  int endMin,
) {
  if (dayIndex < 0 || dayIndex >= allSchedules.length) return [];

  final daySchedule = allSchedules[dayIndex];
  final occupiedRooms = <String>[];

  for (final session in daySchedule.classes) {
    final sessionStart = getTimeInMinutes(session.startTime);
    final sessionEnd = getTimeInMinutes(session.endTime);

    // Ranges overlap when: startMin < sessionEnd && endMin > sessionStart
    if (startMin < sessionEnd && endMin > sessionStart) {
      occupiedRooms.add(session.room);
    }
  }

  return occupiedRooms;
}

/// Calculates all free room slots for a given day index.
/// Mirrors `calculateFreeSlots` in timetable-data.ts — algorithm is identical.
List<FreeSlot> calculateFreeSlots(
  List<DaySchedule> allSchedules,
  int dayIndex,
) {
  if (dayIndex < 0 || dayIndex >= allSchedules.length) return [];

  final daySchedule = allSchedules[dayIndex];

  // Collect all time boundaries from sessions, plus campus open/close times.
  final boundaries = <int>{
    8 * 60,   // 08:00 — campus opens
    18 * 60,  // 18:00 — campus closes
  };

  for (final session in daySchedule.classes) {
    boundaries.add(getTimeInMinutes(session.startTime));
    boundaries.add(getTimeInMinutes(session.endTime));
  }

  final sortedBoundaries = boundaries.toList()..sort();
  final freeSlots = <FreeSlot>[];

  for (int i = 0; i < sortedBoundaries.length - 1; i++) {
    final startMin = sortedBoundaries[i];
    final endMin = sortedBoundaries[i + 1];

    // Skip intervals shorter than 10 minutes (same threshold as the TS source).
    if (endMin - startMin < 10) continue;

    final occupiedRooms =
        getOccupiedRooms(allSchedules, dayIndex, startMin, endMin);
    final freeRooms =
        allRooms.where((r) => !occupiedRooms.contains(r)).toList();

    if (freeRooms.isNotEmpty) {
      freeSlots.add(FreeSlot(
        startTime: minutesToTime(startMin),
        endTime: minutesToTime(endMin),
        rooms: freeRooms,
      ));
    }
  }

  return freeSlots;
}

// ─── Duration Formatting ──────────────────────────────────────────────────────

/// Returns a human-readable duration string, e.g. "1 hr 30 min".
/// Mirrors the `getDuration` helper in free-slots-screen.tsx.
String getDuration(String startTime, String endTime) {
  final diff = getTimeInMinutes(endTime) - getTimeInMinutes(startTime);
  final hours = diff ~/ 60;
  final mins = diff % 60;

  if (hours == 0) return '$mins min';
  if (mins == 0) return '$hours hr';
  return '$hours hr $mins min';
}
