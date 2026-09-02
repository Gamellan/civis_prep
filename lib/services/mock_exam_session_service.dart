import 'dart:convert';

import '../models/exam_type.dart';
import 'app_storage_service.dart';

class MockExamSessionData {
  final List<String> questionIds;
  final List<String?> selectedAnswers;
  final List<int> flaggedQuestions;
  final int currentIndex;
  final int secondsRemaining;
  final DateTime savedAt;

  const MockExamSessionData({
    required this.questionIds,
    required this.selectedAnswers,
    required this.flaggedQuestions,
    required this.currentIndex,
    required this.secondsRemaining,
    required this.savedAt,
  });

  factory MockExamSessionData.fromJson(Map<String, dynamic> json) {
    return MockExamSessionData(
      questionIds: (json['questionIds'] as List<dynamic>? ?? <dynamic>[])
          .map((value) => value.toString())
          .toList(),
      selectedAnswers: (json['selectedAnswers'] as List<dynamic>? ?? <dynamic>[])
          .map<String?>((value) => value == null ? null : value.toString())
          .toList(),
      flaggedQuestions: (json['flaggedQuestions'] as List<dynamic>? ?? <dynamic>[])
          .map((value) => int.tryParse(value.toString()))
          .whereType<int>()
          .toList(),
      currentIndex: json['currentIndex'] as int? ?? 0,
      secondsRemaining: json['secondsRemaining'] as int? ?? 0,
      savedAt: DateTime.tryParse(json['savedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'questionIds': questionIds,
      'selectedAnswers': selectedAnswers,
      'flaggedQuestions': flaggedQuestions,
      'currentIndex': currentIndex,
      'secondsRemaining': secondsRemaining,
      'savedAt': savedAt.toIso8601String(),
    };
  }
}

class MockExamSessionService {
  final AppStorageService _storage = AppStorageService();

  Future<bool> hasPendingSession({required MockExamMode mode}) async {
    final raw = await _storage.getString(storageKeyForMode(mode));
    return raw?.trim().isNotEmpty ?? false;
  }

  Future<MockExamSessionData?> loadSession({required MockExamMode mode}) async {
    final raw = await _storage.getString(storageKeyForMode(mode));
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return MockExamSessionData.fromJson(decoded);
      }

      if (decoded is Map) {
        return MockExamSessionData.fromJson(decoded.map((key, value) => MapEntry(key.toString(), value)));
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  Future<void> saveSession({
    required MockExamMode mode,
    required MockExamSessionData data,
  }) async {
    await _storage.setString(storageKeyForMode(mode), jsonEncode(data.toJson()));
  }

  Future<void> clearSession({required MockExamMode mode}) async {
    await _storage.remove(storageKeyForMode(mode));
  }

  String storageKeyForMode(MockExamMode mode) {
    return 'ccse_mock_exam_session_${mode.storageSuffix}';
  }
}