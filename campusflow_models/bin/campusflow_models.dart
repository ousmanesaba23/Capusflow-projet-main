import 'package:campusflow_models/campusflow_models.dart';

/// Démo de la séance 3 : async / await et try / catch, sans réseau.
Future<void> main(List<String> arguments) async {
  final repository = FakeCampusRepository();

  print('Chargement de l\'utilisateur et des tâches…');
  try {
    final user = await repository.fetchCurrentUser();
    final tasks = await repository.fetchTasks();
    print('Bonjour ${user.name} (${user.program}) : ${tasks.length} tâches');
    for (final task in tasks) {
      print('  - ${task.title} [${task.done ? 'faite' : 'à faire'}]');
    }

    // Immuabilité : « cocher » une tâche crée une copie.
    final first = tasks.first;
    final checked = first.copyWith(done: true);
    print('copyWith : ${first.done} -> ${checked.done}');

    // Erreur attendue : identifiant inconnu.
    await repository.fetchTaskById('999');
  } on TaskNotFoundException catch (error) {
    print('Erreur attendue : $error');
  }

  // Erreur réseau simulée.
  try {
    await FakeCampusRepository(offline: true).fetchTasks();
  } on NetworkException catch (error) {
    print('Erreur réseau gérée : $error');
  }
}
