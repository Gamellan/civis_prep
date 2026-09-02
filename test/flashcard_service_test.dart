import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:civis_prep/services/flashcard_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('FlashcardService', () {
    test('guarda y actualiza el nivel de dominio de una tarjeta', () async {
      final service = FlashcardService();
      final cards = await service.getFlashcards();
      expect(cards.isNotEmpty, isTrue);

      await service.updateMastery(cards.first.id, 2);
      final updated = await service.getFlashcards();
      final card = updated.firstWhere((item) => item.id == cards.first.id);

      expect(card.masteryLevel, 2);
    });

    test('programa la próxima revisión y devuelve tarjetas pendientes', () async {
      final service = FlashcardService();
      final cards = await service.getFlashcards();
      final card = cards.first;

      await service.updateMastery(card.id, 3);

      final updated = await service.getFlashcards();
      final refreshed = updated.firstWhere((item) => item.id == card.id);
      final due = await service.getDueFlashcards();

      expect(refreshed.masteryLevel, 3);
      expect(refreshed.nextReviewAt, isNotNull);
      expect(refreshed.nextReviewAt!.isAfter(DateTime.now()), isTrue);
      expect(due.isNotEmpty, isTrue);
    });
  });
}
