# Séance 1 — TP 3 : Décision de plateforme pour CampusFlow

## Paragraphe de décision

CampusFlow cible les étudiants de licence et de master d'Afrique francophone, en commençant par
le Burkina Faso, qui suivent leurs cours, leurs échéances et leurs tâches sur un smartphone
Android d'entrée ou de milieu de gamme (2 à 4 Go de RAM, stockage souvent saturé, forfait de
données limité et réseau instable). **Nous développons d'abord pour Android, puis pour iOS, avec
une approche cross-platform en Flutter.** Android est prioritaire parce qu'il équipe environ
91 % des mobiles au Burkina Faso et 81 % en Afrique (fiche comparative, critère 11), qu'on peut le
développer et le tester avec les PC Windows dont nous disposons (critère 10) et que l'APK peut
aussi circuler hors du Play Store (critère 7). Nous ne renonçons pas pour autant à iOS : la
minorité d'étudiants sur iPhone sera servie par le même code Dart, dès qu'un Mac sera disponible
pour compiler et publier. Le choix du cross-platform plutôt que du natif vient de l'autopsie de
BlackBerry : la plateforme qui arrive tard et doit tout reconstruire perd ses utilisateurs ; une
base de code unique nous permet de sortir vite là où sont les étudiants, puis d'élargir sans
réécrire. Ce choix entraîne des exigences que tout le projet devra respecter : une application
légère (objectif < 20 Mo), compatible avec des versions anciennes d'Android, utilisable hors ligne
pour la consultation, économe en données, qui ne demande que la permission de notification et
qui suit les conventions Material Design 3 déjà familières aux utilisateurs.

## Résumé

| Élément | Décision |
|---------|----------|
| Cible | Étudiants de licence et master, Afrique francophone (Burkina Faso d'abord) |
| Appareil type | Smartphone Android d'entrée/milieu de gamme, 2–4 Go de RAM, écran 6,5" 720p |
| Plateformes | Android (prioritaire), puis iOS |
| Approche | Cross-platform avec Flutter (Dart), interface Material 3 |
| Exigences dérivées | Légèreté, version minimale d'Android ancienne, hors ligne en consultation, peu de données, une seule permission (notifications) |
