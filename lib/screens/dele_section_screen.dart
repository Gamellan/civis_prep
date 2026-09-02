import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/exam_catalog.dart';
import 'dele_practice_screen.dart';

class DeleSectionScreen extends StatelessWidget {
  const DeleSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(strings.translate('sectionTitle'))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ExamCatalog.deleSections.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(ExamCatalog.deleSections[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DelePracticeScreen(section: ExamCatalog.deleSections[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
