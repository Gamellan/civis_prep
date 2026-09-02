import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/study_plan_service.dart';
import '../services/study_streak_service.dart';

class StudyPlanScreen extends StatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  State<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  late final Future<StudyStreakSnapshot> _streakFuture;
  final StudyStreakService _streakService = StudyStreakService();
  final StudyPlanService _studyPlanService = StudyPlanService();
  final List<String> _planItems = [
    'studyPlanTask1',
    'studyPlanTask2',
    'studyPlanTask3',
    'studyPlanTask4',
  ];
  final Set<int> _completedIndexes = <int>{};

  @override
  void initState() {
    super.initState();
    _streakFuture = _loadStreak();
    _loadCompletedItems();
  }

  Future<StudyStreakSnapshot> _loadStreak() async {
    final snapshot = await _streakService.recordStudySession(date: DateTime.now());
    return snapshot;
  }

  Future<void> _loadCompletedItems() async {
    final completed = await _studyPlanService.getCompletedIndexes();
    if (!mounted) return;
    setState(() {
      _completedIndexes.clear();
      _completedIndexes.addAll(completed);
    });
  }

  Future<void> _toggleItem(int index) async {
    setState(() {
      if (_completedIndexes.contains(index)) {
        _completedIndexes.remove(index);
      } else {
        _completedIndexes.add(index);
      }
    });

    await _studyPlanService.saveCompletedIndexes(_completedIndexes.toList());
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final completedCount = _completedIndexes.length;
    final progressPercentage = _planItems.isEmpty ? 0.0 : completedCount / _planItems.length;
    final progressLabel = progressPercentage >= 1.0
        ? strings.translate('dailyGoalCompleted')
        : progressPercentage >= 0.5
            ? strings.translate('goodProgress')
            : strings.translate('startWithFirstTask');

    return Scaffold(
      appBar: AppBar(title: Text(strings.translate('studyPlanTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<StudyStreakSnapshot>(
              future: _streakFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(strings.translate('loadingYourStreak')),
                    ),
                  );
                }

                final streak = snapshot.data!;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(strings.translate('recommendedRoutine'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(strings.translateWith('currentStreak', {'value': streak.currentStreak.toString()})),
                        Text(strings.translateWith('bestStreak', {'value': streak.bestStreak.toString()})),
                        const SizedBox(height: 10),
                        Text(strings.translate('weeklySummary'), style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Row(
                          children: List.generate(streak.weeklySummary.length, (index) {
                            final isActive = streak.weeklySummary[index];
                            final dayLabel = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
                            return Expanded(
                              child: Column(
                                children: [
                                  Text(dayLabel, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: isActive ? const Color(0xFF00897B) : Colors.grey.shade300,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 4),
                        Text(strings.translate('studyRhythmDescription')),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.translate('dailyProgress'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(strings.translateWith('tasksCompleted', {'completed': completedCount.toString(), 'total': _planItems.length.toString()})),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progressPercentage,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF00897B),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progressPercentage * 100).toStringAsFixed(0)}% • $progressLabel',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(strings.translate('today'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...List.generate(_planItems.length, (index) {
              final item = strings.translate(_planItems[index]);
              final completed = _completedIndexes.contains(index);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => _toggleItem(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        completed ? Icons.check_box_rounded : Icons.check_box_outline_blank,
                        color: const Color(0xFF00897B),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            decoration: completed ? TextDecoration.lineThrough : null,
                            color: completed ? Colors.black54 : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(strings.translate('backToHome')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}