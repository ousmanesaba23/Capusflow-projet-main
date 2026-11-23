import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow/core/storage/token_storage.dart';
import 'package:campusflow/core/utils/dates.dart';
import 'package:campusflow/data/demo_data.dart';
import 'package:campusflow/data/repositories/auth_repository.dart';
import 'package:campusflow/data/repositories/fake_task_repository.dart';
import 'package:campusflow/data/repositories/task_repository.dart';
import 'package:campusflow/features/auth/auth_notifier.dart';
import 'package:campusflow/features/taches/filtres.dart';
import 'package:campusflow/features/taches/taches_notifier.dart';
import 'helpers.dart';

void main() {
  setUpAll(Dates.init);

  test('le fournisseur dérivé recalcule les filtres quand la liste change', () async {
    final container = ProviderContainer(
      overrides: [
        taskRepositoryProvider.overrideWithValue(FakeTaskRepository()),
        tokenStorageProvider.overrideWithValue(
          MemoryTokenStorage()
            ..token = 'jeton'
            ..user = Session.encodeUser(DemoData.user),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authProvider.future);
    await container.read(tachesProvider.future);

    Map<FiltreTaches, int> compter() => {
      for (final e in container.read(tachesParFiltreProvider).entries)
        e.key: e.value.length,
    };

    expect(compter(), {
      FiltreTaches.aFaire: 4,
      FiltreTaches.enRetard: 1,
      FiltreTaches.faites: 1,
    });

    // Cocher la tâche en retard (id 2) : elle passe dans « Faites ».
    await container.read(tachesProvider.notifier).basculer('2');
    expect(compter(), {
      FiltreTaches.aFaire: 3,
      FiltreTaches.enRetard: 0,
      FiltreTaches.faites: 2,
    });
  });

  testWidgets('les puces de filtre changent la liste affichée', (tester) async {
    await pumpApp(tester);
    await seConnecter(tester);

    expect(find.text('À faire (4)'), findsOneWidget);
    expect(find.text('Lecture chapitre 4'), findsNothing);

    await tester.tap(find.text('Faites (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Lecture chapitre 4'), findsOneWidget);
    expect(find.text('Quiz Dart'), findsNothing);

    await tester.tap(find.text('En retard (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Exposé sécurité réseau'), findsOneWidget);
    expect(find.text('Quiz Dart'), findsNothing);
  });
}
