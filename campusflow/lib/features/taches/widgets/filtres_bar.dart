import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_theme.dart';
import '../filtres.dart';

/// Résumé + puces de filtre « À faire / En retard / Faites » (variante B).
class FiltresBar extends ConsumerWidget {
  const FiltresBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selection = ref.watch(filtreProvider);
    final parFiltre = ref.watch(tachesParFiltreProvider);
    final aFaire = parFiltre[FiltreTaches.aFaire]!.length;
    final enRetard = parFiltre[FiltreTaches.enRetard]!.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.m,
        AppSpacing.l,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$aFaire à faire · $enRetard en retard',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final filtre in FiltreTaches.values)
                FilterChip(
                  label: Text(
                    '${filtre.libelle} (${parFiltre[filtre]!.length})',
                  ),
                  selected: filtre == selection,
                  onSelected: (_) =>
                      ref.read(filtreProvider.notifier).choisir(filtre),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
