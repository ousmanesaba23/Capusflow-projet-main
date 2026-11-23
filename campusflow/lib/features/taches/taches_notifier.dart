import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusflow/data/repositories/task_repository.dart';
import 'package:campusflow/features/auth/auth_notifier.dart';

/// État partagé et asynchrone : la liste des tâches vient de l'API.
///
/// L'écran affiche trois états : chargement, erreur (avec « Réessayer »)
/// et données. Chaque action appelle le repository puis assigne une
/// **nouvelle** liste à `state` (immuabilité, comme à la séance 6).
class TachesNotifier extends AsyncNotifier<List<Task>> {
  TaskRepository get _repository => ref.read(taskRepositoryProvider);

  @override
  Future<List<Task>> build() async {
    // Recharge automatiquement à chaque connexion / déconnexion.
    if (ref.watch(jetonProvider) == null) return const [];
    final tasks = await ref.watch(taskRepositoryProvider).fetchAll();
    return _trier(tasks);
  }

  /// Recharge depuis le serveur en affichant l'état de chargement.
  Future<void> recharger() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => _trier(await _repository.fetchAll()),
    );
  }

  /// POST /taches
  Future<void> ajouter(Task draft) async {
    final created = await _repository.create(draft);
    state = AsyncData(_trier([..._courant, created]));
  }

  /// PATCH /taches/:id
  Future<void> basculer(String id) async {
    final task = _courant.where((t) => t.id == id).firstOrNull;
    if (task == null) return;
    final updated = await _repository.setDone(id, done: !task.done);
    state = AsyncData([
      for (final t in _courant) t.id == id ? updated : t,
    ]);
  }

  /// DELETE /taches/:id
  Future<void> supprimer(String id) async {
    await _repository.delete(id);
    state = AsyncData([
      for (final t in _courant)
        if (t.id != id) t,
    ]);
  }

  List<Task> get _courant => state.value ?? const [];

  static List<Task> _trier(List<Task> tasks) =>
      [...tasks]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
}

/// `retry: null` désactive les nouvelles tentatives automatiques de Riverpod :
/// en cas d'erreur, c'est l'étudiant qui choisit de réessayer.
final tachesProvider = AsyncNotifierProvider<TachesNotifier, List<Task>>(
  TachesNotifier.new,
  retry: (_, _) => null,
);

/// Une tâche à partir de son identifiant (null si absente ou pas chargée).
final tacheParIdProvider = Provider.family<Task?, String>((ref, id) {
  final tasks = ref.watch(tachesProvider).value ?? const [];
  return tasks.where((t) => t.id == id).firstOrNull;
});
