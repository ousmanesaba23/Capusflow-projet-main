import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/router/app_router.dart';
import 'package:campusflow/core/storage/token_storage.dart';
import 'package:campusflow/data/repositories/auth_repository.dart';
import 'package:campusflow/data/repositories/course_repository.dart';
import 'package:campusflow/data/repositories/fake_task_repository.dart';
import 'package:campusflow/data/repositories/task_repository.dart';
import 'package:campusflow/main.dart';

/// Lance l'application dans un ProviderScope neuf, avec des implémentations
/// en mémoire à la place de l'API et du stockage sécurisé (aucun réseau,
/// aucun plugin natif pendant les tests).
Future<FakeTaskRepository> pumpApp(
  WidgetTester tester, {
  FakeTaskRepository? taches,
  MemoryTokenStorage? stockage,
  bool settle = true,
}) async {
  final repository = taches ?? FakeTaskRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(repository),
        courseRepositoryProvider.overrideWithValue(
          const FakeCourseRepository(),
        ),
        authRepositoryProvider.overrideWithValue(const FakeAuthRepository()),
        tokenStorageProvider.overrideWithValue(
          stockage ?? MemoryTokenStorage(),
        ),
      ],
      child: const CampusFlowApp(),
    ),
  );
  if (settle) await tester.pumpAndSettle();
  return repository;
}

/// Remplit le formulaire de connexion et ouvre la liste des échéances.
Future<void> seConnecter(
  WidgetTester tester, {
  String motDePasse = FakeAuthRepository.password,
  bool settle = true,
}) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'awa@campus.bf');
  await tester.enterText(find.byType(TextFormField).at(1), motDePasse);
  await tester.tap(find.text('Se connecter'));
  if (settle) await tester.pumpAndSettle();
}

/// Navigue directement vers une adresse, comme un lien profond.
Future<void> allerA(WidgetTester tester, String location) async {
  routeur(tester).go(location);
  await tester.pumpAndSettle();
}

/// Le conteneur Riverpod de l'application.
ProviderContainer conteneur(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(CampusFlowApp)));

/// Le routeur actuellement utilisé par l'application.
GoRouter routeur(WidgetTester tester) =>
    conteneur(tester).read(routerProvider);
