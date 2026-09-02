import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/exam_type.dart';
import '../models/question_model.dart';
import '../services/content_service.dart';
import '../services/exam_result_service.dart';
import '../services/mock_exam_session_service.dart';
import '../services/progress_service.dart';

class MockExamScreen extends StatefulWidget {
  final List questions;
  final MockExamMode mode;
  final bool restoreSession;

  const MockExamScreen({
    super.key,
    required this.questions,
    this.mode = MockExamMode.official,
    this.restoreSession = true,
  });

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  int currentIndex = 0;
  final List<String?> selectedAnswers = [];
  final Set<int> flaggedQuestions = <int>{};
  int secondsRemaining = 0;
  bool isFinished = false;
  bool isInitializing = true;
  Timer? _timer;
  late List<QuestionModel> _questions;
  final ExamResultService _resultService = ExamResultService();
  final ProgressService _progressService = ProgressService();
  final MockExamSessionService _sessionService = MockExamSessionService();

  int get _durationMinutes => widget.mode.durationMinutes;
  String get _modeLabel => widget.mode.label;

  @override
  void initState() {
    super.initState();
    _initializeMockExam();
  }

  @override
  void dispose() {
    _saveSessionState();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeMockExam() async {
    secondsRemaining = _durationMinutes * 60;
    _questions = widget.questions.cast<QuestionModel?>().whereType<QuestionModel>().toList();
    selectedAnswers.clear();
    selectedAnswers.addAll(List.filled(_questions.length, null));

    if (!widget.restoreSession) {
      await _clearSessionState();
    }

    final restored = widget.restoreSession ? await _restoreSessionState() : false;
    _startTimer();

    if (!mounted) return;
    setState(() {
      isInitializing = false;
    });

    if (restored && mounted) {
      final strings = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.translate('mockResumed'))),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || isFinished || isInitializing) return;
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });

        if (secondsRemaining % 5 == 0) {
          _saveSessionState();
        }
      } else {
        _timer?.cancel();
        _showResults();
      }
    });
  }

  Future<bool> _restoreSessionState() async {
    final session = await _sessionService.loadSession(mode: widget.mode);
    if (session == null || session.questionIds.isEmpty) {
      return false;
    }
    final allCcse = await ContentService().getQuestionsByExam(ExamType.ccse);
    final byId = <String, QuestionModel>{
      for (final question in allCcse) question.id: question,
    };

    final restoredQuestions = <QuestionModel>[];
    for (final id in session.questionIds) {
      final match = byId[id];
      if (match == null) {
        return false;
      }
      restoredQuestions.add(match);
    }

    if (restoredQuestions.isEmpty) {
      return false;
    }

    _questions = restoredQuestions;

    selectedAnswers
      ..clear()
      ..addAll(List.filled(_questions.length, null));
    for (var i = 0; i < session.selectedAnswers.length && i < selectedAnswers.length; i++) {
      selectedAnswers[i] = session.selectedAnswers[i];
    }

    flaggedQuestions
      ..clear()
      ..addAll(session.flaggedQuestions.where((index) => index >= 0 && index < _questions.length));

    currentIndex = session.currentIndex.clamp(0, _questions.length - 1);

    final maxSeconds = _durationMinutes * 60;
    secondsRemaining = session.secondsRemaining.clamp(0, maxSeconds);

    return true;
  }

  Future<void> _saveSessionState() async {
    if (isFinished || isInitializing || _questions.isEmpty) {
      return;
    }

    await _sessionService.saveSession(
      mode: widget.mode,
      data: MockExamSessionData(
        questionIds: _questions.map((question) => question.id).toList(),
        selectedAnswers: List<String?>.from(selectedAnswers),
        flaggedQuestions: flaggedQuestions.toList(),
        currentIndex: currentIndex,
        secondsRemaining: secondsRemaining,
        savedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _clearSessionState() async {
    await _sessionService.clearSession(mode: widget.mode);
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _recordProgress() async {
    final questions = _questions;
    for (var index = 0; index < questions.length; index++) {
      final question = questions[index];
      final selectedAnswer = selectedAnswers.length > index ? selectedAnswers[index] : null;
      final isCorrect = selectedAnswer != null && selectedAnswer == question.correctOptionId;
      await _progressService.recordAnswer(
        exam: question.exam,
        topic: question.task,
        isCorrect: isCorrect,
      );
    }
  }

  Future<void> _showResults() async {
    if (!isFinished) {
      setState(() {
        isFinished = true;
      });
    }
    _timer?.cancel();

    final summary = _resultService.buildSummary(
      _questions,
      selectedAnswers,
    );

    await _recordProgress();
    await _clearSessionState();

    if (!mounted) return;

    final strings = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.translate('mockExamCompleted')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.translateWith('answeredSummary', {'answered': summary.answeredCount.toString(), 'total': _questions.length.toString()})),
              const SizedBox(height: 8),
              Text(strings.translateWith('correctSummary', {'count': summary.correctCount.toString()})),
              Text(strings.translateWith('incorrectSummary', {'count': summary.incorrectCount.toString()})),
              Text(strings.translateWith('percentageSummary', {'value': summary.percentage.toStringAsFixed(1)})),
              const SizedBox(height: 16),
              Text(strings.translate('detailLabel'), style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...summary.results.map((result) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.prompt, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(strings.translateWith('correctChoiceLabel', {'answer': result.correctAnswerText})),
                      Text(strings.translateWith('userChoiceLabel', {'answer': result.selectedAnswerText})),
                      Text(result.isCorrect ? strings.translate('statusCorrect') : strings.translate('statusIncorrect')),
                      Text(strings.translateWith('explanationLabel', {'text': result.explanation})),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: Text(strings.translate('close')),
          ),
        ],
      ),
    );
  }

  Future<void> _openFinalReview() async {
    final strings = AppLocalizations.of(context);
    final unansweredIndexes = <int>[];
    for (var i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == null) {
        unansweredIndexes.add(i);
      }
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.translate('finalReview'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text('${strings.translate('notAnswered')}: ${unansweredIndexes.length}'),
                Text('${strings.translate('markedDoubtful')}: ${flaggedQuestions.length}'),
                const SizedBox(height: 12),
                if (unansweredIndexes.isEmpty && flaggedQuestions.isEmpty)
                  Text(strings.translate('readyToSubmit'))
                else
                  Text(strings.translate('checkBeforeSubmit')),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_questions.length, (index) {
                        final isAnswered = selectedAnswers[index] != null;
                        final isFlagged = flaggedQuestions.contains(index);
                        final isNeedsReview = !isAnswered || isFlagged;
                        return ChoiceChip(
                          label: Text('P${index + 1}'),
                          selected: isNeedsReview,
                          selectedColor: const Color(0xFFFFF3E0),
                          onSelected: (_) {
                            setState(() {
                              currentIndex = index;
                            });
                            _saveSessionState();
                            Navigator.of(sheetContext).pop();
                          },
                          avatar: isFlagged
                              ? const Icon(Icons.flag_rounded, size: 16, color: Color(0xFFD84315))
                              : (!isAnswered
                                    ? const Icon(Icons.help_outline_rounded, size: 16)
                                    : null),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: Text(strings.translate('continueReviewing')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          _showResults();
                        },
                        child: Text(strings.translate('submitMock')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    if (isInitializing) {
      return Scaffold(
        appBar: AppBar(title: Text('${strings.translate('mockExam')} $_modeLabel CCSE')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[currentIndex];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || isFinished) {
          return;
        }

        final shouldExit = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(strings.translate('exitMockQuestion')),
                content: Text(strings.translate('exitMockDescription')),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(strings.translate('stay')),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(strings.translate('exit')),
                  ),
                ],
              ),
            ) ??
            false;

        if (shouldExit) {
          await _saveSessionState();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('${strings.translate('mockExam')} $_modeLabel CCSE ${currentIndex + 1}/${_questions.length}')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F4C81).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined),
                  const SizedBox(width: 8),
                  Text('${strings.translate('timeRemaining')}: ${_formatTime(secondsRemaining)}'),
                  const Spacer(),
                  Text('${strings.translate('answeredQuestions')}: ${selectedAnswers.where((answer) => answer != null).length}/${_questions.length}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.prompt,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (flaggedQuestions.contains(currentIndex)) {
                        flaggedQuestions.remove(currentIndex);
                      } else {
                        flaggedQuestions.add(currentIndex);
                      }
                    });
                    _saveSessionState();
                  },
                  icon: Icon(
                    flaggedQuestions.contains(currentIndex) ? Icons.flag_rounded : Icons.outlined_flag_rounded,
                    color: flaggedQuestions.contains(currentIndex) ? const Color(0xFFD84315) : null,
                  ),
                  label: Text(flaggedQuestions.contains(currentIndex) ? 'Dudosa marcada' : 'Marcar como dudosa'),
                ),
                const Spacer(),
                Text(
                  'Dudosas: ${flaggedQuestions.length}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...currentQuestion.options.map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedAnswers[currentIndex] = option.id;
                    });
                    _saveSessionState();
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: option.id,
                        groupValue: selectedAnswers[currentIndex],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedAnswers[currentIndex] = value;
                          });
                          _saveSessionState();
                        },
                      ),
                      Expanded(child: Text(option.text)),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: currentIndex > 0
                        ? () {
                            setState(() => currentIndex--);
                            _saveSessionState();
                          }
                        : null,
                    child: const Text('Anterior'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex < _questions.length - 1) {
                        setState(() => currentIndex++);
                        _saveSessionState();
                      } else {
                        _openFinalReview();
                      }
                    },
                    child: Text(currentIndex < _questions.length - 1 ? 'Siguiente' : 'Revisar y entregar'),
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}
