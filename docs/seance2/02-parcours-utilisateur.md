# Séance 2 — TP 5 : Parcours utilisateur « Suivre mes échéances »

Persona : **Awa Ouédraogo** (voir [persona et job stories](01-persona-job-stories.md)).

| # | Étape | Action d'Awa | Friction rencontrée | Opportunité pour CampusFlow |
|---|-------|--------------|---------------------|-----------------------------|
| 1 | **Planifier** | Le dimanche soir, elle passe en revue ses cours et ce qu'elle doit rendre dans la semaine. | Les informations sont dispersées entre son cahier, WhatsApp et des captures d'écran ; elle ne sait pas si sa liste est complète. | Un écran Échéances unique, trié par date, qui regroupe toutes les tâches de tous les cours. |
| 2 | **Consulter** | Entre deux cours, elle vérifie ce qui est urgent. | Le réseau du campus est saturé ; les applications qui chargent tout depuis Internet restent bloquées sur un écran vide. | Afficher immédiatement les dernières données connues, avec les filtres « À faire / En retard / Faites » et un indicateur clair des retards. |
| 3 | **Ajouter** | En fin de cours, l'enseignant annonce un TP à rendre vendredi ; elle veut le noter avant de partir. | Elle a peu de temps, les mains occupées, et doit retrouver le nom exact du cours. | Bouton « + » toujours visible, formulaire de 3 champs (titre, cours, date), cours proposés dans une liste, message de confirmation. |
| 4 | **Être rappelée** | La veille de l'échéance, elle doit penser à finir son travail. | Son téléphone tue les applications en arrière-plan pour économiser la batterie ; les rappels n'arrivent pas toujours. | Notification locale programmée et, à chaque ouverture, mise en avant des tâches dues dans les 48 h (badge « J-1 », « En retard »). |
| 5 | **Rendre** | Elle dépose son devoir puis veut le rayer de sa liste. | Rien ne marque la tâche comme terminée ; elle se demande plus tard si elle l'a bien rendue. | Bouton principal « Marquer comme fait » sur l'écran Détail ; la tâche passe dans le filtre « Faites », visible aussitôt dans tous les écrans. |

## Ce que le parcours apprend

- Les étapes **Consulter** et **Ajouter** se font en mobilité, en quelques secondes : elles
  dictent la simplicité de l'écran principal et du formulaire.
- L'étape **Être rappelée** est la plus fragile techniquement sur les téléphones Android
  d'entrée de gamme : la fiche comparative (critère 13) l'avait signalé.
- L'étape **Rendre** justifie un état partagé : cocher une tâche dans le détail doit la mettre à
  jour immédiatement dans la liste et dans les filtres (séance 6).
