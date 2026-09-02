import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('Mock exam prep: ${mode.label}')),
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
                  Text('Mode: ${mode.label}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('Duration: ${mode.durationMinutes} minutes'),
                  Text('Questions: ${questions.length}'),
                  const SizedBox(height: 6),
                  const Text('Recommended read: 10–15 seconds before starting.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Quick rules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('• You can flag doubtful questions and review them at the end.'),
            const Text('• Progress is saved automatically during the mock exam.'),
            const Text('• Before submitting, you will see a final review screen.'),
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
                label: const Text('Start mock exam'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
