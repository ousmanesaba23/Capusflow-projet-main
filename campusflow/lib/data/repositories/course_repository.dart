import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusflow/core/network/dio_client.dart';
import 'package:campusflow/data/demo_data.dart';

/// Contrat d'accès aux cours (lecture seule).
abstract interface class CourseRepository {
  Future<List<Course>> fetchAll();
}

class ApiCourseRepository implements CourseRepository {
  ApiCourseRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Course>> fetchAll() async {
    try {
      final response = await _dio.get<List<dynamic>>('/cours');
      return [
        for (final json in response.data!)
          Course.fromJson(json as Map<String, dynamic>),
      ];
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

/// Cours en mémoire, pour les tests.
class FakeCourseRepository implements CourseRepository {
  const FakeCourseRepository([this.courses = DemoData.courses]);

  final List<Course> courses;

  @override
  Future<List<Course>> fetchAll() async => courses;
}

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return ApiCourseRepository(ref.watch(dioProvider));
});
