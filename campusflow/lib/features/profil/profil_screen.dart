import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_theme.dart';
import 'package:campusflow/features/auth/auth_notifier.dart';

/// Écran Profil (route /profil) : l'utilisateur de la session courante.
class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).value?.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          if (user != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: AppSpacing.xxl,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      child: Text(
                        user.name.characters.first,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text(user.name, style: theme.textTheme.titleLarge),
                    Text(user.program, style: theme.textTheme.bodyMedium),
                    Text(user.email, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.l),
          OutlinedButton.icon(
            // La session est effacée du stockage sécurisé ; le routeur
            // renvoie alors automatiquement vers /login.
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
