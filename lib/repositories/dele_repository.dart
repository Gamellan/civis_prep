import 'dart:math';

import '../data/dele_bank.dart';
import '../models/dele_exercise_model.dart';

class DeleRepository {
  static final Random _random = Random();

  Future<List<DeleExerciseModel>> getExercises() async {
    final exercises = <DeleExerciseModel>[];

    for (final exercise in _allExercises) {
      final options = List<DeleOption>.from(exercise.options)..shuffle(_random);
      final correctOptionId = options.firstWhere((option) => option.isCorrect).id;

      exercises.add(
        DeleExerciseModel(
          id: exercise.id,
          section: exercise.section,
          title: exercise.title,
          groupId: exercise.groupId,
          groupTitle: exercise.groupTitle,
          contextTitle: exercise.contextTitle,
          contextText: exercise.contextText,
          prompt: exercise.prompt,
          options: options,
          correctOptionId: correctOptionId,
          explanation: exercise.explanation,
          difficulty: exercise.difficulty,
        ),
      );
    }

    exercises.shuffle(_random);
    return exercises;
  }

  Future<List<DeleExerciseModel>> getExercisesBySection(String section, {int limit = 0}) async {
    final exercises = await getExercises();
    final sectionExercises = exercises.where((exercise) => exercise.section == section).toList();

    if (limit > 0 && sectionExercises.length > limit) {
      return sectionExercises.take(limit).toList();
    }

    return sectionExercises;
  }

  static final List<DeleExerciseModel> _allExercises = buildDeleBank();
}
