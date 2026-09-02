import 'package:flutter/material.dart';

import '../models/dele_exercise_model.dart';
import '../services/dele_service.dart';
import 'dele_practice_result_screen.dart';

class DelePracticeScreen extends StatefulWidget {
  final String section;

  const DelePracticeScreen({super.key, required this.section});

  @override
  State<DelePracticeScreen> createState() => _DelePracticeScreenState();
}

class _DelePracticeScreenState extends State<DelePracticeScreen> {
  List<DeleExerciseModel> exercises = [];
  int currentIndex = 0;
  final List<String?> selectedAnswers = [];
  bool isLoading = true;
  bool _showValidationError = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final service = DeleService();
    final loaded = await service.getExercisesBySection(widget.section, limit: 25);
    final uniqueExercises = <String, DeleExerciseModel>{};

    for (final exercise in loaded) {
      uniqueExercises.putIfAbsent(exercise.id, () => exercise);
    }

    final practiceExercises = uniqueExercises.values.toList()..shuffle();

    if (!mounted) return;
    setState(() {
      exercises = practiceExercises;
      selectedAnswers.clear();
      selectedAnswers.addAll(List.filled(exercises.length, null));
      isLoading = false;
      _showValidationError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.section)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.section)),
        body: const Center(child: Text('No hay ejercicios disponibles para esta sección todavía.')),
      );
    }

    final currentExercise = exercises[currentIndex];
    final currentGroupExercises = currentExercise.groupId == null
        ? const <DeleExerciseModel>[]
        : exercises.where((exercise) => exercise.groupId == currentExercise.groupId).toList();
    final currentGroupPosition = currentExercise.groupId == null
        ? 0
        : currentGroupExercises.indexWhere((exercise) => exercise.id == currentExercise.id) + 1;

    return Scaffold(
      appBar: AppBar(title: Text(widget.section)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentExercise.groupId != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F4C81).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentExercise.groupTitle ?? 'Bloque de práctica',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pregunta $currentGroupPosition de ${currentGroupExercises.length} dentro del mismo bloque',
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(currentExercise.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      if (currentExercise.contextText != null && currentExercise.contextText!.trim().isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5FB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD8E2F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentExercise.contextTitle ?? 'Texto de apoyo',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(currentExercise.contextText!, style: const TextStyle(height: 1.35)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(currentExercise.prompt, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      ...currentExercise.options.map((option) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                selectedAnswers[currentIndex] = option.id;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Radio<String>(
                                    value: option.id,
                                    groupValue: selectedAnswers[currentIndex],
                                    onChanged: (value) {
                                      if (value == null) return;
                                      setState(() {
                                        selectedAnswers[currentIndex] = value;
                                      });
                                    },
                                  ),
                                  Expanded(child: Text(option.text)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_showValidationError)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: const Text(
                    'Debes responder todas las preguntas antes de finalizar.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: currentIndex > 0 ? () => setState(() => currentIndex--) : null,
                      child: const Text('Anterior'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final isCurrentAnswerMissing =
                            selectedAnswers[currentIndex] == null || selectedAnswers[currentIndex]!.isEmpty;

                        if (currentIndex < exercises.length - 1) {
                          if (isCurrentAnswerMissing) {
                            setState(() => _showValidationError = true);
                            return;
                          }

                          setState(() {
                            _showValidationError = false;
                            currentIndex++;
                          });
                          return;
                        }

                        final hasAnyMissingAnswer = selectedAnswers.any((answer) => answer == null || answer.isEmpty);
                        if (hasAnyMissingAnswer) {
                          setState(() => _showValidationError = true);
                          return;
                        }

                        setState(() => _showValidationError = false);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DelePracticeResultScreen(
                              exercises: exercises,
                              selectedAnswers: selectedAnswers,
                            ),
                          ),
                        );
                      },
                      child: Text(currentIndex < exercises.length - 1 ? 'Siguiente' : 'Finalizar'),
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
