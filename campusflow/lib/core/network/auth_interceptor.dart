import 'package:dio/dio.dart';

/// Intercepteur Dio :
/// - ajoute `Authorization: Bearer <jeton>` à chaque requête ;
/// - prévient l'application quand le serveur répond 401 (jeton absent,
///   invalide ou expiré) pour la renvoyer vers l'écran de connexion.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.readToken, required this.onUnauthorized});

  final Future<String?> Function() readToken;
  final Future<void> Function() onUnauthorized;

  static const loginPath = '/login';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await readToken();
    if (token != null && options.path != loginPath) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final unauthorized = err.response?.statusCode == 401;
    // Un 401 sur /login veut dire « mauvais mot de passe », pas « session
    // expirée » : l'écran de connexion le gère lui-même.
    if (unauthorized && err.requestOptions.path != loginPath) {
      await onUnauthorized();
    }
    handler.next(err);
  }
}
