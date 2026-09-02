class QuestionModel {
  final String id;
  final String exam;
  final String task;
  final String topic;
  final String prompt;
  final List<QuestionOption> options;
  final String correctOptionId;
  final String explanation;
  final String difficulty;
  final String? sourceReference;
  final String contentVersion;

  const QuestionModel({
    required this.id,
    required this.exam,
    required this.task,
    required this.topic,
    required this.prompt,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    required this.difficulty,
    this.sourceReference,
    this.contentVersion = 'v1',
  });
}

class QuestionOption {
  final String id;
  final String text;
  final bool isCorrect;

  const QuestionOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}
