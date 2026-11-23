import 'package:flutter/foundation.dart';

/// Adresse de l'API json-server.
///
/// - Émulateur Android : `10.0.2.2` désigne le PC hôte (`localhost` serait
///   l'émulateur lui-même).
/// - Web, iOS, bureau : `127.0.0.1`.
/// - Téléphone réel : passer l'adresse IP du PC au lancement, par exemple
///   `flutter run --dart-define=API_URL=http://192.168.1.20:3000`.
abstract final class ApiConfig {
  static const _override = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://127.0.0.1:3000';
  }
}
