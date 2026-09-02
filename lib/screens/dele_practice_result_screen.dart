import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/dele_exercise_model.dart';
import '../services/progress_service.dart';

class DelePracticeResultScreen extends StatelessWidget {
  final List<DeleExerciseModel> exercises;
  final List<String?> selectedAnswers;

  const DelePracticeResultScreen({
    super.key,
    required this.exercises,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final progressService = ProgressService();
    final results = <Map<String, dynamic>>[];
    var correctCount = 0;

    for (var index = 0; index < exercises.length; index++) {
      final exercise = exercises[index];
      final selectedAnswer = selectedAnswers[index];
      final option = exercise.options.firstWhere(
        (item) => item.id == selectedAnswer,
        orElse: () => const DeleOption(id: '', text: 'Sin respuesta', isCorrect: false),
      );
      final isCorrect = selectedAnswer == exercise.correctOptionId;
      if (isCorrect) {
        correctCount++;
      }
      unawaited(progressService.recordAnswer(
        exam: 'DELE',
        topic: exercise.section,
        isCorrect: isCorrect,
      ));
      results.add({
        'prompt': exercise.prompt,
        'selected': selectedAnswer == null ? 'Sin respuesta' : option.text,
        'correct': exercise.options.firstWhere((item) => item.id == exercise.correctOptionId).text,
        'isCorrect': isCorrect,
        'explanation': exercise.explanation,
      });
    }

    final total = exercises.length;
    final percentage = total == 0 ? 0.0 : (correctCount / total) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('DELE')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.translate('studySummary'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('${strings.translate('correctAnswers')}: $correctCount / $total'),
                    Text('${strings.translate('percentage')}: ${percentage.toStringAsFixed(1)}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(strings.translate('details'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(result['prompt'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text('${strings.translate('yourAnswer')}: ${result['selected']}'),
                          Text('${strings.translate('correctAnswer')}: ${result['correct']}'),
                          Text(result['isCorrect'] == true ? '✅ ${strings.translate('correct')}' : '❌ ${strings.translate('incorrect')}'),
                          const SizedBox(height: 6),
                          Text('${strings.translate('explanation')}: ${result['explanation']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: Text(strings.translate('backToHome')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
