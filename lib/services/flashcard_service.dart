import 'dart:convert';

import 'app_storage_service.dart';

class Flashcard {
  final String id;
  final String front;
  final String back;
  final String category;
  final int masteryLevel;
  final DateTime? nextReviewAt;

  const Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.category,
    required this.masteryLevel,
    this.nextReviewAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'front': front,
        'back': back,
        'category': category,
        'masteryLevel': masteryLevel,
        'nextReviewAt': nextReviewAt?.toIso8601String(),
      };

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    final rawDate = json['nextReviewAt'];
    return Flashcard(
      id: json['id'] as String,
      front: json['front'] as String,
      back: json['back'] as String,
      category: json['category'] as String,
      masteryLevel: json['masteryLevel'] as int? ?? 0,
      nextReviewAt: rawDate == null ? null : DateTime.tryParse(rawDate.toString()),
    );
  }
}

class FlashcardService {
  static const String _storageKey = 'flashcards';
  final AppStorageService _storage = AppStorageService();

  Future<List<Flashcard>> getFlashcards() async {
    final raw = await _storage.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return _defaultFlashcards();
    }

    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((item) => Flashcard.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return _defaultFlashcards();
  }

  Future<List<Flashcard>> getDueFlashcards() async {
    final cards = await getFlashcards();
    final now = DateTime.now();
    return cards.where((card) => card.nextReviewAt == null || !card.nextReviewAt!.isAfter(now)).toList();
  }

  Future<void> saveFlashcards(List<Flashcard> flashcards) async {
    await _storage.setString(_storageKey, jsonEncode(flashcards.map((card) => card.toJson()).toList()));
  }

  Future<void> updateMastery(String id, int nextLevel) async {
    final flashcards = await getFlashcards();
    final updated = flashcards.map((card) {
      if (card.id == id) {
        final nextReview = _getNextReviewDate(nextLevel);
        return Flashcard(
          id: card.id,
          front: card.front,
          back: card.back,
          category: card.category,
          masteryLevel: nextLevel,
          nextReviewAt: nextReview,
        );
      }
      return card;
    }).toList();
    await saveFlashcards(updated);
  }

  DateTime _getNextReviewDate(int masteryLevel) {
    final now = DateTime.now();
    switch (masteryLevel) {
      case 1:
        return now.add(const Duration(days: 1));
      case 2:
        return now.add(const Duration(days: 3));
      case 3:
        return now.add(const Duration(days: 7));
      default:
        return now.add(const Duration(days: 14));
    }
  }

  List<Flashcard> _defaultFlashcards() {
    final now = DateTime.now();
    return [
      Flashcard(
        id: 'flash-01',
        front: '¿Qué función tienen las Cortes Generales?',
        back: 'Aprobar leyes y controlar la acción del Gobierno.',
        category: 'CCSE',
        masteryLevel: 0,
        nextReviewAt: now,
      ),
      Flashcard(
        id: 'flash-02',
        front: '¿Qué es el municipio?',
        back: 'La entidad local básica de la organización territorial española.',
        category: 'CCSE',
        masteryLevel: 0,
        nextReviewAt: now,
      ),
      Flashcard(
        id: 'flash-03',
        front: '¿Qué significa “tener prisa”?',
        back: 'Tener poca tiempo y actuar con urgencia.',
        category: 'DELE',
        masteryLevel: 0,
        nextReviewAt: now,
      ),
      Flashcard(
        id: 'flash-04',
        front: '¿Cuál es la capital de España?',
        back: 'Madrid.',
        category: 'CCSE',
        masteryLevel: 0,
        nextReviewAt: now,
      ),
    ];
  }
}
