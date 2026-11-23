import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/utils/dates.dart';
import 'helpers.dart';

Future<void> _ouvrirFormulaire(WidgetTester tester) async {
  await pumpApp(tester);
  await seConnecter(tester);
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(Dates.init);

  testWidgets('le validator refuse un titre vide', (tester) async {
    await _ouvrirFormulaire(tester);

    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    expect(find.text('Le titre est obligatoire'), findsOneWidget);
    expect(find.text('Nouvelle tâche'), findsOneWidget);
  });

  testWidgets('une tâche valide est ajoutée avec un SnackBar', (tester) async {
    await _ouvrirFormulaire(tester);

    await tester.enterText(find.byType(TextFormField).first, 'Fiche de lecture');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Fiche de lecture'), findsOneWidget);
  });
}
