import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/exam_type.dart';
import '../models/question_model.dart';
import 'mock_exam_screen.dart';

class MockExamBriefingScreen extends StatelessWidget {
  final List<QuestionModel> questions;
  final MockExamMode mode;

  const MockExamBriefingScreen({
    super.key,
    required this.questions,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final modeLabel = mode.label == 'quick' ? strings.translate('quick') : strings.translate('officialMode');

    return Scaffold(
      appBar: AppBar(title: Text(strings.translateWith('mockExamPreparation', {'mode': modeLabel}))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F4C81).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.translateWith('mockMode', {'mode': modeLabel}), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(strings.translateWith('mockDuration', {'minutes': mode.durationMinutes.toString()})),
                  Text(strings.translateWith('mockQuestionCount', {'count': questions.length.toString()})),
                  const SizedBox(height: 6),
                  Text(strings.translate('readBeforeStart')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(strings.translate('quickRules'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(strings.translate('quickRuleFlag')),
            Text(strings.translate('quickRuleAutosave')),
            Text(strings.translate('quickRuleReview')),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MockExamScreen(
                        questions: questions,
                        mode: mode,
                        restoreSession: false,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(strings.translate('startMockExam')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
