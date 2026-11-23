import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_theme.dart';
import 'package:campusflow/core/widgets/etats.dart';
import 'package:campusflow/features/taches/taches_notifier.dart';
import 'cours_providers.dart';

/// Écran « Mes cours » (route /cours), chargé depuis l'API.
class CoursScreen extends ConsumerWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCourses = ref.watch(coursProvider);
    final tasks = ref.watch(tachesProvider).value ?? const <Task>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Mes cours')),
      body: asyncCourses.when(
        loading: () => const ChargementView(),
        error: (error, _) => ErreurView(
          error: error,
          onRetry: () => ref.invalidate(coursProvider),
        ),
        data: (courses) => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.l),
          itemCount: courses.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) {
            final course = courses[index];
            final remaining = tasks
                .where((t) => t.courseId == course.id && !t.done)
                .length;
            return _CourseCard(course: course, remaining: remaining);
          },
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course, required this.remaining});

  final Course course;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = [
      course.teacher,
      course.room,
    ].where((s) => s.isNotEmpty).join(' · ');

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.s,
        ),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          child: const Icon(Icons.menu_book),
        ),
        title: Text(course.name, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '$details\n${switch (remaining) {
            0 => 'À jour',
            1 => '1 tâche à faire',
            _ => '$remaining tâches à faire',
          }}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
