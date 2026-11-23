import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stockage de la session (jeton + utilisateur).
abstract interface class TokenStorage {
  Future<String?> readToken();
  Future<String?> readUser();
  Future<void> save({required String token, required String userJson});
  Future<void> clear();
}

/// Implémentation réelle : le jeton n'est **jamais** stocké en clair.
/// Android : Keystore ; iOS : Keychain ; web : WebCrypto.
class SecureTokenStorage implements TokenStorage {
  const SecureTokenStorage([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<String?> readUser() => _storage.read(key: _userKey);

  @override
  Future<void> save({required String token, required String userJson}) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userKey, value: userJson);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}

/// Stockage en mémoire, pour les tests.
class MemoryTokenStorage implements TokenStorage {
  String? token;
  String? user;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<String?> readUser() async => user;

  @override
  Future<void> save({required String token, required String userJson}) async {
    this.token = token;
    user = userJson;
  }

  @override
  Future<void> clear() async {
    token = null;
    user = null;
  }
}

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => const SecureTokenStorage(),
);
