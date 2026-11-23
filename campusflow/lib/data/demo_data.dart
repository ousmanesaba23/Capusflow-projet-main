import 'package:campusflow_models/campusflow_models.dart';

/// Données locales de démonstration, utilisées avant la connexion à l'API.
///
/// Les dates sont calculées par rapport à aujourd'hui pour que la liste
/// contienne toujours une tâche en retard, des tâches proches et une faite.
abstract final class DemoData {
  static const courses = <Course>[
    Course(
      id: 'mobile',
      name: 'Programmation mobile',
      teacher: 'M. Ouattara',
      room: 'Salle B12',
    ),
    Course(
      id: 'securite',
      name: 'Sécurité des SI',
      teacher: 'Mme Sawadogo',
      room: 'Amphi A',
    ),
    Course(
      id: 'projet',
      name: 'Gestion de projet',
      teacher: 'M. Traoré',
      room: 'Salle C04',
    ),
    Course(
      id: 'bdd',
      name: 'Bases de données avancées',
      teacher: 'Mme Kaboré',
      room: 'Labo 2',
    ),
  ];

  static const user = User(
    id: 'u1',
    name: 'Awa Ouédraogo',
    email: 'awa@campus.bf',
    program: 'Licence 3 Informatique',
  );

  static List<Task> tasks([DateTime? now]) {
    final today = now ?? DateTime.now();
    DateTime inDays(int days, [int hour = 23, int minute = 59]) =>
        DateTime(today.year, today.month, today.day + days, hour, minute);

    return [
      Task(
        id: '1',
        title: 'TP Flutter : écran Échéances',
        courseId: 'mobile',
        dueDate: inDays(1),
        description: 'Scaffold, AppBar, ListView.builder, bouton flottant '
            'et NavigationBar.',
      ),
      Task(
        id: '2',
        title: 'Exposé sécurité réseau',
        courseId: 'securite',
        dueDate: inDays(-1, 8, 0),
        description: 'Dix minutes sur les attaques par hameçonnage, '
            'avec deux exemples réels.',
      ),
      Task(
        id: '3',
        title: 'Lecture chapitre 4',
        courseId: 'projet',
        dueDate: inDays(3, 18, 0),
        done: true,
      ),
      Task(
        id: '4',
        title: 'Quiz Dart',
        courseId: 'mobile',
        dueDate: inDays(5, 10, 0),
        description: 'Révisions : async/await, Future, copyWith.',
      ),
      Task(
        id: '5',
        title: 'Projet base de données',
        courseId: 'bdd',
        dueDate: inDays(9),
      ),
    ];
  }

  static String courseName(String courseId) {
    for (final course in courses) {
      if (course.id == courseId) return course.name;
    }
    return 'Sans cours';
  }
}
