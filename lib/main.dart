import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';

// =============================================================================
// UniSchedule — Flutter Entry Point
//
// Project: University Timetable App
// Translated from: React/Next.js + Tailwind CSS source
//
// Architecture:
//   lib/
//   ├── main.dart                           ← App entry point (this file)
//   ├── app_theme.dart                      ← All colours, spacing, shadows
//   ├── models/
//   │   ├── class_session.dart              ← ClassSession model + ClassType enum
//   │   ├── day_schedule.dart               ← DaySchedule model
//   │   ├── free_slot.dart                  ← FreeSlot model
//   │   └── program.dart                    ← Program model
//   ├── data/
//   │   ├── timetable_data.dart             ← Week data + all utility functions
//   │   └── sample_programs.dart            ← Demo program list
//   ├── screens/
//   │   └── home_screen.dart                ← Root screen (= page.tsx)
//   └── components/
//       ├── shared/
//       │   ├── glass_card.dart             ← Glassmorphism container widget
//       │   ├── pulsing_dot.dart            ← Animated live indicator
//       │   └── type_badge.dart             ← Lecture/Practical/Combined badge
//       ├── navigation/
//       │   └── floating_nav.dart           ← Bottom floating navigation bar
//       └── timetable/
//           ├── contextual_header.dart      ← Live clock, greeting, class count
//           ├── day_carousel.dart           ← Horizontal PageView of day cards
//           ├── day_flashcard.dart          ← Single day card with timeline
//           ├── class_node.dart             ← Individual class row (view + edit)
//           ├── new_class_form.dart         ← Inline form to add a class
//           ├── add_class_button.dart       ← Dashed "Add Makeup Class" button
//           ├── add_day_card.dart           ← Dashed "Add Day" carousel card
//           ├── free_slots_screen.dart      ← Free-room timeline screen
//           └── program_selection_modal.dart← Bottom-sheet program picker
// =============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UniScheduleApp());
}

class UniScheduleApp extends StatelessWidget {
  const UniScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniSchedule',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
