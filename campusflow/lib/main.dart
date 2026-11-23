import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/router/app_router.dart';
import 'package:campusflow/core/theme/app_theme.dart';
import 'package:campusflow/core/utils/dates.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Dates.init();
  // ProviderScope stocke l'état de tous les fournisseurs Riverpod.
  runApp(const ProviderScope(child: CampusFlowApp()));
}

class CampusFlowApp extends ConsumerWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'CampusFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
