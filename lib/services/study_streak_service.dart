import 'dart:convert';

import 'app_storage_service.dart';

class StudyStreakSnapshot {
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastActiveDay;
  final List<DateTime> activeDays;
  final List<bool> weeklySummary;

  const StudyStreakSnapshot({
    required this.currentStreak,
    required this.bestStreak,
    required this.lastActiveDay,
    required this.activeDays,
    required this.weeklySummary,
  });
}

class StudyStreakService {
  static const String _storageKey = 'study_streak_snapshot';
  final AppStorageService _storage = AppStorageService();

  Future<StudyStreakSnapshot> recordStudySession({required DateTime date}) async {
    final rawSnapshot = await _loadSnapshot();
    final snapshot = _parseSnapshot(rawSnapshot);
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final existingDates = snapshot.activeDays.map((item) => DateTime(item.year, item.month, item.day)).toList();
    if (existingDates.contains(normalizedDate)) {
      return snapshot;
    }

    final updatedDays = [...existingDates, normalizedDate]..sort();
    final lastActiveDay = snapshot.lastActiveDay;

    int currentStreak = 1;
    if (lastActiveDay != null) {
      final difference = normalizedDate.difference(lastActiveDay).inDays;
      if (difference == 1) {
        currentStreak = snapshot.currentStreak + 1;
      } else if (difference > 1) {
        currentStreak = 1;
      } else {
        currentStreak = snapshot.currentStreak;
      }
    }

    final bestStreak = snapshot.bestStreak < currentStreak ? currentStreak : snapshot.bestStreak;
    final updatedSnapshot = {
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastActiveDay': normalizedDate.toIso8601String(),
      'activeDays': updatedDays.map((day) => day.toIso8601String()).toList(),
    };

    await _storage.setString(_storageKey, jsonEncode(updatedSnapshot));
    return StudyStreakSnapshot(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      lastActiveDay: normalizedDate,
      activeDays: updatedDays,
      weeklySummary: _buildWeeklySummary(updatedDays),
    );
  }

  Future<StudyStreakSnapshot> getSnapshot() async {
    final rawSnapshot = await _loadSnapshot();
    return _parseSnapshot(rawSnapshot);
  }

  Future<Map<String, dynamic>> _loadSnapshot() async {
    final raw = await _storage.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return {
        'currentStreak': 0,
        'bestStreak': 0,
        'lastActiveDay': null,
        'activeDays': <String>[],
      };
    }

    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }

    return {
      'currentStreak': 0,
      'bestStreak': 0,
      'lastActiveDay': null,
      'activeDays': <String>[],
    };
  }

  StudyStreakSnapshot _parseSnapshot(Map<String, dynamic> snapshot) {
    final activeDays = (snapshot['activeDays'] as List<dynamic>? ?? <dynamic>[])
        .map((item) => DateTime.parse(item.toString()))
        .toList();

    final currentStreak = snapshot['currentStreak'] as int? ?? 0;
    final bestStreak = snapshot['bestStreak'] as int? ?? 0;
    final lastActiveDay = snapshot['lastActiveDay'] == null
        ? null
        : DateTime.parse(snapshot['lastActiveDay'].toString());

    return StudyStreakSnapshot(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      lastActiveDay: lastActiveDay,
      activeDays: activeDays,
      weeklySummary: _buildWeeklySummary(activeDays),
    );
  }

  List<bool> _buildWeeklySummary(List<DateTime> activeDays) {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final normalizedStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return List.generate(7, (index) {
      final day = normalizedStart.add(Duration(days: index));
      return activeDays.any((activeDay) => activeDay.year == day.year && activeDay.month == day.month && activeDay.day == day.day);
    });
  }
}
