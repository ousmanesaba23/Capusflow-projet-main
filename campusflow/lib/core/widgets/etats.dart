import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/network/dio_client.dart';
import 'package:campusflow/core/theme/app_theme.dart';

/// Message lisible pour n'importe quelle erreur.
String messageErreur(Object error) =>
    error is ApiException ? error.message : 'Une erreur est survenue.';

/// Affiche un message court en bas de l'écran.
void afficherMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Exécute une action asynchrone et affiche l'erreur éventuelle.
Future<bool> executer(
  BuildContext context,
  Future<void> Function() action, {
  String? succes,
}) async {
  try {
    await action();
    if (succes != null && context.mounted) afficherMessage(context, succes);
    return true;
  } catch (error) {
    if (context.mounted) afficherMessage(context, messageErreur(error));
    return false;
  }
}

/// État « chargement ».
class ChargementView extends StatelessWidget {
  const ChargementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(semanticsLabel: 'Chargement'),
    );
  }
}

/// État « erreur » avec un bouton Réessayer.
class ErreurView extends StatelessWidget {
  const ErreurView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: AppSpacing.logo / 2,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              messageErreur(error),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.l),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
