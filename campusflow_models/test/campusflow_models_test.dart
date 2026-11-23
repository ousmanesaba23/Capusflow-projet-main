import 'package:campusflow_models/campusflow_models.dart';
import 'package:test/test.dart';

void main() {
  test('copyWith crée une copie modifiée sans changer l\'original', () {
    final original = Task(
      id: '1',
      title: 'TP Flutter : écran Échéances',
      courseId: 'mobile',
      dueDate: DateTime(2026, 11, 27, 23, 59),
    );

    final copie = original.copyWith(done: true);

    expect(copie.done, isTrue);
    expect(copie.title, original.title);
    expect(copie.dueDate, original.dueDate);
    expect(original.done, isFalse, reason: 'l\'original est immuable');
    expect(identical(copie, original), isFalse);
  });

  test('fromJson construit une tâche à partir d\'un document JSON', () {
    // json-server génère des identifiants numériques : on accepte un int.
    final json = <String, dynamic>{
      'id': 7,
      'title': 'Quiz Dart',
      'courseId': 'mobile',
      'dueDate': '2026-12-03T10:00:00',
      'done': true,
    };

    final task = Task.fromJson(json);

    expect(task.id, '7');
    expect(task.title, 'Quiz Dart');
    expect(task.courseId, 'mobile');
    expect(task.dueDate, DateTime(2026, 12, 3, 10));
    expect(task.done, isTrue);
    expect(task.description, isEmpty);
  });

  test('toJson puis fromJson redonne la même tâche (séance 7)', () {
    final task = Task(
      id: '9',
      title: 'Rapport de stage',
      courseId: 'projet',
      dueDate: DateTime(2026, 12, 4, 23, 59),
      description: 'Plan détaillé',
    );

    expect(Task.fromJson(task.toJson()), task);
  });

  test('fetchTaskById lève TaskNotFoundException pour un id inconnu', () async {
    final repository = FakeCampusRepository(latency: Duration.zero);

    await expectLater(
      repository.fetchTaskById('999'),
      throwsA(isA<TaskNotFoundException>()),
    );
  });
}
