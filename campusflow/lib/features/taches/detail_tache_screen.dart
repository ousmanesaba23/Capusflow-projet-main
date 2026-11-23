import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_theme.dart';
import 'package:campusflow/core/widgets/etats.dart';
import 'package:campusflow/features/cours/cours_providers.dart';
import 'taches_notifier.dart';
import 'widgets/detail_tache_view.dart';

/// Écran Détail d'une tâche (route /taches/:id), branché sur l'état partagé.
class DetailTacheScreen extends ConsumerWidget {
  const DetailTacheScreen({super.key, required this.taskId});

  /// Paramètre :id lu dans l'adresse.
  final String taskId;

  Future<void> _supprimer(BuildContext context, WidgetRef ref, Task task) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche ?'),
        content: Text('« ${task.title} » sera supprimée définitivement.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true || !context.mounted) return;

    final ok = await executer(
      context,
      () => ref.read(tachesProvider.notifier).supprimer(task.id),
      succes: 'Tâche supprimée',
    );
    if (ok && context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(tachesProvider);
    final task = ref.watch(tacheParIdProvider(taskId));
    final noms = ref.watch(nomsCoursProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la tâche'),
        actions: [
          if (task != null)
            IconButton(
              tooltip: 'Supprimer',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _supprimer(context, ref, task),
            ),
        ],
      ),
      body: asyncTasks.when(
        loading: () => const ChargementView(),
        error: (error, _) => ErreurView(
          error: error,
          onRetry: () => ref.read(tachesProvider.notifier).recharger(),
        ),
        data: (_) => task == null
            ? Center(child: Text('Aucune tâche avec l\'id « $taskId »'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: DetailTacheView(
                  task: task,
                  courseName: noms[task.courseId] ?? '',
                  onToggleDone: () => executer(
                    context,
                    () => ref.read(tachesProvider.notifier).basculer(task.id),
                    succes: task.done
                        ? 'Tâche à refaire'
                        : 'Tâche marquée comme faite',
                  ),
                ),
              ),
      ),
    );
  }
}
