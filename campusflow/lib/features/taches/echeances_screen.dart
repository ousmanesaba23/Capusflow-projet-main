import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/router/app_router.dart';
import 'package:campusflow/core/theme/app_theme.dart';
import 'package:campusflow/core/widgets/etats.dart';
import 'package:campusflow/features/cours/cours_providers.dart';
import 'filtres.dart';
import 'taches_notifier.dart';
import 'widgets/detail_tache_view.dart';
import 'widgets/filtres_bar.dart';
import 'widgets/task_tile.dart';

/// Écran principal : la liste des échéances, triée par date (route /taches).
class EcheancesScreen extends ConsumerStatefulWidget {
  const EcheancesScreen({super.key});

  @override
  ConsumerState<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends ConsumerState<EcheancesScreen> {
  /// Tâche affichée dans le panneau de droite (tablette uniquement).
  /// C'est un état d'interface local : il reste dans le widget.
  String? _selectedId;

  // ref.read dans les gestionnaires d'action (PATCH /taches/:id).
  Future<void> _toggle(Task task) => executer(
    context,
    () => ref.read(tachesProvider.notifier).basculer(task.id),
  );

  @override
  Widget build(BuildContext context) {
    // ref.watch dans build : l'écran se reconstruit à chaque changement.
    final asyncTasks = ref.watch(tachesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Échéances')),
      // Les trois états d'un AsyncNotifier : chargement, erreur, données.
      body: asyncTasks.when(
        loading: () => const ChargementView(),
        error: (error, _) => ErreurView(
          error: error,
          onRetry: () => ref.read(tachesProvider.notifier).recharger(),
        ),
        data: (all) => _buildData(all),
      ),
      floatingActionButton: asyncTasks.hasValue
          ? FloatingActionButton(
              tooltip: 'Nouvelle tâche',
              onPressed: () => context.push(Routes.nouvelleTache),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildData(List<Task> all) {
    final filtered = ref.watch(tachesFiltreesProvider);
    final noms = ref.watch(nomsCoursProvider);

    // Téléphone : la liste seule. Tablette (≥ 840 dp) : liste + détail.
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= AppSpacing.expandedBreakpoint;
        if (!wide) return _buildList(filtered, noms, wide: false);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sans Expanded, la ListView recevrait une largeur non bornée
            // dans la Row et lèverait une erreur de layout.
            Expanded(flex: 2, child: _buildList(filtered, noms, wide: true)),
            const VerticalDivider(width: 1),
            Expanded(flex: 3, child: _buildDetailPane(all, noms)),
          ],
        );
      },
    );
  }

  Widget _buildList(
    List<Task> tasks,
    Map<String, String> noms, {
    required bool wide,
  }) {
    // Une ListView dans une Column doit être enveloppée dans Expanded :
    // sinon sa hauteur n'est pas bornée (« unbounded height »).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FiltresBar(),
        Expanded(
          // Tirer vers le bas recharge la liste depuis le serveur.
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(tachesProvider.future),
            child: tasks.isEmpty
                ? _buildEmpty()
                : _buildListView(tasks, noms, wide: wide),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    final theme = Theme.of(context);
    // ListView pour que le geste « tirer pour recharger » reste possible.
    return ListView(
      children: [
        const SizedBox(height: AppSpacing.xxl * 2),
        Icon(
          Icons.inbox_outlined,
          size: AppSpacing.logo / 2,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.s),
        Text(
          'Aucune tâche ici',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildListView(
    List<Task> tasks,
    Map<String, String> noms, {
    required bool wide,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSpacing.s,
        // Laisse la place au bouton flottant sous le dernier élément.
        bottom: AppSpacing.xxl * 3,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.xs,
          ),
          child: TaskTile(
            task: task,
            courseName: noms[task.courseId] ?? '',
            selected: wide && task.id == _selectedId,
            onToggle: () => _toggle(task),
            // Sur tablette, on affiche le détail à droite au lieu d'ouvrir
            // un nouvel écran.
            onTap: wide
                ? () => setState(() => _selectedId = task.id)
                : () => context.push(Routes.tache(task.id)),
          ),
        );
      },
    );
  }

  Widget _buildDetailPane(List<Task> tasks, Map<String, String> noms) {
    final task = tasks.where((t) => t.id == _selectedId).firstOrNull;
    if (task == null) {
      return Center(
        child: Text(
          'Sélectionnez une tâche pour voir son détail',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: DetailTacheView(
        task: task,
        courseName: noms[task.courseId] ?? '',
        onToggleDone: () => _toggle(task),
      ),
    );
  }
}
