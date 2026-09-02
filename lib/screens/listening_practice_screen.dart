import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'dele_practice_screen.dart';

class ListeningPracticeScreen extends StatelessWidget {
  const ListeningPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final steps = [
      strings.translate('listeningStep1'),
      strings.translate('listeningStep2'),
      strings.translate('listeningStep3'),
      strings.translate('listeningStep4'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(strings.translate('comprehensionAuditory'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.translate('practiceSimplified'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(strings.translate('audioNoteBody')),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F4C81).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded, color: Color(0xFF0F4C81)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Nota: por ahora esta práctica se trabaja con texto y contexto. Para reforzar el audio, conviene practicar con un hispanohablante o repetir los modelos orales en voz alta.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(strings.translate('practiceGuide'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...steps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, color: Color(0xFF0F4C81)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(step)),
                    ],
                  ),
                )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DelePracticeScreen(section: 'Comprensión auditiva')),
                  );
                },
                child: Text(strings.translate('startListeningExercises')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
