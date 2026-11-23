import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusflow/core/storage/token_storage.dart';
import 'package:campusflow/features/auth/auth_notifier.dart';
import 'api_config.dart';
import 'auth_interceptor.dart';

/// Erreur d'API traduite en message lisible pour l'écran.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  /// Convertit une erreur Dio en message compréhensible par l'étudiant.
  factory ApiException.fromDio(DioException error) {
    final status = error.response?.statusCode;
    final message = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => 'Le serveur met trop de temps à répondre.',
      DioExceptionType.connectionError =>
        'Serveur injoignable. Vérifiez votre connexion.',
      DioExceptionType.badResponse => switch (status) {
        401 => 'Session expirée, reconnectez-vous.',
        404 => 'Élément introuvable sur le serveur.',
        _ => 'Erreur du serveur ($status).',
      },
      _ => 'Erreur réseau inattendue.',
    };
    return ApiException(message, statusCode: status);
  }

  @override
  String toString() => message;
}

/// Le client HTTP unique de l'application. Seuls les repositories l'utilisent :
/// les écrans ne connaissent pas Dio.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(
      // ref.read (et non watch) : lus au moment de chaque requête.
      readToken: () => ref.read(tokenStorageProvider).readToken(),
      onUnauthorized: () => ref.read(authProvider.notifier).expirer(),
    ),
  );
  return dio;
});
