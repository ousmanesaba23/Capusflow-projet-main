import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Formatage des dates en français avec le package `intl`.
abstract final class Dates {
  static const locale = 'fr_FR';

  /// À appeler une fois avant `runApp` (et dans les tests).
  static Future<void> init() => initializeDateFormatting(locale);

  /// « samedi 21 novembre 2026 »
  static String longue(DateTime date) =>
      DateFormat('EEEE d MMMM y', locale).format(date);

  /// « ven. 27 nov. »
  static String courte(DateTime date) =>
      DateFormat('EEE d MMM', locale).format(date);

  /// « ven. 27 nov., 23:59 »
  static String avecHeure(DateTime date) =>
      DateFormat("EEE d MMM', 'HH:mm", locale).format(date);
}
