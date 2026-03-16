🛑 CRITICAL SYSTEM OVERRIDE & ROLE RESET
Stop analyzing the web build. I do not care about the web server, port 5000, or the blank white screen. I am compiling this app LOCALLY on my own computer using Android Studio.

YOUR NEW ROLE: You are strictly an offline Code Writer.
YOUR RESTRICTIONS: DO NOT run any more terminal commands. DO NOT try to build, run, or deploy this app.
YOUR ONLY JOB: Read my Dart files, write the code to fix the 4 specific UI bugs listed below, and output the raw code blocks for me to copy and paste manually.

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
