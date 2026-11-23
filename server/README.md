# Serveur simulé de CampusFlow (séance 7)

`json-server` transforme [db.json](db.json) en API REST complète.
[server.js](server.js) y ajoute une connexion par jeton.

```bash
cd server
npm install              # une seule fois
npm start                # API avec authentification (utilisée par l'application)
npm run start:sans-auth  # json-server brut : /taches lisible dans le navigateur
```

L'API écoute sur `http://127.0.0.1:3000`.

## Routes

| Méthode | Adresse | Effet |
|---------|---------|-------|
| POST | `/login` | `{ "email", "password" }` → `{ "token", "user" }`, ou 401 |
| GET | `/taches` | Liste des tâches |
| GET | `/taches/1` | Une tâche |
| POST | `/taches` | Crée une tâche |
| PATCH | `/taches/1` | Modifie une partie d'une tâche (ex. `{"done": true}`) |
| DELETE | `/taches/1` | Supprime une tâche |
| GET | `/cours` | Liste des cours |

Avec `npm start`, toutes les routes sauf `/login` exigent l'en-tête
`Authorization: Bearer <jeton>` ; sans jeton valide, la réponse est **401**. Les jetons sont
gardés en mémoire : **redémarrer le serveur les invalide**, ce qui permet de vérifier que
l'application renvoie vers l'écran de connexion.

Compte de démonstration : `awa@campus.bf` / `campus2026`.

## Depuis l'émulateur Android

Le serveur s'appelle par **`http://10.0.2.2:3000`** : `localhost` désigne l'émulateur
lui-même, pas le PC.

Le serveur écoute sur `127.0.0.1` (et non `localhost`) : avec Node 17 et plus, `localhost`
peut se résoudre en IPv6 (`::1`), que l'adresse `10.0.2.2` de l'émulateur n'atteint pas.
Pour un vrai téléphone sur le même Wi-Fi, lancer `HOST=0.0.0.0 npm start` et passer l'IP du PC
à l'application : `flutter run --dart-define=API_URL=http://192.168.x.x:3000`.
