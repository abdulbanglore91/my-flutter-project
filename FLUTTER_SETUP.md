# UniSchedule — Flutter Setup Guide

## Prerequisites

- Flutter SDK ≥ 3.3.0 — https://flutter.dev/docs/get-started/install
- Dart SDK ≥ 3.3.0 (bundled with Flutter)

## Run the app

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on your connected device or emulator
flutter run

# 3. Build a release APK
flutter build apk --release

# 4. Build for iOS (macOS only)
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                           Entry point
├── app_theme.dart                      Colors, spacing, shadows, ThemeData
├── models/
│   ├── class_session.dart              ClassSession + ClassType enum
│   ├── day_schedule.dart               DaySchedule
│   ├── free_slot.dart                  FreeSlot
│   └── program.dart                    Program
├── data/
│   ├── timetable_data.dart             Sample week data + all utility functions
│   └── sample_programs.dart            Demo programs for the profile modal
├── screens/
│   └── home_screen.dart                Root screen with nav state
└── components/
    ├── shared/
    │   ├── glass_card.dart             Glassmorphism BackdropFilter card
    │   ├── pulsing_dot.dart            Animated live indicator
    │   └── type_badge.dart             Lecture / Practical / Combined pill
    ├── navigation/
    │   └── floating_nav.dart           Bottom floating navigation bar
    └── timetable/
        ├── contextual_header.dart      Live clock + greeting + class count
        ├── day_carousel.dart           Horizontal PageView of day cards
        ├── day_flashcard.dart          Single day card with scrollable timeline
        ├── class_node.dart             Class row — view mode + inline edit
        ├── new_class_form.dart         Inline form to add a new class
        ├── add_class_button.dart       Dashed "Add Makeup Class" button
        ├── add_day_card.dart           "Add Day" card at carousel end
        ├── free_slots_screen.dart      Free-room timeline screen
        └── program_selection_modal.dart Bottom-sheet program picker
```

## Design Tokens (from app_theme.dart)

| Token | Value | React Source |
|-------|-------|-------------|
| `AppColors.background` | `#0B0C10` | `bg-[#0B0C10]` |
| `AppColors.cyan` | `#66FCF1` | `bg-[#66FCF1]` |
| `AppColors.purple` | `#7B2CBF` | `bg-[#7B2CBF]` |
| `AppColors.purpleLight` | `#C77DFF` | `text-[#C77DFF]` |
| `AppColors.danger` | `#FF6B6B` | `text-[#FF6B6B]` |
| `AppColors.foreground` | `#E8E8E8` | `text-foreground` |
| `AppColors.mutedForeground` | `#6B7280` | `text-[var(--muted-foreground)]` |
