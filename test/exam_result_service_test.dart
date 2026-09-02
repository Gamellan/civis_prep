import 'package:civis_prep/models/question_model.dart';
import 'package:civis_prep/services/exam_result_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExamResultService', () {
    test('buildSummary calculates correct answers and percentage', () {
      final service = ExamResultService();
      final questions = [
        QuestionModel(
          id: 'q1',
          exam: 'CCSE',
          task: 'Test',
          topic: 'Test',
          prompt: 'Pregunta 1',
          options: [
            const QuestionOption(id: 'a', text: 'Opción A', isCorrect: true),
            const QuestionOption(id: 'b', text: 'Opción B', isCorrect: false),
          ],
          correctOptionId: 'a',
          explanation: 'Explicación',
          difficulty: 'fácil',
        ),
        QuestionModel(
          id: 'q2',
          exam: 'CCSE',
          task: 'Test',
          topic: 'Test',
          prompt: 'Pregunta 2',
          options: [
            const QuestionOption(id: 'a', text: 'Opción A', isCorrect: false),
            const QuestionOption(id: 'b', text: 'Opción B', isCorrect: true),
          ],
          correctOptionId: 'b',
          explanation: 'Explicación',
          difficulty: 'fácil',
        ),
        QuestionModel(
          id: 'q3',
          exam: 'CCSE',
          task: 'Test',
          topic: 'Test',
          prompt: 'Pregunta 3',
          options: [
            const QuestionOption(id: 'a', text: 'Opción A', isCorrect: true),
            const QuestionOption(id: 'b', text: 'Opción B', isCorrect: false),
          ],
          correctOptionId: 'a',
          explanation: 'Explicación',
          difficulty: 'fácil',
        ),
      ];

      final summary = service.buildSummary(questions, ['a', null, 'b']);

      expect(summary.totalQuestions, 3);
      expect(summary.answeredCount, 2);
      expect(summary.correctCount, 1);
      expect(summary.incorrectCount, 2);
      expect(summary.percentage, closeTo(33.33, 0.01));
      expect(summary.results.first.isCorrect, isTrue);
      expect(summary.results[1].isCorrect, isFalse);
      expect(summary.results[1].selectedAnswerText, 'Sin responder');
      expect(summary.results[2].selectedAnswerText, 'Opción B');
    });
  });
}
