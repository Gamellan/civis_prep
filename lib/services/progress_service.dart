import 'dart:convert';

import 'app_storage_service.dart';

class ProgressStats {
  final int totalAnswers;
  final int correctAnswers;
  final int incorrectAnswers;
  final double overallAccuracy;
  final List<TopicProgress> topicStats;

  const ProgressStats({
    required this.totalAnswers,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.overallAccuracy,
    required this.topicStats,
  });
}

class ProgressDashboard {
  final int totalAnswers;
  final int correctAnswers;
  final int incorrectAnswers;
  final double overallAccuracy;
  final List<TopicProgress> topicStats;
  final int masteredTopics;
  final TopicProgress weakestTopic;
  final TopicProgress? bestTopic;

  const ProgressDashboard({
    required this.totalAnswers,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.overallAccuracy,
    required this.topicStats,
    required this.masteredTopics,
    required this.weakestTopic,
    this.bestTopic,
  });
}

class TopicProgress {
  final String exam;
  final String topic;
  final int questionsSeen;
  final int correctAnswers;
  final int incorrectAnswers;
  final double accuracy;

  const TopicProgress({
    required this.exam,
    required this.topic,
    required this.questionsSeen,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.accuracy,
  });
}

class ProgressService {
  static const String _storageKey = 'progress_snapshot';
  final AppStorageService _storage = AppStorageService();

  Future<void> recordAnswer({
    required String exam,
    required String topic,
    required bool isCorrect,
  }) async {
    final snapshot = await _loadSnapshot();

    final topicEntry = snapshot[topic] ?? <String, dynamic>{};
    final existing = Map<String, dynamic>.from(topicEntry);

    final seen = (existing['questionsSeen'] as int? ?? 0) + 1;
    final correct = (existing['correctAnswers'] as int? ?? 0) + (isCorrect ? 1 : 0);
    final incorrect = (existing['incorrectAnswers'] as int? ?? 0) + (isCorrect ? 0 : 1);

    existing['exam'] = exam;
    existing['topic'] = topic;
    existing['questionsSeen'] = seen;
    existing['correctAnswers'] = correct;
    existing['incorrectAnswers'] = incorrect;
    existing['lastUpdatedAt'] = DateTime.now().toIso8601String();

    snapshot[topic] = existing;
    await _storage.setString(_storageKey, jsonEncode(snapshot));
  }

  Future<ProgressStats> getStats() async {
    final snapshot = await _loadSnapshot();

    final topicStats = snapshot.entries.map((entry) {
      final values = Map<String, dynamic>.from(entry.value as Map);
      final questionsSeen = values['questionsSeen'] as int? ?? 0;
      final correctAnswers = values['correctAnswers'] as int? ?? 0;
      final incorrectAnswers = values['incorrectAnswers'] as int? ?? 0;
      final accuracy = questionsSeen == 0 ? 0.0 : (correctAnswers / questionsSeen) * 100;

      return TopicProgress(
        exam: values['exam'] as String? ?? 'CCSE',
        topic: values['topic'] as String? ?? entry.key,
        questionsSeen: questionsSeen,
        correctAnswers: correctAnswers,
        incorrectAnswers: incorrectAnswers,
        accuracy: accuracy,
      );
    }).toList();

    final totalAnswers = topicStats.fold<int>(0, (sum, item) => sum + item.questionsSeen);
    final correctAnswers = topicStats.fold<int>(0, (sum, item) => sum + item.correctAnswers);
    final incorrectAnswers = topicStats.fold<int>(0, (sum, item) => sum + item.incorrectAnswers);
    final overallAccuracy = totalAnswers == 0 ? 0.0 : (correctAnswers / totalAnswers) * 100;

    return ProgressStats(
      totalAnswers: totalAnswers,
      correctAnswers: correctAnswers,
      incorrectAnswers: incorrectAnswers,
      overallAccuracy: overallAccuracy,
      topicStats: topicStats,
    );
  }

  Future<ProgressDashboard> getDashboard() async {
    final stats = await getStats();
    final ordered = [...stats.topicStats]
      ..sort((a, b) => a.accuracy.compareTo(b.accuracy));

    final weakestTopic = ordered.isEmpty
        ? const TopicProgress(
            exam: 'CCSE',
            topic: 'Sin datos',
            questionsSeen: 0,
            correctAnswers: 0,
            incorrectAnswers: 0,
            accuracy: 0,
          )
        : ordered.first;

    final bestTopic = ordered.isEmpty
        ? null
        : ordered.reduce((current, next) => next.accuracy > current.accuracy ? next : current);

    final masteredTopics = stats.topicStats
        .where((item) => item.questionsSeen >= 3 && item.accuracy >= 80)
        .length;

    return ProgressDashboard(
      totalAnswers: stats.totalAnswers,
      correctAnswers: stats.correctAnswers,
      incorrectAnswers: stats.incorrectAnswers,
      overallAccuracy: stats.overallAccuracy,
      topicStats: stats.topicStats,
      masteredTopics: masteredTopics,
      weakestTopic: weakestTopic,
      bestTopic: bestTopic,
    );
  }

  Future<void> reset() async {
    await _storage.remove(_storageKey);
  }

  Future<Map<String, dynamic>> _loadSnapshot() async {
    final raw = await _storage.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }

    return <String, dynamic>{};
  }
}
