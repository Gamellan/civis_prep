import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:civis_prep/services/study_streak_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('records a first study session and stores a streak of one', () async {
    final service = StudyStreakService();

    final snapshot = await service.recordStudySession(date: DateTime(2026, 8, 1));

    expect(snapshot.currentStreak, 1);
    expect(snapshot.bestStreak, 1);
    expect(snapshot.lastActiveDay, DateTime(2026, 8, 1));
  });

  test('increments the streak for consecutive days and resets after a break', () async {
    final service = StudyStreakService();

    final first = await service.recordStudySession(date: DateTime(2026, 8, 1));
    final second = await service.recordStudySession(date: DateTime(2026, 8, 2));
    final afterBreak = await service.recordStudySession(date: DateTime(2026, 8, 4));

    expect(first.currentStreak, 1);
    expect(second.currentStreak, 2);
    expect(afterBreak.currentStreak, 1);
    expect(afterBreak.bestStreak, 2);
  });
}
