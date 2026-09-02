import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:civis_prep/main.dart';

void main() {
  testWidgets(
    'home screen shows the two main exam options and a study summary',
    (WidgetTester tester) async {
      tester.platformDispatcher.localeTestValue = const Locale('es');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Comenzar ya'), findsOneWidget);
      expect(find.text('CCSE'), findsOneWidget);
      expect(find.text('DELE A2'), findsOneWidget);
      expect(find.text('Plan de estudio'), findsOneWidget);
      expect(find.text('Iniciar simulacro rápido'), findsOneWidget);
      expect(find.text('Resumen de estudio'), findsOneWidget);
    },
  );
}
