# CampusFlow

Application mobile Flutter de suivi des cours, des échéances et des tâches d'un étudiant.
Projet fil rouge du module **Programmation Mobile** (Master 1 MSI & IA-FPC, 2026-2027) :
27 TP répartis sur 7 séances, de la décision de plateforme jusqu'à une application connectée à
une API avec authentification. Chaque TP correspond à un commit de l'historique.

## Contenu du dépôt

```
docs/                 Livrables de conception (séances 1, 2 et 4)
campusflow_models/    Package Dart pur : Task, Course, User, fromJson, tests (séance 3)
campusflow/           Application Flutter (séances 4 à 7)
server/               API simulée json-server + connexion par jeton (séance 7)
```

## Auto-vérification

| Séance | Attendu | Où le trouver |
|--------|---------|---------------|
| 1 | Fiche comparative, autopsie sourcée, décision | [fiche](docs/seance1/01-fiche-comparative.md) · [autopsie BlackBerry](docs/seance1/02-autopsie-blackberry.md) · [décision](docs/seance1/03-decision-campusflow.md) |
| 2 | Persona, parcours, 5 wireframes + 3 variantes, design system v1 | [persona](docs/seance2/01-persona-job-stories.md) · [parcours](docs/seance2/02-parcours-utilisateur.md) · [wireframes](docs/seance2/03-wireframes.md) · [design system](docs/seance2/04-design-system-v1.md) |
| 3 | Package `campusflow_models`, `fromJson`, 3 tests qui passent | [campusflow_models/](campusflow_models/) · `dart test` (4 tests, dont `toJson` ajouté en séance 7) |
| 4 | `flutter doctor` sans erreur, app sur émulateur, thème centralisé, asset, ≥ 3 commits | [installation](docs/seance4/01-installation.md) · [thème](campusflow/lib/core/theme/app_theme.dart) · [logo](campusflow/assets/images/logo.png) |
| 5 | Écrans Échéances, Détail, Formulaire, tablette à 840 dp | [écrans](campusflow/lib/features/taches/) |
| 6 | Navigation par adresses, état partagé, 3 filtres | [routes](campusflow/lib/core/router/app_router.dart) · [état](campusflow/lib/features/taches/taches_notifier.dart) · [filtres](campusflow/lib/features/taches/filtres.dart) |
| 7 | json-server, couches Repository, CRUD, connexion avec jeton sécurisé | [server/](server/) · [repositories](campusflow/lib/data/repositories/) · [Dio + intercepteur](campusflow/lib/core/network/) · [stockage sécurisé](campusflow/lib/core/storage/token_storage.dart) |

## Lancer le projet

Prérequis : Flutter 3.50 (Dart 3.14), Android Studio avec un émulateur, Node.js 18 ou plus.

> Placez le dépôt dans un chemin **court et sans espace** (par exemple `C:\dev\campusflow`) :
> certains outils natifs de Flutter et Gradle échouent avec des chemins trop longs.

**1. L'API** (terminal 1)

```bash
cd server
npm install
npm start          # http://127.0.0.1:3000
```

**2. L'application** (terminal 2, émulateur Android démarré)

```bash
cd campusflow
flutter pub get
flutter run
```

Compte de démonstration : `awa@campus.bf` / `campus2026`.

Sur l'émulateur Android, l'API est appelée par `http://10.0.2.2:3000` (voir
[api_config.dart](campusflow/lib/core/network/api_config.dart)). Sur un vrai téléphone :
`flutter run --dart-define=API_URL=http://<IP-du-PC>:3000`.

**3. Les tests**

```bash
cd campusflow_models && dart test     # modèles
cd campusflow && flutter test         # application (repositories en mémoire, sans réseau)
```

## Architecture de l'application

```
campusflow/lib/
  main.dart                     ProviderScope + MaterialApp.router
  core/
    theme/                      Design system v1 traduit en ThemeData
    router/app_router.dart      GoRouter, ShellRoute, redirection vers /login
    network/                    Client Dio, intercepteur du jeton, adresse de l'API
    storage/token_storage.dart  Jeton dans flutter_secure_storage (jamais en clair)
    widgets/etats.dart          Vues « chargement » et « erreur + Réessayer »
  data/
    repositories/               Contrats + implémentations API et Fake (tests)
  features/
    auth/                       Connexion, session (AsyncNotifier)
    taches/                     Échéances, détail, formulaire, filtres, TachesNotifier
    cours/  profil/  shell/     Autres écrans et barre de navigation
```

Les écrans ne connaissent ni Dio ni l'API : ils lisent des fournisseurs Riverpod
(`ref.watch` dans `build`, `ref.read` dans les actions), qui passent par les repositories.

Note : depuis Flutter 3.47, les widgets Material sont fournis par le package `material_ui`
(`import 'package:material_ui/material_ui.dart'`) ; `package:flutter/material.dart` est
déprécié. Le projet suit le modèle généré par `flutter create`.
