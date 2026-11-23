import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/utils/dates.dart';
import 'helpers.dart';

void main() {
  setUpAll(Dates.init);

  testWidgets('la connexion ouvre la liste des échéances', (tester) async {
    await pumpApp(tester);
    await seConnecter(tester);

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Exposé sécurité réseau'), findsOneWidget);
    expect(find.text('En retard'), findsOneWidget);
  });

  testWidgets('cocher une tâche la marque comme faite', (tester) async {
    await pumpApp(tester);
    await seConnecter(tester);

    // Filtre « À faire » par défaut : la tâche cochée quitte la liste.
    expect(find.text('Exposé sécurité réseau'), findsOneWidget);
    expect(find.text('Faites (1)'), findsOneWidget);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text('Exposé sécurité réseau'), findsNothing);
    expect(find.text('Faites (2)'), findsOneWidget);
  });

  testWidgets('le détail marque une tâche comme faite', (tester) async {
    await pumpApp(tester);
    await seConnecter(tester);

    await tester.tap(find.text('Quiz Dart'));
    await tester.pumpAndSettle();
    expect(find.text('Détail de la tâche'), findsOneWidget);

    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();
    expect(find.text('Faite'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
