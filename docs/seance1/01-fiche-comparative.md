# Séance 1 — TP 1 : Fiche comparative Android / iOS

**Cas réel étudié :** CampusFlow, une application étudiante (suivi des cours, des échéances et
des tâches) destinée aux étudiants d'Afrique francophone, à commencer par le Burkina Faso.

La colonne de droite est la partie utile de la fiche : pour chaque critère, elle note ce qui
change quand l'utilisateur est un étudiant de Ouagadougou, Bobo-Dioulasso, Abidjan ou Dakar,
plutôt qu'un utilisateur « moyen » d'Europe ou d'Amérique du Nord.

## Les 14 critères

| # | Critère | Android | iOS | Ce qui change pour une app étudiante en Afrique francophone |
|---|---------|---------|-----|-------------------------------------------------------------|
| 1 | **Philosophie** | Système ouvert (AOSP, open source), licencié à de nombreux constructeurs. Google contrôle les services (Play, GMS). | Système fermé, intégration verticale : Apple conçoit le matériel, l'OS et le store. | L'ouverture d'Android a permis des téléphones à bas prix (Tecno, Infinix, itel, Samsung série A) : c'est le téléphone de la grande majorité des étudiants. L'iPhone est minoritaire, souvent acheté d'occasion. |
| 2 | **Architecture** | Noyau Linux, couche d'abstraction matérielle (HAL), Android Runtime (ART, compilation AOT + JIT), framework Java/Kotlin, applications. | Noyau XNU (Darwin), couches Core OS, Core Services, Media, Cocoa Touch (UIKit / SwiftUI). | Sur des appareils à 2–4 Go de RAM avec surcouche constructeur (HiOS, XOS), le système tue très vite les applications en arrière-plan. L'application doit être légère et supporter d'être fermée à tout moment. |
| 3 | **Langage** | Kotlin (langage recommandé par Google), Java historiquement. | Swift (depuis 2014), Objective-C historiquement. | Deux langages natifs = deux équipes, ce qui est hors de portée d'un petit projet étudiant. Une base de code unique en Dart (Flutter) divise le coût par deux et s'appuie sur des bases Java/Python déjà enseignées. |
| 4 | **Cycle de vie** | `Activity` : `onCreate`, `onStart`, `onResume`, `onPause`, `onStop`, `onDestroy`. Le processus peut être tué sans préavis. | États de l'application/scène : *Not running*, *Inactive*, *Active*, *Background*, *Suspended*. | Appel entrant, coupure de courant, manque de RAM : l'interruption est fréquente. Une tâche en cours de saisie ne doit pas être perdue ; les données sont sauvegardées dès qu'elles sont validées. |
| 5 | **Permissions** | Permissions à l'exécution depuis Android 6 (API 23) ; permission explicite pour les notifications depuis Android 13. | Demande à la première utilisation, justification obligatoire dans `Info.plist` ; transparence du suivi (ATT). | Utilisateurs souvent méfiants envers les demandes d'accès. CampusFlow ne demande que les notifications, au moment où l'étudiant crée un rappel, avec une phrase simple en français. Pas de contacts, pas de localisation. |
| 6 | **Stockage** | Stockage interne privé, SharedPreferences/DataStore, SQLite/Room, stockage limité (*scoped storage*) depuis Android 10, Keystore pour les secrets. | Bac à sable (*sandbox*), UserDefaults, Core Data/SQLite, Keychain pour les secrets. | Les 32–64 Go sont souvent saturés par les médias WhatsApp. L'application doit peser peu (objectif < 20 Mo) et garder un petit cache local. Le jeton de connexion va dans le Keystore/Keychain, jamais en clair. |
| 7 | **Distribution** | Google Play (frais uniques de 25 $, revue rapide), installation d'APK possible (*sideload*), stores constructeurs. | App Store uniquement (99 $/an, revue Apple), TestFlight pour les tests. | Le partage d'APK par WhatsApp ou Xender est une habitude locale. On peut publier sur Play Store **et** proposer l'APK sur le site de l'université. Pour iOS, un compte payant et un Mac sont indispensables. |
| 8 | **Fragmentation** | Des milliers de modèles, tailles d'écran, densités et versions d'Android en circulation. | Peu de modèles, versions très homogènes. | Le parc est hétérogène : écrans 720p, versions anciennes d'Android encore actives, téléphones d'occasion. On teste sur un appareil d'entrée de gamme et on conçoit des écrans qui s'adaptent (de 360 dp à la tablette). |
| 9 | **Mises à jour** | Dépendent du constructeur : l'entrée de gamme reçoit peu de mises à jour majeures. Google Play Services et les modules *Mainline* se mettent à jour à part. | Apple met à jour directement tous les appareils compatibles pendant plusieurs années. | On ne peut pas compter sur une version récente d'Android : il faut viser une version minimale ancienne. Chaque mise à jour de l'app consomme des données : on publie des versions peu fréquentes et légères. |
| 10 | **Contraintes de développement** | Android Studio sur Windows, Linux ou macOS ; émulateur gratuit ; test sur son propre téléphone en USB. | Xcode uniquement sur macOS ; un Mac est obligatoire pour compiler et publier. | Les étudiants et les salles machines ont surtout des PC Windows : le développement et les tests Android sont immédiats. La version iOS demandera d'emprunter un Mac ou d'utiliser un service d'intégration continue macOS. |
| 11 | **Parts de marché** | Ultra-dominant en Afrique : ~81 % des mobiles (Afrique, août 2026) et ~91 % au Burkina Faso (juin 2026). | ~19 % en Afrique (août 2026), ~9 % au Burkina Faso (juin 2026), surtout en milieu urbain aisé. | La répartition n'a rien à voir avec celle des États-Unis ou de l'Europe de l'Ouest. Développer d'abord pour iOS reviendrait à ignorer 9 étudiants burkinabè sur 10. |
| 12 | **Conventions d'interface** | Material Design 3, bouton/geste « retour » système, barre de navigation en bas. | Human Interface Guidelines, retour par balayage depuis le bord, barre d'onglets. | Les étudiants sont habitués aux codes Android. Material 3 (fourni par Flutter) est le choix naturel. Textes courts en français, gros boutons, bon contraste pour une lecture en plein soleil. |
| 13 | **Notifications et tâches de fond** | Firebase Cloud Messaging, WorkManager, alarmes exactes restreintes depuis Android 12 ; optimisations batterie agressives selon les constructeurs. | APNs, actualisation en arrière-plan limitée et décidée par le système. | Le rappel d'échéance est une fonctionnalité centrale. Sur Tecno/Infinix, l'économiseur de batterie peut bloquer les tâches de fond : on combine notifications locales programmées et rappel visible à l'ouverture de l'app. |
| 14 | **Connectivité et données** | Économiseur de données (*Data Saver*), détection du réseau mesuré. | Mode données réduites (*Low Data Mode*). | Forfaits chers, 3G/4G instable, coupures. L'application doit fonctionner hors ligne pour la consultation, envoyer des requêtes JSON légères, éviter les images lourdes et resynchroniser au retour du réseau. |

## Ce qu'il faut retenir

1. **Android d'abord** : c'est là que sont les étudiants (environ 9 sur 10 au Burkina Faso).
2. **Matériel modeste** : peu de RAM, stockage saturé, versions anciennes. L'application doit être
   légère, tolérante aux interruptions et compatible avec d'anciennes versions d'Android.
3. **Réseau coûteux et instable** : mode hors ligne pour la consultation, échanges JSON minimaux.
4. **iOS ensuite** : la minorité iOS existe, mais son coût d'entrée (Mac, 99 $/an) justifie de
   l'atteindre avec le même code plutôt qu'avec un second développement natif.

## Sources

- StatCounter Global Stats, *Mobile Operating System Market Share Africa* (consulté le
  21/11/2026, valeurs d'août 2026) : <https://gs.statcounter.com/os-market-share/mobile/africa>
- StatCounter Global Stats, *Mobile Operating System Market Share Burkina Faso* (consulté le
  21/11/2026, valeurs de juin 2026) : <https://gs.statcounter.com/os-market-share/mobile/burkina-faso>
- Android Developers, *Platform architecture* : <https://developer.android.com/guide/platform>
- Apple Developer, *Human Interface Guidelines* : <https://developer.apple.com/design/human-interface-guidelines>
- Material Design 3 : <https://m3.material.io>
