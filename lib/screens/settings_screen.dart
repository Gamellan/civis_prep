import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(strings.translate('credits'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.translate('creditsContentTitle'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(strings.translate('creditsContentBody')),
              const SizedBox(height: 16),
              Text(
                strings.translate('creditsNoticeTitle'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(strings.translate('creditsNoticeBody')),
              const SizedBox(height: 16),
              Text(
                strings.translate('creditsScopeTitle'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(strings.translate('creditsScopeBody')),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeScope = AppLocaleScope.of(context);
    final strings = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(strings.translate('settings'))),
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
                      strings.translate('studyRhythm'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(strings.translate('studyRhythmDescription')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: localeScope.locale.languageCode,
              decoration: InputDecoration(
                labelText: strings.translate('language'),
              ),
              items: AppLocalizations.supportedLocales
                  .map(
                    (locale) => DropdownMenuItem<String>(
                      value: locale.languageCode,
                      child: Text(
                        AppLocalizations(
                          locale,
                        ).getLanguageName(locale.languageCode),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (code) {
                if (code == null) return;
                localeScope.setLocale(AppLocalizations.localeFromCode(code));
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(strings.translate('credits')),
              subtitle: Text(strings.translate('creditsSubtitle')),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreditsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
