import 'package:civis_prep/models/exam_catalog.dart';
import 'package:civis_prep/services/content_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContentService', () {
    test(
      'loads a broad CCSE bank and creates a 25-question mock exam',
      () async {
        final service = ContentService();
        final questions = await service.getQuestionsByExam('CCSE');

        expect(questions.length, greaterThanOrEqualTo(300));

        final ids = questions.map((question) => question.id).toList();
        expect(
          ids.length,
          equals(ids.toSet().length),
          reason: 'CCSE question IDs must be unique.',
        );

        final prompts = questions
            .map((question) => question.prompt.trim())
            .toList();
        expect(
          prompts.length,
          equals(prompts.toSet().length),
          reason: 'CCSE prompts must be unique across the bank.',
        );

        for (final task in ExamCatalog.ccseTasks) {
          final taskQuestions = questions
              .where((question) => question.task == task)
              .toList();
          expect(
            taskQuestions.length,
            greaterThanOrEqualTo(25),
            reason: 'Task $task should provide a broad enough practice pool.',
          );
        }

        final mock = await service.buildMockExam('CCSE');
        expect(mock.length, 25);
      },
    );

    test('buildMockExam produces varied question order across runs', () async {
      final service = ContentService();
      final firstRun = await service.buildMockExam('CCSE');
      final secondRun = await service.buildMockExam('CCSE');
      final thirdRun = await service.buildMockExam('CCSE');

      final orders = {
        firstRun.map((question) => question.id).join(','),
        secondRun.map((question) => question.id).join(','),
        thirdRun.map((question) => question.id).join(','),
      };

      expect(orders.length, greaterThan(1));
    });

    test(
      'CCSE bank varies the correct option position across questions',
      () async {
        final service = ContentService();
        final questions = await service.getQuestionsByExam('CCSE');

        final correctOptionPositions = questions
            .map((question) => question.correctOptionId)
            .toSet();

        expect(
          correctOptionPositions.length,
          greaterThanOrEqualTo(4),
          reason:
              'CCSE questions should not concentrate the correct answer in the same option position.',
        );
      },
    );

    test('CCSE bank keeps varied prompt stems across official tasks', () async {
      final service = ContentService();
      final questions = await service.getQuestionsByExam('CCSE');

      String promptStem(String prompt) {
        return prompt
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9áéíóúüñ ]+'), ' ')
            .split(RegExp(r'\s+'))
            .where((word) => word.isNotEmpty)
            .take(5)
            .join(' ');
      }

      for (final task in ExamCatalog.ccseTasks) {
        final stems = questions
            .where((question) => question.task == task)
            .map((question) => promptStem(question.prompt))
            .toSet();

        expect(
          stems.length,
          greaterThanOrEqualTo(5),
          reason:
              'Task $task should keep enough prompt variety to avoid repetitive stems.',
        );
      }
    });

    test('CCSE explanations keep a complete editorial format', () async {
      final service = ContentService();
      final questions = await service.getQuestionsByExam('CCSE');

      final malformed = questions.where((question) {
        final explanation = question.explanation.trim();
        return explanation.length < 20 || !explanation.endsWith('.');
      }).toList();

      expect(
        malformed,
        isEmpty,
        reason: 'All CCSE explanations should be complete, readable sentences.',
      );
    });

    test('buildMockExam uses a stable task distribution for CCSE', () async {
      final service = ContentService();
      final mock = await service.buildMockExam('CCSE');

      final counts = <String, int>{};
      for (final question in mock) {
        counts.update(question.task, (value) => value + 1, ifAbsent: () => 1);
      }

      expect(counts['Gobierno, legislación y participación ciudadana'], 7);
      expect(counts['Derechos y deberes fundamentales'], 5);
      expect(
        counts['Organización territorial de España. Geografía física y política'],
        5,
      );
      expect(counts['Cultura e historia de España'], 4);
      expect(counts['Sociedad española'], 4);
    });
  });
}
