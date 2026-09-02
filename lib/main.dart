import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/app_storage_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CivisPrepApp();
  }
}

class CivisPrepApp extends StatefulWidget {
  const CivisPrepApp({super.key});

  @override
  State<CivisPrepApp> createState() => _CivisPrepAppState();
}

class _CivisPrepAppState extends State<CivisPrepApp> {
  Locale _locale = AppLocalizations.localeFromDevice(
    WidgetsBinding.instance.platformDispatcher.locale,
  );
  final AppStorageService _storage = AppStorageService();

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocaleCode = await _storage.getString(appLocaleStorageKey());
    if (!mounted) return;

    if (savedLocaleCode != null && savedLocaleCode.isNotEmpty) {
      setState(() {
        _locale = AppLocalizations.localeFromCode(savedLocaleCode);
      });
      return;
    }
  }

  Future<void> _setLocale(Locale locale) async {
    await _storage.setString(appLocaleStorageKey(), locale.languageCode);
    if (!mounted) return;
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      locale: _locale,
      setLocale: _setLocale,
      child: MaterialApp(
        title: AppLocalizations(_locale).translate('appTitle'),
        locale: _locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F4C81)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
