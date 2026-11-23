import 'json_read.dart';

/// Une tâche à rendre (devoir, TP, exposé, lecture…) rattachée à un cours.
///
/// Les objets sont immuables : tous les attributs sont `final`. Pour
/// « modifier » une tâche, on en crée une copie avec [copyWith].
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    this.description = '',
    this.done = false,
  });

  /// Construit une tâche à partir d'un document JSON.
  ///
  /// Lève une [FormatException] si `id`, `title` ou `dueDate` est absent.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: readId(json),
      title: readString(json, 'title'),
      courseId: readOptionalString(json, 'courseId'),
      dueDate: readDate(json, 'dueDate'),
      description: readOptionalString(json, 'description'),
      done: json['done'] == true,
    );
  }

  final String id;
  final String title;
  final String courseId;
  final DateTime dueDate;
  final String description;
  final bool done;

  /// Document JSON envoyé à l'API (séance 7). La date est au format ISO 8601.
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'courseId': courseId,
    'dueDate': dueDate.toIso8601String(),
    'description': description,
    'done': done,
  };

  /// Renvoie une nouvelle tâche identique, sauf pour les champs fournis.
  Task copyWith({
    String? id,
    String? title,
    String? courseId,
    DateTime? dueDate,
    String? description,
    bool? done,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      done: done ?? this.done,
    );
  }

  /// Vrai si la tâche n'est pas faite et que son échéance est dépassée.
  bool isOverdue(DateTime now) => !done && dueDate.isBefore(now);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          other.id == id &&
          other.title == title &&
          other.courseId == courseId &&
          other.dueDate == dueDate &&
          other.description == description &&
          other.done == done;

  @override
  int get hashCode =>
      Object.hash(id, title, courseId, dueDate, description, done);

  @override
  String toString() => 'Task(id: $id, title: $title, done: $done)';
}
