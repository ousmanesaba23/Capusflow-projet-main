import 'package:campusflow_models/campusflow_models.dart';

import 'package:campusflow/core/network/dio_client.dart';
import 'package:campusflow/data/demo_data.dart';
import 'task_repository.dart';

/// Tâches en mémoire, pour les tests (aucun réseau).
class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository({
    List<Task>? initial,
    this.latency = Duration.zero,
  }) : _tasks = initial ?? DemoData.tasks();

  List<Task> _tasks;
  int _nextId = 100;

  /// Attente simulée avant chaque réponse.
  final Duration latency;

  /// Si vrai, le prochain appel échoue (pour tester l'état d'erreur).
  bool failNext = false;

  /// Nombre d'appels reçus, pour vérifier les interactions dans les tests.
  int calls = 0;

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> _simulate() async {
    calls++;
    await Future<void>.delayed(latency);
    if (failNext) {
      failNext = false;
      throw const ApiException('Serveur injoignable. Vérifiez votre connexion.');
    }
  }

  @override
  Future<List<Task>> fetchAll() async {
    await _simulate();
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> create(Task draft) async {
    await _simulate();
    final created = draft.copyWith(id: '${_nextId++}');
    _tasks = [..._tasks, created];
    return created;
  }

  @override
  Future<Task> setDone(String id, {required bool done}) async {
    await _simulate();
    final current = _tasks.where((t) => t.id == id).firstOrNull;
    if (current == null) {
      throw const ApiException('Élément introuvable sur le serveur.');
    }
    final updated = current.copyWith(done: done);
    _tasks = [for (final t in _tasks) t.id == id ? updated : t];
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _simulate();
    _tasks = [for (final t in _tasks) if (t.id != id) t];
  }
}
