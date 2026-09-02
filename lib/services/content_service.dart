import 'dart:math';

import '../data/ccse_curated_bank.dart';
import '../data/ccse_expanded_bank.dart';
import '../models/exam_catalog.dart';
import '../models/exam_type.dart';
import '../models/question_model.dart';
import '../repositories/ccse_repository.dart';
import 'ccse_curated_questions_phase2.dart';

class ContentService {
  Future<List<QuestionModel>> getQuestionsByExam(Object exam) async {
    final examType = _normalizeExamType(exam);
    return _allQuestions
        .where((question) => question.exam == examType.code)
        .toList();
  }

  Future<List<QuestionModel>> buildMockExam(Object exam) async {
    final examType = _normalizeExamType(exam);
    final questions = await getQuestionsByExam(examType);

    if (!examType.isCcse) {
      final shuffled = List<QuestionModel>.from(questions)..shuffle(Random());
      return shuffled.take(25).toList();
    }

    final random = Random();
    final selected = <QuestionModel>[];
    final usedIds = <String>{};

    for (final entry in ExamCatalog.ccseTaskDistribution.entries) {
      final pool =
          questions.where((question) => question.task == entry.key).toList()
            ..shuffle(random);
      final picked = pool
          .where((question) => usedIds.add(question.id))
          .take(entry.value)
          .toList();
      selected.addAll(picked);
    }

    if (selected.length < 25) {
      final remaining =
          questions.where((question) => !usedIds.contains(question.id)).toList()
            ..shuffle(random);
      selected.addAll(remaining.take(25 - selected.length));
    }

    selected.shuffle(random);
    return selected.take(25).toList();
  }

  ExamType _normalizeExamType(Object exam) {
    if (exam is ExamType) {
      return exam;
    }

    final normalized = exam.toString().toUpperCase();
    return normalized == 'DELE' ? ExamType.dele : ExamType.ccse;
  }

  static final List<QuestionModel> _allQuestions = [
    ...ccseCoreQuestions,
    ...curatedCcseQuestions,
    ...curatedCcseQuestionsPhase2,
    ...expandedCcseQuestions,
  ];
}
