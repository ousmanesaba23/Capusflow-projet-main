import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/utils/dates.dart';
import 'helpers.dart';

void main() {
  setUpAll(Dates.init);

  testWidgets('une tâche cochée dans le détail est cochée dans la liste', (
    tester,
  ) async {
    await pumpApp(tester);
    await seConnecter(tester);

    await tester.tap(find.text('Quiz Dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();

    // Le détail se met à jour immédiatement…
    expect(find.text('Marquer comme à faire'), findsOneWidget);

    // … et la liste aussi, au retour : la tâche est passée dans « Faites ».
    routeur(tester).pop();
    await tester.pumpAndSettle();
    expect(find.text('Quiz Dart'), findsNothing);
    expect(find.text('Faites (2)'), findsOneWidget);
  });

  testWidgets('une tâche ajoutée apparaît dans la liste et dans les cours', (
    tester,
  ) async {
    await pumpApp(tester);
    await seConnecter(tester);

    await allerA(tester, '/cours');
    expect(find.textContaining('2 tâches à faire'), findsOneWidget);

    await allerA(tester, '/taches');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Fiche de lecture');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.text('Fiche de lecture'), findsOneWidget);

    // Le cours par défaut du formulaire est « Programmation mobile ».
    await allerA(tester, '/cours');
    expect(find.textContaining('3 tâches à faire'), findsOneWidget);
  });
}
