import 'course.dart';
import 'exceptions.dart';
import 'task.dart';
import 'user.dart';

/// Dépôt simulé : il renvoie des données après une attente produite par
/// [Future.delayed], comme le ferait un vrai serveur, mais sans réseau.
///
/// Les données sont stockées sous forme de documents JSON et converties avec
/// les méthodes `fromJson` des modèles.
class FakeCampusRepository {
  FakeCampusRepository({
    this.latency = const Duration(milliseconds: 600),
    this.offline = false,
  });

  /// Durée de l'attente simulée (mettre [Duration.zero] dans les tests).
  final Duration latency;

  /// Si vrai, chaque appel échoue avec une [NetworkException].
  final bool offline;

  static const List<Map<String, dynamic>> _tasksJson = [
    {
      'id': '1',
      'title': 'TP Flutter : écran Échéances',
      'courseId': 'mobile',
      'dueDate': '2026-11-27T23:59:00',
      'description': 'Scaffold, ListView.builder et NavigationBar.',
      'done': false,
    },
    {
      'id': '2',
      'title': 'Exposé sécurité réseau',
      'courseId': 'securite',
      'dueDate': '2026-11-20T08:00:00',
      'description': 'Dix minutes sur les attaques par hameçonnage.',
      'done': false,
    },
    {
      'id': '3',
      'title': 'Lecture chapitre 4',
      'courseId': 'projet',
      'dueDate': '2026-11-29T18:00:00',
      'done': true,
    },
    {
      'id': '4',
      'title': 'Quiz Dart',
      'courseId': 'mobile',
      'dueDate': '2026-12-03T10:00:00',
      'done': false,
    },
  ];

  static const List<Map<String, dynamic>> _coursesJson = [
    {
      'id': 'mobile',
      'name': 'Programmation mobile',
      'teacher': 'M. Ouattara',
      'room': 'Salle B12',
    },
    {
      'id': 'securite',
      'name': 'Sécurité des SI',
      'teacher': 'Mme Sawadogo',
      'room': 'Amphi A',
    },
    {
      'id': 'projet',
      'name': 'Gestion de projet',
      'teacher': 'M. Traoré',
      'room': 'Salle C04',
    },
  ];

  static const Map<String, dynamic> _userJson = {
    'id': 'u1',
    'name': 'Awa Ouédraogo',
    'email': 'awa@campus.bf',
    'program': 'Licence 3 Informatique',
  };

  Future<List<Task>> fetchTasks() async {
    await _simulateNetwork();
    return _tasksJson.map(Task.fromJson).toList();
  }

  /// Lève une [TaskNotFoundException] si l'identifiant est inconnu.
  Future<Task> fetchTaskById(String id) async {
    final tasks = await fetchTasks();
    for (final task in tasks) {
      if (task.id == id) return task;
    }
    throw TaskNotFoundException(id);
  }

  Future<List<Course>> fetchCourses() async {
    await _simulateNetwork();
    return _coursesJson.map(Course.fromJson).toList();
  }

  Future<User> fetchCurrentUser() async {
    await _simulateNetwork();
    return User.fromJson(_userJson);
  }

  Future<void> _simulateNetwork() async {
    await Future<void>.delayed(latency);
    if (offline) throw const NetworkException();
  }
}
