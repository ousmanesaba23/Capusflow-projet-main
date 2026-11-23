import 'dart:convert';

import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusflow/core/network/dio_client.dart';
import 'package:campusflow/data/demo_data.dart';

/// Une session ouverte : le jeton renvoyé par /login et l'utilisateur.
class Session {
  const Session({required this.token, required this.user});

  final String token;
  final User user;

  static String encodeUser(User user) => jsonEncode({
    'id': user.id,
    'name': user.name,
    'email': user.email,
    'program': user.program,
  });

  static User decodeUser(String json) =>
      User.fromJson(jsonDecode(json) as Map<String, dynamic>);
}

abstract interface class AuthRepository {
  /// Lève une [ApiException] (401) si les identifiants sont refusés.
  Future<Session> login({required String email, required String password});
}

/// POST /login sur json-server (voir server/server.js).
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: {'email': email, 'password': password},
      );
      final data = response.data!;
      return Session(
        token: data['token'] as String,
        user: User.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const ApiException(
          'Adresse e-mail ou mot de passe incorrect.',
          statusCode: 401,
        );
      }
      throw ApiException.fromDio(error);
    }
  }
}

/// Connexion simulée pour les tests : un seul compte valide.
class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository();

  static const password = 'campus2026';

  @override
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    if (email == DemoData.user.email && password == FakeAuthRepository.password) {
      return const Session(token: 'jeton-de-test', user: DemoData.user);
    }
    throw const ApiException(
      'Adresse e-mail ou mot de passe incorrect.',
      statusCode: 401,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(ref.watch(dioProvider));
});
