import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusflow/data/repositories/course_repository.dart';
import 'package:campusflow/features/auth/auth_notifier.dart';

/// Les cours, chargés depuis l'API (GET /cours).
final coursProvider = FutureProvider<List<Course>>(
  (ref) async {
    if (ref.watch(jetonProvider) == null) return const <Course>[];
    return ref.watch(courseRepositoryProvider).fetchAll();
  },
  retry: (_, _) => null,
);

/// Nom de chaque cours, indexé par identifiant.
final nomsCoursProvider = Provider<Map<String, String>>((ref) {
  final courses = ref.watch(coursProvider).value ?? const <Course>[];
  return {for (final course in courses) course.id: course.name};
});
