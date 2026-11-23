import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_colors.dart';
import 'package:campusflow/core/utils/dates.dart';
import 'helpers.dart';

void main() {
  setUpAll(Dates.init);

  testWidgets('l\'application démarre sur /login avec le logo et le thème', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(routeur(tester).state.uri.path, '/login');
    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.bySemanticsLabel('Logo CampusFlow'), findsOneWidget);
    final context = tester.element(find.text('CampusFlow'));
    expect(Theme.of(context).colorScheme.primary, AppColors.primary);
  });

  testWidgets('chaque écran est accessible par son adresse', (tester) async {
    await pumpApp(tester);
    await seConnecter(tester);
    expect(routeur(tester).state.uri.path, '/taches');

    await allerA(tester, '/cours');
    expect(find.text('Mes cours'), findsOneWidget);

    await allerA(tester, '/profil');
    expect(find.text('Awa Ouédraogo'), findsOneWidget);

    await allerA(tester, '/taches/nouvelle');
    expect(find.text('Nouvelle tâche'), findsOneWidget);

    // Le paramètre :id est lu pour ouvrir le détail.
    await allerA(tester, '/taches/4');
    expect(find.text('Détail de la tâche'), findsOneWidget);
    expect(find.text('Quiz Dart'), findsOneWidget);

    // Connecté, /login renvoie vers la liste.
    await allerA(tester, '/login');
    expect(routeur(tester).state.uri.path, '/taches');
  });

  testWidgets('la NavigationBar du ShellRoute change d\'écran', (tester) async {
    await pumpApp(tester);
    await seConnecter(tester);

    await tester.tap(find.text('Cours'));
    await tester.pumpAndSettle();
    expect(routeur(tester).state.uri.path, '/cours');

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(routeur(tester).state.uri.path, '/profil');
  });
}
