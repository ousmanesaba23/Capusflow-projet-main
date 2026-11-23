// Serveur simulé de CampusFlow avec authentification par jeton (séance 7).
//
//  - POST /login  { email, password }  ->  { token, user }   (401 si refusé)
//  - Toutes les autres routes exigent l'en-tête  Authorization: Bearer <jeton>
//    sinon le serveur répond 401.
//
// Les jetons sont gardés en mémoire : redémarrer le serveur les invalide,
// ce qui permet de tester la redirection vers l'écran de connexion.
const crypto = require('crypto');
const path = require('path');
const jsonServer = require('json-server');

const PORT = Number(process.env.PORT || 3000);
const HOST = process.env.HOST || '127.0.0.1';

const server = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
const tokens = new Map(); // jeton -> id de l'utilisateur

server.use(jsonServer.defaults()); // CORS, journal des requêtes, etc.
server.use(jsonServer.bodyParser);

server.post('/login', (req, res) => {
  const { email, password } = req.body || {};
  const user = router.db.get('utilisateurs').find({ email, password }).value();
  if (!user) {
    return res.status(401).json({ error: 'Identifiants invalides' });
  }
  const token = crypto.randomBytes(24).toString('hex');
  tokens.set(token, user.id);
  const { password: _motDePasse, ...publicUser } = user;
  return res.json({ token, user: publicUser });
});

// Garde : tout le reste de l'API exige un jeton valide.
server.use((req, res, next) => {
  if (req.method === 'OPTIONS') return next();
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : '';
  if (!tokens.has(token)) {
    return res.status(401).json({ error: 'Non authentifié' });
  }
  return next();
});

// Les mots de passe ne doivent jamais sortir du serveur.
server.use('/utilisateurs', (req, res) => {
  res.status(403).json({ error: 'Accès interdit' });
});

server.use(router);

server.listen(PORT, HOST, () => {
  console.log(`API CampusFlow sur http://${HOST}:${PORT}`);
  console.log('Compte de démonstration : awa@campus.bf / campus2026');
});
