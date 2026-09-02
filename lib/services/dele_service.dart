import '../models/dele_exercise_model.dart';
import '../repositories/dele_repository.dart';

class DeleService {
  final DeleRepository _repository = DeleRepository();

  Future<List<DeleExerciseModel>> getExercises() async {
    return _repository.getExercises();
  }

  Future<List<DeleExerciseModel>> getExercisesBySection(String section, {int limit = 0}) async {
    return _repository.getExercisesBySection(section, limit: limit);
  }
}
