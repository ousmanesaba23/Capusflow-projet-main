import 'json_read.dart';

/// Un cours suivi par l'étudiant pendant le semestre.
class Course {
  const Course({
    required this.id,
    required this.name,
    this.teacher = '',
    this.room = '',
  });

  /// Construit un cours à partir d'un document JSON.
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: readId(json),
      name: readString(json, 'name'),
      teacher: readOptionalString(json, 'teacher'),
      room: readOptionalString(json, 'room'),
    );
  }

  final String id;
  final String name;
  final String teacher;
  final String room;

  Course copyWith({String? id, String? name, String? teacher, String? room}) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      room: room ?? this.room,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          other.id == id &&
          other.name == name &&
          other.teacher == teacher &&
          other.room == room;

  @override
  int get hashCode => Object.hash(id, name, teacher, room);

  @override
  String toString() => 'Course(id: $id, name: $name)';
}
