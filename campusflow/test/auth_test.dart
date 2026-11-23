import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campusflow/core/network/auth_interceptor.dart';
import 'package:campusflow/core/storage/token_storage.dart';
import 'package:campusflow/core/utils/dates.dart';
import 'package:campusflow/data/demo_data.dart';
import 'package:campusflow/data/repositories/auth_repository.dart';
import 'package:campusflow/features/auth/auth_notifier.dart';
import 'helpers.dart';

/// Adaptateur HTTP qui répond toujours avec le même code.
class _StatusAdapter implements HttpClientAdapter {
  _StatusAdapter(this.status);

  final int status;
  RequestOptions? last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    last = options;
    return ResponseBody.fromString(
      jsonEncode({}),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(Dates.init);

  group('écran de connexion', () {
    testWidgets('mauvais mot de passe : message et on reste sur /login', (
      tester,
    ) async {
      await pumpApp(tester);
      await seConnecter(tester, motDePasse: 'faux');

      expect(find.text('Adresse e-mail ou mot de passe incorrect.'),
          findsOneWidget);
      expect(routeur(tester).state.uri.path, '/login');
    });

    testWidgets('connexion : jeton rangé dans le stockage sécurisé', (
      tester,
    ) async {
      final stockage = MemoryTokenStorage();
      await pumpApp(tester, stockage: stockage);
      await seConnecter(tester);

      expect(routeur(tester).state.uri.path, '/taches');
      expect(stockage.token, 'jeton-de-test');
      expect(find.text('Quiz Dart'), findsOneWidget);
    });

    testWidgets('sans session, /taches renvoie vers /login', (tester) async {
      await pumpApp(tester);
      await allerA(tester, '/taches/4');

      expect(routeur(tester).state.uri.path, '/login');
    });

    testWidgets('une session enregistrée est restaurée au démarrage', (
      tester,
    ) async {
      final stockage = MemoryTokenStorage()
        ..token = 'jeton-de-test'
        ..user = Session.encodeUser(DemoData.user);
      await pumpApp(tester, stockage: stockage);

      expect(routeur(tester).state.uri.path, '/taches');
    });

    testWidgets('déconnexion : stockage vidé et retour à /login', (
      tester,
    ) async {
      final stockage = MemoryTokenStorage();
      await pumpApp(tester, stockage: stockage);
      await seConnecter(tester);

      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      expect(find.text('Awa Ouédraogo'), findsOneWidget);
      await tester.tap(find.text('Se déconnecter'));
      await tester.pumpAndSettle();

      expect(routeur(tester).state.uri.path, '/login');
      expect(stockage.token, isNull);
    });

    testWidgets('un 401 du serveur renvoie vers /login avec un message', (
      tester,
    ) async {
      await pumpApp(tester);
      await seConnecter(tester);

      // Ce que fait l'intercepteur Dio quand le serveur répond 401.
      await conteneur(tester).read(authProvider.notifier).expirer();
      await tester.pumpAndSettle();

      expect(routeur(tester).state.uri.path, '/login');
      expect(find.text('Votre session a expiré. Reconnectez-vous.'),
          findsOneWidget);
    });
  });

  group('AuthInterceptor', () {
    Dio dioAvec(_StatusAdapter adapter, void Function() on401) {
      return Dio(BaseOptions(baseUrl: 'http://api.test'))
        ..httpClientAdapter = adapter
        ..interceptors.add(
          AuthInterceptor(
            readToken: () async => 'abc123',
            onUnauthorized: () async => on401(),
          ),
        );
    }

    test('ajoute le jeton à chaque requête', () async {
      final adapter = _StatusAdapter(200);
      await dioAvec(adapter, () {}).get<void>('/taches');

      expect(adapter.last!.headers['Authorization'], 'Bearer abc123');
    });

    test('un 401 déclenche onUnauthorized', () async {
      var appels = 0;
      final dio = dioAvec(_StatusAdapter(401), () => appels++);

      await expectLater(dio.get<void>('/taches'), throwsA(isA<DioException>()));
      expect(appels, 1);
    });

    test('un 401 sur /login ne déclenche pas onUnauthorized', () async {
      var appels = 0;
      final dio = dioAvec(_StatusAdapter(401), () => appels++);

      await expectLater(dio.post<void>('/login'), throwsA(isA<DioException>()));
      expect(appels, 0);
    });
  });
}
