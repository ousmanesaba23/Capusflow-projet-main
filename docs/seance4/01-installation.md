# Séance 4 — TP 12 : Installation de l'environnement Flutter

## Versions utilisées

| Outil | Version |
|-------|---------|
| Flutter | 3.50.1 (canal stable) |
| Dart | 3.14.0 |
| Système | Windows 11 |
| Android cible | `minSdk` 24 (Android 7.0), `compileSdk` 36 — valeurs par défaut de Flutter 3.50 |

`minSdk` 24 reste compatible avec les anciens téléphones Android encore très présents chez nos
utilisateurs (fiche comparative, critères 8 et 9).

## Étapes suivies

1. Télécharger l'archive Flutter stable pour Windows et l'extraire dans `C:\src\flutter`
   (chemin **sans espace** ni droits administrateur, comme le recommande la documentation).
2. Ajouter `C:\src\flutter\bin` à la variable d'environnement `Path` de l'utilisateur
   (Paramètres Windows → « Modifier les variables d'environnement pour votre compte »).
3. Installer **Android Studio**, puis au premier lancement installer le SDK Android, les
   *Command-line Tools* et un émulateur (Device Manager → *Create Virtual Device* → Pixel 7,
   image système API 35 ou 36).
4. Accepter les licences Android : `flutter doctor --android-licenses`.
5. Relancer `flutter doctor` et corriger chaque ligne marquée `[X]` jusqu'au diagnostic sans
   erreur.

## Diagnostic

### Premier diagnostic (avant Android Studio)

Sortie complète : [flutter-doctor-avant.txt](flutter-doctor-avant.txt).

| Ligne | État | Correction |
|-------|------|------------|
| Flutter | ✅ | — |
| Android toolchain | ❌ *Unable to locate Android SDK* | Installer Android Studio et le SDK (étape 3), puis accepter les licences (étape 4). |
| Chrome | ✅ | — |
| Visual Studio | ❌ | **Non bloquant** : uniquement pour compiler des applications Windows de bureau, hors du périmètre de CampusFlow. |
| Appareils connectés | ✅ | — |
| Ressources réseau | ✅ | — |

### Diagnostic final (après corrections)

![flutter doctor sans erreur](flutter-doctor.png)

> Capture à ajouter : `docs/seance4/flutter-doctor.png`, prise après l'installation d'Android
> Studio, montrant `[√] Android toolchain`.

### Application sur l'émulateur

![CampusFlow sur l'émulateur](emulateur.png)

> Capture à ajouter : `docs/seance4/emulateur.png`, l'application lancée avec
> `flutter run` sur l'émulateur Android.
