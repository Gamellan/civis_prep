import 'dart:math';

import 'package:flutter/material.dart';

import '../models/exam_type.dart';
import '../models/question_model.dart';
import '../services/content_service.dart';
import '../services/mock_exam_session_service.dart';
import 'dele_practice_screen.dart';
import 'dele_section_screen.dart';
import 'listening_practice_screen.dart';
import 'mock_exam_briefing_screen.dart';
import 'mock_exam_screen.dart';
import '../widgets/exam_navigation.dart';

class ExamCategoryScreen extends StatelessWidget {
  final ExamType examType;
  static final MockExamSessionService _mockExamSessionService = MockExamSessionService();

  const ExamCategoryScreen({super.key, required this.examType});

  Future<void> _startMockMode(
    BuildContext context, {
    required MockExamMode mode,
    required bool resume,
  }) async {
    final pool = await ContentService().buildMockExam(ExamType.ccse);
    final random = Random();
    final questions = List<QuestionModel>.from(pool)..shuffle(random);
    final selected = questions.take(mode.questionCount).toList();

    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => resume
            ? MockExamScreen(
                questions: selected,
                mode: mode,
                restoreSession: true,
              )
            : MockExamBriefingScreen(
                questions: selected,
                mode: mode,
              ),
      ),
    );
  }

  Future<bool> _hasSavedSession(MockExamMode mode) async {
    return _mockExamSessionService.hasPendingSession(mode: mode);
  }

  Future<void> _openMockModeSelector(BuildContext context) async {
    final hasQuickSession = await _hasSavedSession(MockExamMode.quick);
    final hasOfficialSession = await _hasSavedSession(MockExamMode.official);

    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecciona modo de simulacro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Rápido'),
                  subtitle: const Text('10 preguntas · 15 minutos'),
                  trailing: const Icon(Icons.bolt_rounded),
                  onTap: () async {
                    if (!sheetContext.mounted) return;
                    Navigator.of(sheetContext).pop();
                    await _startMockMode(
                      context,
                      mode: MockExamMode.quick,
                      resume: false,
                    );
                  },
                ),
                if (hasQuickSession)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        if (!sheetContext.mounted) return;
                        Navigator.of(sheetContext).pop();
                        await _startMockMode(
                          context,
                          mode: MockExamMode.quick,
                          resume: true,
                        );
                      },
                      icon: const Icon(Icons.restore_rounded),
                      label: const Text('Reanudar rápido'),
                    ),
                  ),
                const Divider(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Oficial CCSE'),
                  subtitle: const Text('25 preguntas · 45 minutos'),
                  trailing: const Icon(Icons.verified_rounded),
                  onTap: () async {
                    if (!sheetContext.mounted) return;
                    Navigator.of(sheetContext).pop();
                    await _startMockMode(
                      context,
                      mode: MockExamMode.official,
                      resume: false,
                    );
                  },
                ),
                if (hasOfficialSession)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        if (!sheetContext.mounted) return;
                        Navigator.of(sheetContext).pop();
                        await _startMockMode(
                          context,
                          mode: MockExamMode.official,
                          resume: true,
                        );
                      },
                      icon: const Icon(Icons.restore_rounded),
                      label: const Text('Reanudar oficial'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCcse = examType.isCcse;
    final options = isCcse
        ? [
            (
              title: 'Simulacro CCSE',
              onTap: () => _openMockModeSelector(context)
            ),
          ]
        : [
            (
              title: 'Práctica por prueba',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DeleSectionScreen()),
                );
              }
            ),
            (
              title: 'Escucha guiada (auditiva)',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ListeningPracticeScreen()),
                );
              }
            ),
            (
              title: 'Reto breve de DELE',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DelePracticeScreen(section: 'Comprensión de lectura')),
                );
              }
            ),
          ];

    return Scaffold(
      appBar: AppBar(title: Text(examType.displayName)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExamNavigation(title: option.title, onTap: option.onTap),
          );
        },
      ),
    );
  }
}
