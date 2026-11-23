import 'package:campusflow_models/campusflow_models.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/utils/dates.dart';
import 'status_badge.dart';

/// Carte de tâche du design system : `Card` + `ListTile`.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.courseName,
    this.onTap,
    this.onToggle,
    this.selected = false,
  });

  final Task task;
  final String courseName;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        selected: selected,
        selectedTileColor: theme.colorScheme.primaryContainer,
        leading: Checkbox(
          value: task.done,
          onChanged: onToggle == null ? null : (_) => onToggle!(),
          semanticLabel: task.done
              ? 'Marquer « ${task.title} » comme à faire'
              : 'Marquer « ${task.title} » comme faite',
        ),
        title: Text(
          task.title,
          style: theme.textTheme.titleMedium?.copyWith(
            decoration: task.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('$courseName · ${Dates.courte(task.dueDate)}'),
        trailing: StatusBadge(task: task),
        onTap: onTap,
      ),
    );
  }
}
