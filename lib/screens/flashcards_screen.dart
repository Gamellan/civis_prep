import 'package:flutter/material.dart';

import '../services/flashcard_service.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  late final Future<List<Flashcard>> _cardsFuture;
  final FlashcardService _flashcardService = FlashcardService();
  int _index = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _cardsFuture = _flashcardService.getDueFlashcards();
  }

  Future<void> _markMastery(String id, int level) async {
    await _flashcardService.updateMastery(id, level);
    setState(() {
      _cardsFuture = _flashcardService.getDueFlashcards();
      _index = 0;
      _showAnswer = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _cardsFuture = _flashcardService.getDueFlashcards();
      _index = 0;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _cardsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cards = snapshot.data!;
          if (cards.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 52, color: Colors.green),
                    const SizedBox(height: 12),
                    const Text('Todo está al día', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text('No tienes flashcards pendientes por revisar ahora.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text('Recargar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_index >= cards.length) {
            _index = 0;
          }

          final card = cards[_index];
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tarjeta ${_index + 1}/${cards.length}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(card.category, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F4C81))),
                        const SizedBox(height: 12),
                        Text(_showAnswer ? card.back : card.front, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _showAnswer = !_showAnswer),
                  child: Text(_showAnswer ? 'Ocultar respuesta' : 'Mostrar respuesta'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showAnswer = false;
                            _index = (_index + 1) % cards.length;
                          });
                        },
                        child: const Text('Siguiente'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _markMastery(card.id, card.masteryLevel + 1);
                        },
                        child: const Text('Marcar como recordada'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
