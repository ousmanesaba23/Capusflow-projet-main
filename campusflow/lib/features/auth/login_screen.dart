import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/theme/app_theme.dart';
import 'package:campusflow/core/widgets/etats.dart';
import 'auth_notifier.dart';

/// Écran de connexion (route /login) : POST /login, jeton rangé dans le
/// stockage sécurisé, puis redirection automatique vers /taches par le routeur.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _erreur;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading || !_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _erreur = null;
    });
    try {
      await ref.read(authProvider.notifier).login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Pas de context.go ici : le routeur voit la nouvelle session et
      // redirige lui-même vers /taches.
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _erreur = messageErreur(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final expiree = ref.read(authProvider.notifier).sessionExpiree;
    final message =
        _erreur ??
        (expiree ? 'Votre session a expiré. Reconnectez-vous.' : null);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: AppSpacing.logo,
                      height: AppSpacing.logo,
                      semanticLabel: 'Logo CampusFlow',
                    ),
                    const SizedBox(height: AppSpacing.l),
                    Text(
                      'CampusFlow',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      'Vos cours et vos échéances, même hors ligne',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Adresse e-mail',
                      ),
                      validator: (value) =>
                          (value == null || !value.contains('@'))
                          ? 'Adresse e-mail invalide'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        suffixIcon: IconButton(
                          tooltip: _obscure
                              ? 'Afficher le mot de passe'
                              : 'Masquer le mot de passe',
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Le mot de passe est obligatoire'
                          : null,
                    ),
                    if (message != null) ...[
                      const SizedBox(height: AppSpacing.l),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        decoration: BoxDecoration(
                          color: colors.errorContainer,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radius,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: colors.onErrorContainer),
                            const SizedBox(width: AppSpacing.s),
                            Expanded(
                              child: Text(
                                message,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      child: Text(_loading ? 'Connexion…' : 'Se connecter'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
