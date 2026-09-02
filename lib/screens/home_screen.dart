import 'dart:math';

import 'package:flutter/material.dart';

import '../models/exam_type.dart';
import '../models/question_model.dart';
import '../l10n/app_localizations.dart';
import '../services/content_service.dart';
import '../services/dele_service.dart';
import '../services/mock_exam_session_service.dart';
import '../widgets/exam_navigation.dart';
import 'exam_category_screen.dart';
import 'flashcards_screen.dart';
import 'mock_exam_briefing_screen.dart';
import 'mock_exam_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import 'study_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F4C81).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0F4C81)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<(int, int)> _poolFuture;
  final MockExamSessionService _mockExamSessionService =
      MockExamSessionService();
  bool _hasQuickPending = false;
  bool _hasOfficialPending = false;

  @override
  void initState() {
    super.initState();
    _poolFuture = _loadPools();
    _refreshPendingMocks();
  }

  Future<(int, int)> _loadPools() async {
    final ccseCount = (await ContentService().getQuestionsByExam(
      ExamType.ccse,
    )).length;
    final deleCount = (await DeleService().getExercises()).length;
    return (ccseCount, deleCount);
  }

  Future<void> _startQuickMockExam() async {
    final pool = await ContentService().buildMockExam(ExamType.ccse);
    final random = Random();
    final quickQuestions = List<QuestionModel>.from(pool)..shuffle(random);

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MockExamBriefingScreen(
          questions: quickQuestions.take(10).toList(),
          mode: MockExamMode.quick,
        ),
      ),
    );
    await _refreshPendingMocks();
  }

  Future<void> _refreshPendingMocks() async {
    final hasQuick = await _mockExamSessionService.hasPendingSession(
      mode: MockExamMode.quick,
    );
    final hasOfficial = await _mockExamSessionService.hasPendingSession(
      mode: MockExamMode.official,
    );

    if (!mounted) return;
    setState(() {
      _hasQuickPending = hasQuick;
      _hasOfficialPending = hasOfficial;
    });
  }

  Future<void> _resumePendingMock({required MockExamMode mode}) async {
    final pool = await ContentService().buildMockExam(ExamType.ccse);
    final random = Random();
    final questions = List<QuestionModel>.from(pool)..shuffle(random);

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MockExamScreen(
          questions: questions.take(mode.questionCount).toList(),
          mode: mode,
          restoreSession: true,
        ),
      ),
    );
    await _refreshPendingMocks();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.translate('appTitle')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F4C81), Color(0xFF1C6EB5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/escudo_espana_estilizado.png',
                          width: 34,
                          height: 34,
                        ),
                        const SizedBox(width: 10),
                        const Text('🇪🇸', style: TextStyle(fontSize: 30)),
                        const SizedBox(width: 8),
                        const Text('🇪🇺', style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'CCSE DELE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.translate('homeHeroSubtitle'),
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<(int, int)>(
                      future: _poolFuture,
                      builder: (context, snapshot) {
                        final poolText = snapshot.hasData
                            ? strings.translateWith('questionPoolSummary', {
                                'ccse': snapshot.data!.$1.toString(),
                                'dele': snapshot.data!.$2.toString(),
                              })
                            : strings.translate('questionPoolLoading');

                        return Text(
                          poolText,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_hasQuickPending || _hasOfficialPending) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.translate('pendingMock'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(strings.translate('continueSession')),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            if (_hasQuickPending)
                              OutlinedButton.icon(
                                onPressed: () => _resumePendingMock(
                                  mode: MockExamMode.quick,
                                ),
                                icon: const Icon(Icons.restore_rounded),
                                label: Text(strings.translate('resumeQuick')),
                              ),
                            if (_hasOfficialPending)
                              OutlinedButton.icon(
                                onPressed: () => _resumePendingMock(
                                  mode: MockExamMode.official,
                                ),
                                icon: const Icon(Icons.restore_rounded),
                                label: Text(
                                  strings.translate('resumeOfficial'),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.translate('startNow'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(strings.translate('quickMockDescription')),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _startQuickMockExam,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(strings.translate('quickMock')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.translate('studySummary'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _SummaryChip(
                            icon: Icons.quiz_rounded,
                            label: strings.translate('summaryExams'),
                          ),
                          _SummaryChip(
                            icon: Icons.play_circle_fill_rounded,
                            label: strings.translate('summaryMocks'),
                          ),
                          _SummaryChip(
                            icon: Icons.style_rounded,
                            label: strings.translate('summaryFlashcards'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ExamNavigation(
                title: 'CCSE',
                subtitle: strings.translate('ccseSubtitle'),
                leading: Image.asset(
                  'assets/images/escudo_espana_estilizado.png',
                  width: 24,
                  height: 24,
                ),
                accentColor: const Color(0xFFB71C1C),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const ExamCategoryScreen(examType: ExamType.ccse),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ExamNavigation(
                title: 'DELE A2',
                subtitle: strings.translate('deleSubtitle'),
                leading: const Text('🇪🇸', style: TextStyle(fontSize: 24)),
                accentColor: const Color(0xFF0F4C81),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const ExamCategoryScreen(examType: ExamType.dele),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ExamNavigation(
                title: strings.translate('progressTitle'),
                subtitle: strings.translate('progressSubtitle'),
                leading: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                ),
                accentColor: const Color(0xFF2E7D32),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProgressScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ExamNavigation(
                title: strings.translate('flashcardsTitle'),
                subtitle: strings.translate('flashcardsSubtitle'),
                leading: const Icon(Icons.style_rounded, color: Colors.white),
                accentColor: const Color(0xFF6A1B9A),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FlashcardsScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ExamNavigation(
                title: strings.translate('studyPlanTitle'),
                subtitle: strings.translate('studyPlanSubtitle'),
                leading: const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white,
                ),
                accentColor: const Color(0xFF00897B),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StudyPlanScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ExamNavigation(
                title: strings.translate('settings'),
                subtitle: strings.translate('settingsSubtitle'),
                leading: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                ),
                accentColor: const Color(0xFF37474F),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
