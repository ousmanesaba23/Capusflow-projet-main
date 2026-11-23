import 'json_read.dart';

/// L'étudiant connecté à CampusFlow.
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.program = '',
  });

  /// Construit un utilisateur à partir d'un document JSON.
  ///
  /// Le mot de passe éventuellement présent dans le JSON est ignoré.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: readId(json),
      name: readString(json, 'name'),
      email: readString(json, 'email'),
      program: readOptionalString(json, 'program'),
    );
  }

  final String id;
  final String name;
  final String email;

  /// Filière et niveau, par exemple « Master 1 MSI ».
  final String program;

  User copyWith({String? id, String? name, String? email, String? program}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      program: program ?? this.program,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.id == id &&
          other.name == name &&
          other.email == email &&
          other.program == program;

  @override
  int get hashCode => Object.hash(id, name, email, program);

  @override
  String toString() => 'User(id: $id, name: $name)';
}
