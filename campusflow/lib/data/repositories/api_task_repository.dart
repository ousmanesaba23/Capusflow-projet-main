import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';

import 'package:campusflow/core/network/dio_client.dart';
import 'task_repository.dart';

/// Tâches stockées sur l'API REST json-server.
class ApiTaskRepository implements TaskRepository {
  ApiTaskRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Task>> fetchAll() => _guard(() async {
    final response = await _dio.get<List<dynamic>>('/taches');
    return [
      for (final json in response.data!)
        Task.fromJson(json as Map<String, dynamic>),
    ];
  });

  @override
  Future<Task> create(Task draft) => _guard(() async {
    // L'identifiant est attribué par le serveur.
    final body = draft.toJson()..remove('id');
    final response = await _dio.post<Map<String, dynamic>>(
      '/taches',
      data: body,
    );
    return Task.fromJson(response.data!);
  });

  @override
  Future<Task> setDone(String id, {required bool done}) => _guard(() async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/taches/$id',
      data: {'done': done},
    );
    return Task.fromJson(response.data!);
  });

  @override
  Future<void> delete(String id) => _guard(() async {
    await _dio.delete<void>('/taches/$id');
  });

  /// Traduit les erreurs Dio en [ApiException] : l'état et les écrans
  /// n'ont pas à connaître Dio.
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
