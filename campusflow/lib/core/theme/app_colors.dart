import 'package:material_ui/material_ui.dart';

/// Couleurs du design system v1 (docs/seance2/04-design-system-v1.md).
///
/// Chaque paire texte / fond respecte un contraste d'au moins 4,5:1.
/// Les widgets ne lisent jamais ces constantes directement : ils passent par
/// `Theme.of(context)` (voir [AppTheme]).
abstract final class AppColors {
  static const primary = Color(0xFF1E5AA8);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFDCE7F7);
  static const onPrimaryContainer = Color(0xFF0B2E59);

  /// Échéance proche (J-1, J-3).
  static const secondary = Color(0xFF9A4A00);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFDEBD7);
  static const onSecondaryContainer = Color(0xFF9A4A00);

  /// Retard et erreurs.
  static const error = Color(0xFFB3261E);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFBE9E7);
  static const onErrorContainer = Color(0xFFB3261E);

  /// Tâche faite (extension du thème, voir [StatusColors]).
  static const success = Color(0xFF1B6E3A);
  static const onSuccess = Color(0xFFFFFFFF);
  static const successContainer = Color(0xFFE3F2E8);
  static const onSuccessContainer = Color(0xFF1B6E3A);

  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1A1C1E);
  static const onSurfaceVariant = Color(0xFF535960);
  static const background = Color(0xFFF6F7F9);
  static const outline = Color(0xFFC3C7CE);
  static const disabled = Color(0xFFE3E5E8);
}
