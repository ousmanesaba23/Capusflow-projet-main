import 'package:campusflow_models/campusflow_models.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_theme.dart';

enum TaskStatus { done, overdue, soon, later }

/// Statut d'une tâche à une date donnée.
TaskStatus statusOf(Task task, DateTime now) {
  if (task.done) return TaskStatus.done;
  if (task.isOverdue(now)) return TaskStatus.overdue;
  if (daysUntil(task.dueDate, now) < 3) return TaskStatus.soon;
  return TaskStatus.later;
}

/// Nombre de jours calendaires entre aujourd'hui et l'échéance.
int daysUntil(DateTime dueDate, DateTime now) {
  final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
  final today = DateTime(now.year, now.month, now.day);
  return due.difference(today).inDays;
}

/// Libellé lisible du statut (utilisé aussi dans l'écran Détail).
String statusLabel(Task task, DateTime now) {
  return switch (statusOf(task, now)) {
    TaskStatus.done => 'Faite',
    TaskStatus.overdue => 'En retard',
    TaskStatus.soon => switch (daysUntil(task.dueDate, now)) {
      0 => 'Aujourd\'hui',
      final days => 'J-$days',
    },
    TaskStatus.later => 'À faire',
  };
}

/// Badge de statut : toujours une icône et un texte, jamais la couleur seule.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.task, this.now});

  final Task task;

  /// Date de référence (aujourd'hui par défaut), injectable pour les tests.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final status = theme.extension<StatusColors>()!;
    final reference = now ?? DateTime.now();

    final (IconData icon, Color background, Color foreground) =
        switch (statusOf(task, reference)) {
          TaskStatus.done => (
            Icons.check_circle,
            status.successContainer,
            status.onSuccessContainer,
          ),
          TaskStatus.overdue => (
            Icons.warning_amber_rounded,
            colors.errorContainer,
            colors.onErrorContainer,
          ),
          TaskStatus.soon => (
            Icons.schedule,
            colors.secondaryContainer,
            colors.onSecondaryContainer,
          ),
          TaskStatus.later => (
            Icons.event,
            colors.surfaceContainerHighest,
            colors.onSurfaceVariant,
          ),
        };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: AppSpacing.xs),
          Text(
            statusLabel(task, reference),
            style: theme.textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
