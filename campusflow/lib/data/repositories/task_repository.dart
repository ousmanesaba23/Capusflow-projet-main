import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusflow/core/network/dio_client.dart';
import 'api_task_repository.dart';

/// Contrat d'accès aux tâches. Les écrans et l'état ne dépendent que de ce
/// contrat, jamais de Dio ni de l'implémentation.
abstract interface class TaskRepository {
  Future<List<Task>> fetchAll();

  /// Crée la tâche sur le serveur et renvoie la version enregistrée
  /// (avec l'identifiant attribué par le serveur).
  Future<Task> create(Task draft);

  Future<Task> setDone(String id, {required bool done});

  Future<void> delete(String id);
}

/// Implémentation utilisée par l'application ; les tests la remplacent par
/// `FakeTaskRepository` avec `overrideWithValue`.
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return ApiTaskRepository(ref.watch(dioProvider));
});
