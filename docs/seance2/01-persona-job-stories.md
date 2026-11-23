# Séance 2 — TP 4 : Persona et job stories

## Persona : Awa Ouédraogo

| | |
|---|---|
| **Âge** | 22 ans |
| **Études** | Licence 3 Informatique, université privée de Ouagadougou |
| **Lieu de vie** | Quartier Tampouy, chez ses parents ; 25 minutes de moto jusqu'au campus |
| **Appareil** | Tecno Spark sous Android 12, 3 Go de RAM, 64 Go de stockage presque pleins (photos et vidéos WhatsApp) |
| **Connexion** | Forfait mobile de 1,5 Go par semaine ; Wi-Fi du campus lent aux heures de pointe ; coupures de courant (délestages) plusieurs fois par semaine |
| **Ordinateur** | Un portable partagé avec son frère, disponible le soir seulement |
| **Outils actuels** | Groupe WhatsApp de la classe, un cahier, des captures d'écran du tableau d'affichage |

### Son quotidien

Awa suit sept cours ce semestre, dont trois assurés par des enseignants vacataires qui annoncent
les dates de rendu à l'oral en fin de séance ou par un message dans le groupe WhatsApp de la
classe. Ce groupe compte plus de 80 personnes : les annonces importantes y sont vite noyées sous
les messages. Awa note les échéances dans un cahier qu'elle n'a pas toujours sur elle, ou en
capture d'écran qu'elle ne retrouve plus. Elle travaille sérieusement, mais elle a déjà rendu
deux devoirs en retard ce semestre parce qu'elle avait mal noté la date.

### Ses difficultés

- Les échéances arrivent par plusieurs canaux (oral, WhatsApp, tableau d'affichage, e-mail).
- Elle n'a pas de vue d'ensemble de sa semaine et découvre les urgences trop tard.
- Son téléphone est lent et saturé : elle désinstalle les applications lourdes.
- Sa connexion est limitée et chère : elle évite les applications qui consomment des données.
- Les coupures de courant l'obligent à planifier le travail sur ordinateur à l'avance.

### Ses objectifs

- Ne plus jamais rater une date de rendu.
- Savoir chaque dimanche soir ce qui l'attend dans la semaine.
- Garder une application légère, utilisable même sans connexion.

> « Je ne suis pas désorganisée, c'est l'information qui est éparpillée. »

## Job stories

**Job story 1 — Capturer une échéance**

> **Quand** un enseignant annonce une date de rendu en fin de cours ou dans le groupe WhatsApp de
> la classe, **je veux** l'enregistrer en moins de 30 secondes avec le cours concerné, **pour** ne
> plus dépendre d'un message qui sera noyé dans le groupe.

*Conséquences pour la conception :* formulaire court (titre, cours, date), accessible en un geste
depuis l'écran principal (bouton flottant), validation immédiate, fonctionne hors ligne.

**Job story 2 — Préparer sa semaine**

> **Quand** je prépare ma semaine le dimanche soir, **je veux** voir d'un coup d'œil ce qui est à
> faire, ce qui est en retard et ce qui est déjà terminé, **pour** répartir mon travail en tenant
> compte des coupures de courant et de ma connexion limitée.

*Conséquences pour la conception :* écran Échéances trié par date, filtres « À faire / En retard /
Faites », retard signalé par un texte et une icône (pas seulement une couleur).
