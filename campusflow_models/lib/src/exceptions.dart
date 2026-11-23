/// Levée quand aucune tâche ne correspond à l'identifiant demandé.
class TaskNotFoundException implements Exception {
  const TaskNotFoundException(this.id);

  final String id;

  @override
  String toString() => 'TaskNotFoundException : aucune tâche avec l\'id "$id"';
}

/// Levée quand le réseau (simulé) est indisponible.
class NetworkException implements Exception {
  const NetworkException([this.message = 'Réseau indisponible']);

  final String message;

  @override
  String toString() => 'NetworkException : $message';
}
