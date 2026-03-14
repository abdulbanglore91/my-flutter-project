import '../models/program.dart';

// =============================================================================
// SAMPLE PROGRAMS
// Dart equivalent of `samplePrograms` exported from program-selection-modal.tsx
// =============================================================================

/// Sample university programs shown in the Program Selection modal.
const List<Program> samplePrograms = [
  Program(
    id: 'bsit-5th-sem3',
    name: 'BSIT (5th Intake) Sem3',
    subjects: ['Network Security', 'Web Engineering', 'Civics', 'Database Systems'],
  ),
  Program(
    id: 'bsit-5th-sem4',
    name: 'BSIT (5th Intake) Sem4',
    subjects: ['Software Engineering', 'AI Fundamentals', 'Mobile Dev', 'Cloud Computing'],
  ),
  Program(
    id: 'bscs-6th-sem5',
    name: 'BSCS (6th Intake) Sem5',
    subjects: ['Machine Learning', 'Compiler Design', 'Distributed Systems', 'HCI'],
  ),
  Program(
    id: 'bsse-4th-sem2',
    name: 'BSSE (4th Intake) Sem2',
    subjects: ['Data Structures', 'OOP Concepts', 'Technical Writing', 'Calculus II'],
  ),
  Program(
    id: 'bsai-1st-sem1',
    name: 'BSAI (1st Intake) Sem1',
    subjects: ['Programming Fundamentals', 'Linear Algebra', 'Intro to AI', 'Statistics'],
  ),
];
