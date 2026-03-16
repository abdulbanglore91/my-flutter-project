# UniSchedule

A university timetable companion app. The repository contains two codebases:

1. **Flutter/Dart app** (`lib/`, `pubspec.yaml`) — the primary deliverable, fully translated from the React source. Run this locally with `flutter run`.

## Flutter Architecture

```
lib/
├── main.dart                           App entry point
├── app_theme.dart                      Colors, spacing, shadows, ThemeData
├── models/                             Data models (ClassSession, DaySchedule, etc.)
├── data/                               Sample data + all timetable utility functions
├── screens/                            Root screen (HomeScreen)
└── components/
    ├── shared/                         GlassCard, PulsingDot, TypeBadge
    ├── navigation/                     FloatingNav
    └── timetable/                      All timetable-specific widgets
```

## Design Tokens

- Background: `#0B0C10`
- Cyan accent: `#66FCF1`
- Purple accent: `#7B2CBF`
- Font: Inter (via google_fonts)

## Flutter Setup

```bash
flutter pub get
flutter run
```
