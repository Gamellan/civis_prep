import 'package:civis_prep/screens/dele_practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DELE practice blocks completion until every question is answered', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DelePracticeScreen(section: 'Comprensión de lectura'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Siguiente'), findsOneWidget);

    await tester.tap(find.text('Siguiente'));
    await tester.pump();

    expect(find.text('Debes responder todas las preguntas antes de finalizar.'), findsOneWidget);
  });
}
