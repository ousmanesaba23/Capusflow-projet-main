import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:campusflow/data/repositories/auth_repository.dart';
import 'package:campusflow/features/auth/auth_notifier.dart';
import 'package:campusflow/features/auth/login_screen.dart';
import 'package:campusflow/features/cours/cours_screen.dart';
import 'package:campusflow/features/profil/profil_screen.dart';
import 'package:campusflow/features/shell/home_shell.dart';
import 'package:campusflow/features/taches/detail_tache_screen.dart';
import 'package:campusflow/features/taches/echeances_screen.dart';
import 'package:campusflow/features/taches/nouvelle_tache_screen.dart';

/// Adresses de l'application : chaque écran est accessible par son URL.
abstract final class Routes {
  static const login = '/login';
  static const taches = '/taches';
  static const nouvelleTache = '/taches/nouvelle';
  static String tache(String id) => '/taches/$id';
  static const cours = '/cours';
  static const profil = '/profil';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Prévient GoRouter à chaque changement de session pour réévaluer redirect.
  final session = ValueNotifier<AsyncValue<Session?>>(const AsyncLoading());
  ref.onDispose(session.dispose);
  ref.listen(
    authProvider,
    (_, next) => session.value = next,
    fireImmediately: true,
  );

  final router = GoRouter(
    initialLocation: Routes.login,
    refreshListenable: session,
    // Garde : sans session, toutes les adresses renvoient vers /login.
    redirect: (context, state) {
      final auth = session.value;
      if (!auth.hasValue) return null; // session en cours de lecture
      final connecte = auth.value != null;
      final surLogin = state.matchedLocation == Routes.login;
      if (!connecte && !surLogin) return Routes.login;
      if (connecte && surLogin) return Routes.taches;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // La barre de navigation est dans le ShellRoute : elle reste affichée
      // pour toutes les routes enfants.
      ShellRoute(
        builder: (context, state, child) =>
            HomeShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: Routes.taches,
            builder: (context, state) => const EcheancesScreen(),
            routes: [
              // « nouvelle » doit être déclarée avant « :id ».
              GoRoute(
                path: 'nouvelle',
                builder: (context, state) => const NouvelleTacheScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    DetailTacheScreen(taskId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: Routes.cours,
            builder: (context, state) => const CoursScreen(),
          ),
          GoRoute(
            path: Routes.profil,
            builder: (context, state) => const ProfilScreen(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
