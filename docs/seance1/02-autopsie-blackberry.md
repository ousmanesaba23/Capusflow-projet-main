# Séance 1 — TP 2 : Autopsie d'un système — BlackBerry

## Le constat

En 2009, BlackBerry (l'entreprise s'appelait alors Research In Motion, RIM) était une référence
du smartphone professionnel, réputée pour son clavier physique, sa messagerie sécurisée et BBM
(BlackBerry Messenger). Au quatrième trimestre 2016, le cabinet Gartner ne comptait plus que
**207 900** smartphones vendus sous système BlackBerry dans le monde, soit une part de marché
arrondie à **0,0 %** sur 432 millions de smartphones vendus. Le 28 septembre 2016, l'entreprise
annonçait l'arrêt de tout développement matériel interne pour se recentrer sur le logiciel et la
sécurité. Les services des anciens systèmes (BlackBerry OS 7 et BlackBerry 10) ont ensuite été
arrêtés le 4 janvier 2022.

Un détail intéresse directement notre contexte : BlackBerry a longtemps été très populaire en
Afrique (au Nigeria et en Afrique du Sud notamment) grâce à BBM et à des forfaits de données
peu chers. Cette base d'utilisateurs n'a pas suffi à sauver la plateforme.

## Les trois causes retenues, classées par poids

### 1. Écosystème d'applications (poids le plus fort)

L'iPhone (2007) puis l'App Store (juillet 2008) ont déplacé la valeur du téléphone vers les
applications. BlackBerry a ouvert son store (BlackBerry App World) en 2009, avec des outils
basés sur Java ME, difficiles à utiliser et différents selon les modèles. Les développeurs ont
donné la priorité à iOS et Android, là où se trouvaient les utilisateurs, et les utilisateurs ont
suivi les applications : c'est l'effet de réseau à deux faces. Lorsque BlackBerry 10 est arrivé
en 2013, il a dû intégrer un environnement d'exécution pour applications Android afin de combler
le manque, ce qui revenait à reconnaître que son propre écosystème ne suffisait pas.

**Pourquoi en premier :** même un bon téléphone devient inutile si les applications du quotidien
(réseaux sociaux, banque, transport) n'y sont pas. Les deux autres causes ont surtout aggravé ce
retard d'écosystème.

### 2. Stratégie et timing

La direction a longtemps considéré l'iPhone comme un gadget grand public, sans menace pour sa
clientèle d'entreprises attachée au clavier et à la sécurité. Le nouveau système, BlackBerry 10,
construit sur QNX (racheté en 2010), n'est sorti qu'en **janvier 2013**, plus de cinq ans après
l'iPhone, alors qu'Android et iOS se partageaient déjà le marché. Entre-temps, la tablette
PlayBook (2011) était sortie sans client de messagerie natif. Les deux co-dirigeants ont quitté
leur poste en janvier 2012 : le virage a été pris trop tard.

### 3. Rupture d'interface

L'identité de BlackBerry, c'était le clavier physique. Le passage au tactile a été manqué : le
BlackBerry Storm (2008), avec son écran « cliquable », a été mal reçu. BlackBerry 10 a ensuite
introduit une navigation par gestes nouvelle, qui déroutait les fidèles sans séduire les
utilisateurs d'iPhone et d'Android déjà habitués à leurs propres codes.

### Cause écartée : le modèle de plateforme

Le modèle centralisé (tout le trafic passait par les serveurs de BlackBerry) était un atout de
sécurité, mais aussi un point de fragilité : la panne mondiale d'octobre 2011 a privé les
utilisateurs de messagerie pendant plusieurs jours. Ce facteur a abîmé l'image de la marque mais
pèse moins que les trois causes ci-dessus.

## Leçons pour CampusFlow

1. **Aller là où sont les utilisateurs** : l'écosystème décide. En Afrique francophone, c'est
   Android (cf. fiche comparative).
2. **Ne pas arriver trop tard** : une base de code unique (cross-platform) permet de sortir vite
   sur Android puis d'atteindre iOS sans tout réécrire.
3. **Respecter les habitudes** : suivre les conventions d'interface que les étudiants connaissent
   déjà (Material Design sur Android) plutôt que d'en inventer de nouvelles.

## Sources

- Gartner, communiqué de presse du 15 février 2017 sur les ventes mondiales de smartphones au
  4e trimestre 2016 : <https://www.gartner.com/newsroom/id/3609817>
- Global News, *BlackBerry's market share hits zero* (février 2017) :
  <https://globalnews.ca/news/3253615/blackberry-market-share-zero/>
- TechCrunch, *BlackBerry bows out of making its own hardware* (28 septembre 2016) :
  <https://techcrunch.com/2016/09/28/blackberry-bows-out-of-making-its-own-hardware>
- Jacquie McNish et Sean Silcoff, *Losing the Signal: The Untold Story Behind the Extraordinary
  Rise and Spectacular Fall of BlackBerry*, Flatiron Books, 2015.
