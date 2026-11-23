import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusflow/core/storage/token_storage.dart';
import 'package:campusflow/data/repositories/auth_repository.dart';

/// Session courante : `null` si personne n'est connecté.
///
/// Au démarrage, la session est relue depuis le stockage sécurisé : un
/// étudiant déjà connecté n'a pas à retaper son mot de passe.
class AuthNotifier extends AsyncNotifier<Session?> {
  TokenStorage get _storage => ref.read(tokenStorageProvider);

  /// Vrai si la dernière déconnexion vient d'un 401 du serveur.
  bool sessionExpiree = false;

  @override
  Future<Session?> build() async {
    final storage = ref.watch(tokenStorageProvider);
    final token = await storage.readToken();
    final user = await storage.readUser();
    if (token == null || user == null) return null;
    return Session(token: token, user: Session.decodeUser(user));
  }

  Future<void> login({required String email, required String password}) async {
    final session = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    await _storage.save(
      token: session.token,
      userJson: Session.encodeUser(session.user),
    );
    sessionExpiree = false;
    state = AsyncData(session);
  }

  Future<void> logout() async {
    await _storage.clear();
    state = const AsyncData(null);
  }

  /// Appelée par l'intercepteur Dio quand le serveur répond 401.
  Future<void> expirer() async {
    if (state.value == null) return;
    sessionExpiree = true;
    await logout();
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, Session?>(
  AuthNotifier.new,
  retry: (_, _) => null,
);

/// Le jeton courant : les données distantes sont rechargées quand il change.
final jetonProvider = Provider<String?>(
  (ref) => ref.watch(authProvider.select((auth) => auth.value?.token)),
);
