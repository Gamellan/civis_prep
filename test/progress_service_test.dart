import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:civis_prep/services/progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('ProgressService', () {
    test('registra respuestas correctamente y calcula métricas simples', () async {
      final service = ProgressService();
      await service.reset();

      await service.recordAnswer(
        exam: 'CCSE',
        topic: 'Gobierno, legislación y participación ciudadana',
        isCorrect: true,
      );
      await service.recordAnswer(
        exam: 'CCSE',
        topic: 'Gobierno, legislación y participación ciudadana',
        isCorrect: false,
      );
      await service.recordAnswer(
        exam: 'DELE',
        topic: 'Comprensión de lectura',
        isCorrect: true,
      );

      final stats = await service.getStats();

      expect(stats.totalAnswers, 3);
      expect(stats.correctAnswers, 2);
      expect(stats.incorrectAnswers, 1);
      expect(stats.overallAccuracy, closeTo(66.7, 0.1));
      expect(stats.topicStats.length, 2);
    });

    test('genera un dashboard con tema más débil y cuenta de temas dominados', () async {
      final service = ProgressService();
      await service.reset();

      await service.recordAnswer(exam: 'CCSE', topic: 'Gobierno', isCorrect: true);
      await service.recordAnswer(exam: 'CCSE', topic: 'Gobierno', isCorrect: true);
      await service.recordAnswer(exam: 'CCSE', topic: 'Gobierno', isCorrect: false);
      await service.recordAnswer(exam: 'CCSE', topic: 'Derechos', isCorrect: false);
      await service.recordAnswer(exam: 'CCSE', topic: 'Derechos', isCorrect: false);

      final dashboard = await service.getDashboard();

      expect(dashboard.totalAnswers, 5);
      expect(dashboard.masteredTopics, 0);
      expect(dashboard.weakestTopic.topic, 'Derechos');
      expect(dashboard.overallAccuracy, closeTo(40.0, 0.1));
      expect(dashboard.topicStats.isNotEmpty, isTrue);
    });
  });
}
