class DeleExerciseModel {
  final String id;
  final String section;
  final String title;
  final String? groupId;
  final String? groupTitle;
  final String? contextTitle;
  final String? contextText;
  final String prompt;
  final List<DeleOption> options;
  final String correctOptionId;
  final String explanation;
  final String difficulty;

  const DeleExerciseModel({
    required this.id,
    required this.section,
    required this.title,
    this.groupId,
    this.groupTitle,
    this.contextTitle,
    this.contextText,
    required this.prompt,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    required this.difficulty,
  });
}

class DeleOption {
  final String id;
  final String text;
  final bool isCorrect;

  const DeleOption({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}
