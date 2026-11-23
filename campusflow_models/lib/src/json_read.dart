/// Fonctions de lecture JSON partagées par les modèles.
///
/// Elles lèvent une [FormatException] explicite quand un champ obligatoire
/// manque ou n'a pas le bon type, plutôt qu'une erreur de cast obscure.
library;

/// Lit l'identifiant : json-server peut renvoyer un id numérique ou texte.
String readId(Map<String, dynamic> json) {
  final value = json['id'];
  if (value is String && value.isNotEmpty) return value;
  if (value is int) return value.toString();
  throw FormatException('Champ "id" manquant ou invalide', json);
}

/// Lit un texte obligatoire et non vide.
String readString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String && value.trim().isNotEmpty) return value;
  throw FormatException('Champ "$key" manquant ou invalide', json);
}

/// Lit un texte facultatif (chaîne vide s'il est absent).
String readOptionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value == null ? '' : value.toString();
}

/// Lit une date au format ISO 8601 (par exemple « 2026-11-27T23:59:00 »).
DateTime readDate(Map<String, dynamic> json, String key) {
  final value = json[key];
  final date = value is String ? DateTime.tryParse(value) : null;
  if (date != null) return date;
  throw FormatException('Champ "$key" : date ISO 8601 attendue', json);
}
