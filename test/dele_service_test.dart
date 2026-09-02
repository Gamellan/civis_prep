import 'package:civis_prep/services/dele_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeleService', () {
    test('loads a broad DELE A2 bank with unique exercises for every official section', () async {
      final service = DeleService();
      final allExercises = await service.getExercises();
      expect(allExercises.length, greaterThanOrEqualTo(120));

      final ids = allExercises.map((exercise) => exercise.id).toList();
      expect(ids.length, equals(ids.toSet().length), reason: 'DELE exercise IDs must be unique.');

      final prompts = allExercises.map((exercise) => exercise.prompt.trim()).toList();
      expect(prompts.length, equals(prompts.toSet().length), reason: 'DELE prompts must be unique across the bank.');
      expect(allExercises.length, greaterThanOrEqualTo(100), reason: 'The DELE bank should be larger than a small repeated set.');

      final sections = [
        'Comprensión de lectura',
        'Expresión e interacción escritas',
        'Comprensión auditiva',
        'Expresión e interacción orales',
      ];

      for (final section in sections) {
        final sectionExercises = await service.getExercisesBySection(section, limit: 25);
        expect(sectionExercises.length, equals(25), reason: 'Section $section should provide a discrete unique practice set.');

        final sectionIds = sectionExercises.map((exercise) => exercise.id).toList();
        expect(sectionIds.length, equals(sectionIds.toSet().length), reason: 'Section $section contains duplicate exercise IDs.');

        final sectionPrompts = sectionExercises.map((exercise) => exercise.prompt.trim()).toList();
        expect(sectionPrompts.length, equals(sectionPrompts.toSet().length), reason: 'Section $section contains duplicate prompts.');
      }

      final readingExercises = await service.getExercisesBySection('Comprensión de lectura');
      expect(
        readingExercises.where((exercise) => (exercise.contextText ?? '').trim().isNotEmpty).length,
        greaterThanOrEqualTo(25),
        reason: 'Reading exercises should include supporting text to read.',
      );

      final allOptionOrders = allExercises
          .map((exercise) => exercise.options.map((option) => option.id).join(','))
          .toSet();
      expect(allOptionOrders.length, greaterThanOrEqualTo(10), reason: 'Options should be shuffled across exercises.');
    });
  });
}
