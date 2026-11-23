import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/utils/dates.dart';
import 'package:campusflow/features/taches/widgets/detail_tache_view.dart';
import 'helpers.dart';

Future<void> _ouvrirListe(WidgetTester tester, Size taille) async {
  tester.view.physicalSize = taille;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await pumpApp(tester);
  await seConnecter(tester);
}

void main() {
  setUpAll(Dates.init);

  testWidgets('au-dessus de 840 dp : liste et détail côte à côte', (
    tester,
  ) async {
    await _ouvrirListe(tester, const Size(1280, 800));

    expect(
      find.text('Sélectionnez une tâche pour voir son détail'),
      findsOneWidget,
    );

    await tester.tap(find.text('Quiz Dart'));
    await tester.pumpAndSettle();

    // Le détail s'affiche à droite, sans ouvrir de nouvel écran.
    expect(find.byType(DetailTacheView), findsOneWidget);
    expect(find.text('Détail de la tâche'), findsNothing);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('en dessous de 840 dp : la liste seule', (tester) async {
    await _ouvrirListe(tester, const Size(400, 800));

    expect(find.byType(DetailTacheView), findsNothing);
    expect(
      find.text('Sélectionnez une tâche pour voir son détail'),
      findsNothing,
    );
  });
}
