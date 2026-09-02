import 'app_storage_service.dart';

class StudyPlanService {
  static const String _storageKey = 'study_plan_completed';
  final AppStorageService _storage = AppStorageService();

  Future<List<int>> getCompletedIndexes() async {
    final raw = await _storage.getStringList(_storageKey);
    final completed = raw ?? <String>[];
    return completed.map((value) => int.tryParse(value)).whereType<int>().toList();
  }

  Future<void> saveCompletedIndexes(List<int> indexes) async {
    await _storage.setStringList(
      _storageKey,
      indexes.map((value) => value.toString()).toList(),
    );
  }
}