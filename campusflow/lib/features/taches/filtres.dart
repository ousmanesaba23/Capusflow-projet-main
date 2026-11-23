import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'taches_notifier.dart';

enum FiltreTaches {
  aFaire('À faire'),
  enRetard('En retard'),
  faites('Faites');

  const FiltreTaches(this.libelle);
  final String libelle;
}

/// Filtre choisi sur l'écran des échéances.
class FiltreNotifier extends Notifier<FiltreTaches> {
  @override
  FiltreTaches build() => FiltreTaches.aFaire;

  void choisir(FiltreTaches filtre) => state = filtre;
}

final filtreProvider = NotifierProvider<FiltreNotifier, FiltreTaches>(
  FiltreNotifier.new,
);

/// Fournisseur dérivé : les trois filtres sont recalculés automatiquement
/// dès que la liste des tâches change.
final tachesParFiltreProvider = Provider<Map<FiltreTaches, List<Task>>>((ref) {
  final tasks = ref.watch(tachesProvider).value ?? const <Task>[];
  final now = DateTime.now();
  return {
    FiltreTaches.aFaire: [for (final t in tasks) if (!t.done) t],
    FiltreTaches.enRetard: [for (final t in tasks) if (t.isOverdue(now)) t],
    FiltreTaches.faites: [for (final t in tasks) if (t.done) t],
  };
});

/// Les tâches du filtre sélectionné.
final tachesFiltreesProvider = Provider<List<Task>>((ref) {
  final filtre = ref.watch(filtreProvider);
  return ref.watch(tachesParFiltreProvider)[filtre]!;
});
