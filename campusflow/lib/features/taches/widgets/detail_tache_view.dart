import 'package:campusflow_models/campusflow_models.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_theme.dart';
import 'package:campusflow/core/utils/dates.dart';
import 'status_badge.dart';

/// Contenu de l'écran Détail : une `Column` avec une `Card` et l'action
/// principale. Réutilisé tel quel dans le panneau de droite sur tablette.
class DetailTacheView extends StatelessWidget {
  const DetailTacheView({
    super.key,
    required this.task,
    required this.courseName,
    required this.onToggleDone,
  });

  final Task task;
  final String courseName;
  final VoidCallback onToggleDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.s),
                Chip(
                  avatar: const Icon(Icons.menu_book),
                  label: Text(courseName),
                ),
                const SizedBox(height: AppSpacing.l),
                _InfoRow(
                  icon: Icons.event,
                  label: 'Échéance',
                  child: Text(Dates.avecHeure(task.dueDate)),
                ),
                const SizedBox(height: AppSpacing.s),
                _InfoRow(
                  icon: Icons.flag_outlined,
                  label: 'Statut',
                  child: StatusBadge(task: task),
                ),
                const Divider(height: AppSpacing.xl),
                Text(
                  'Description',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  task.description.isEmpty
                      ? 'Aucune description.'
                      : task.description,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.l),
        FilledButton.icon(
          onPressed: onToggleDone,
          icon: Icon(task.done ? Icons.undo : Icons.check),
          label: Text(
            task.done ? 'Marquer comme à faire' : 'Marquer comme fait',
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.child});

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.s),
        Text('$label : '),
        Flexible(child: child),
      ],
    );
  }
}
