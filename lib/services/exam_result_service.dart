import '../models/question_model.dart';

class ExamResultSummary {
  final int totalQuestions;
  final int answeredCount;
  final int correctCount;
  final int incorrectCount;
  final double percentage;
  final List<QuestionResult> results;

  const ExamResultSummary({
    required this.totalQuestions,
    required this.answeredCount,
    required this.correctCount,
    required this.incorrectCount,
    required this.percentage,
    required this.results,
  });
}

class QuestionResult {
  final String prompt;
  final String correctAnswerText;
  final String selectedAnswerText;
  final bool isCorrect;
  final String explanation;

  const QuestionResult({
    required this.prompt,
    required this.correctAnswerText,
    required this.selectedAnswerText,
    required this.isCorrect,
    required this.explanation,
  });
}

class ExamResultService {
  ExamResultSummary buildSummary(List<QuestionModel> questions, List<String?> selectedAnswers) {
    final results = <QuestionResult>[];
    var correctCount = 0;
    var answeredCount = 0;

    for (var i = 0; i < questions.length; i++) {
      final question = questions[i];
      final selectedAnswer = selectedAnswers.length > i ? selectedAnswers[i] : null;
      final correctOption = question.options.firstWhere(
        (option) => option.id == question.correctOptionId,
        orElse: () => const QuestionOption(id: '', text: 'Sin respuesta', isCorrect: false),
      );
      final selectedOption = question.options.firstWhere(
        (option) => option.id == selectedAnswer,
        orElse: () => const QuestionOption(id: '', text: 'Sin responder', isCorrect: false),
      );

      final isCorrect = selectedAnswer != null && selectedAnswer == question.correctOptionId;
      if (selectedAnswer != null) {
        answeredCount++;
      }
      if (isCorrect) {
        correctCount++;
      }

      results.add(
        QuestionResult(
          prompt: question.prompt,
          correctAnswerText: correctOption.text,
          selectedAnswerText: selectedOption.text,
          isCorrect: isCorrect,
          explanation: question.explanation,
        ),
      );
    }

    final percentage = questions.isEmpty ? 0.0 : (correctCount / questions.length) * 100.0;

    return ExamResultSummary(
      totalQuestions: questions.length,
      answeredCount: answeredCount,
      correctCount: correctCount,
      incorrectCount: questions.length - correctCount,
      percentage: percentage,
      results: results,
    );
  }
}
