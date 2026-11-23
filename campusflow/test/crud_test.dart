import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/utils/dates.dart';
import 'package:campusflow/core/widgets/etats.dart';
import 'package:campusflow/data/repositories/fake_task_repository.dart';
import 'helpers.dart';

void main() {
  setUpAll(Dates.init);

  testWidgets('état chargement puis données', (tester) async {
    await pumpApp(
      tester,
      taches: FakeTaskRepository(latency: const Duration(seconds: 1)),
    );
    await seConnecter(tester, settle: false);
    // Une frame pour la navigation, puis 300 ms : la réponse n'est pas arrivée.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ChargementView), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(ChargementView), findsNothing);
    expect(find.text('Quiz Dart'), findsOneWidget);
  });

  testWidgets('état erreur avec bouton Réessayer', (tester) async {
    final repository = FakeTaskRepository()..failNext = true;
    await pumpApp(tester, taches: repository);
    await seConnecter(tester);

    expect(find.byType(ErreurView), findsOneWidget);
    expect(find.text('Serveur injoignable. Vérifiez votre connexion.'),
        findsOneWidget);

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();
    expect(find.byType(ErreurView), findsNothing);
    expect(find.text('Quiz Dart'), findsOneWidget);
  });

  testWidgets('création : POST puis affichage de la tâche du serveur', (
    tester,
  ) async {
    final repository = await pumpApp(tester);
    await seConnecter(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Fiche de lecture');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.text('Fiche de lecture'), findsOneWidget);
    final created = repository.tasks.singleWhere(
      (t) => t.title == 'Fiche de lecture',
    );
    expect(created.id, isNotEmpty, reason: 'id attribué par le serveur');
  });

  testWidgets('cocher : PATCH envoyé au repository', (tester) async {
    final repository = await pumpApp(tester);
    await seConnecter(tester);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(repository.tasks.singleWhere((t) => t.id == '2').done, isTrue);
    expect(find.text('Faites (2)'), findsOneWidget);
  });

  testWidgets('supprimer : DELETE après confirmation', (tester) async {
    final repository = await pumpApp(tester);
    await seConnecter(tester);

    await tester.tap(find.text('Quiz Dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Supprimer'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Supprimer'));
    await tester.pumpAndSettle();

    expect(find.text('Quiz Dart'), findsNothing);
    expect(find.text('Tâche supprimée'), findsOneWidget);
    expect(repository.tasks.where((t) => t.id == '4'), isEmpty);
  });

  testWidgets('une erreur pendant une action affiche un message', (
    tester,
  ) async {
    final repository = await pumpApp(tester);
    await seConnecter(tester);

    repository.failNext = true;
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(find.text('Serveur injoignable. Vérifiez votre connexion.'),
        findsOneWidget);
    expect(repository.tasks.singleWhere((t) => t.id == '2').done, isFalse);
  });
}
