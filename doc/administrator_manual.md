# Manuel de l'administrateur

## Réinitialisation de la base de données

La réinitialisation n'a lieu qu'une fois par an et ne devrait pas vous concerner car elle sera faite par le général précédent. Si toutefois vous étiez amené à devoir vous en servir, voici la procédure.

La destruction des spés, génération de la nouvelle table des spés et l'envoi de l'e-mail de bienvenue se font depuis la même plateforme : /admin/seed

L'utilisation de chacune de ces fonctions est évidemment irréversible, et nécessite une vérification après l'activation, sur la page d'index d'administration.

Modifiant de façon irréversible la base de données, elle nécessite une autorisation de type "Général"

## Niveaux d'autorisation

#### Utilisateur

C'est le compte de Monsieur Tout-le-monde, il peut modifier les questions et ses points, etc.

Un utilisateur n'a pas accès à l'index d'administration : /admin

#### Lieutenant

Au plus deux par promotions, ils disposent d'une clé qui leur permet de consulter la liste des réponses des sups, leurs informations personnelles, et le nom de leur parrain.

N'a pas non plus accès à l'index d'administration.

Ce rôle est créé pour assister le dictateur lors de la soirée d'intégration pour conduire les sups à leur parrain, et vérifier que les réponses au questionnaire se font dans les règles. Il n'est normalement pas nécessaire de nommer de lieutenants, il s'agit uniquement d'une sécurité en vue d'un potentiel besoin futur.

#### Général

Un par promo, nommé par le général de l'année précédente.

Il est en charge du bon fonctionnement du site, des annonces, de l'envoi de mails à l'ensemble des utilisateurs lorsque cela est nécessaire, des différents verrouillages, de la suppression de questions, du réajustement des points, et du lancement du choix des parrains.

Il dispose pour cela de l'index d'administration: /admin

La clé général est révoquée, ainsi que tous les lieutenants qui en dépendent, au moment de l'activation de la clé du général suivant.

#### Dictateur

Un seul poste, non nécessairement renouvelé tous les ans.

Le dictateur a tous les droits sur le site et son code. Il est membre du groupe github autorisé à modifier le code source du projet et du groupe heroku autorisé à déployer ces modifications. Il peut créer et révoquer tous types de clés à tout instant, et peut modifier manuellement la base de données.

Le dictateur n'intervient normalement que lorsque des bugs sont constatés sur le serveur, qu'une modification non implémentée dans l'index d'administration doit avoir lieu, ou pour modifier manuellement une valeur de la base de données qui ne devrait pas pouvoir l'être dans le protocole habituel. Il n'a en théorie pas à intervenir du tout, mais il est nécessaire de conserver les droits de modification du code.

La nomination au poste de dictateur nécessite des connaissances poussées dans l'ensemble des langages qui constituent ce site et une maîtrise complète de son code source. Contactez votre dictateur si vous souhaitez proposer quelqu'un pour prendre sa relève.

## Consignes à l'attention des généraux

L'index d'administration recense tous les outils dont vous devriez avoir besoin, mais il nécessite quelques précautions à l'utilisation.

#### Verrouillages

Idéalement, les trois verrouillages devraient avoir lieu dans la même semaine, quelques jours avant la soirée d'intégration. L'idée est seulement d'empêcher le questionnaire de bouger sans arrêt, mais le gros du choix des questions devrait se faire en phase 1.

Pensez à signaler les verrouillages avec quelques jours d'avance, soit par mail, soit par une annonce sur le site, ou même les deux.

#### Questions à réponse multiples

Lorsque vous constatez qu'une question serait plus adaptée si on pouvait choisir plusiers réponses, vous pouvez lui ajouter le flag 'multiple'. Pour cela, allez dans la page de modification de la question, et relevez le numéro indiqué. Il s'agit de l'identifiant de la question, que vous devez reporter dans l'outil approprié sur l'index d'administration.

Pour inverser ce processus, répétez simplement l'opération, la question redeviendra à réponse unique.

Essayez de limiter le nombre de questions à réponses multiples, elles ont tendance à déséquiliber les calculs d'affinité, mais deux ou trois sont acceptables.

#### Rééquilibrage des points

Ceci ne devrait avoir lieu qu'une seule fois, un peu après l'entrée dans la phase 3.

Il sert uniquement à éviter les biais statistiques lors du calcul d'affinité, n'abusez pas de cette fonctionalité, il peut être désagréable pour les utilisateurs de voir leurs points sans arrêt modifiés.

Pensez encore une fois à prévenir qu'un rééquilibrage va avoir lieu.

#### Destruction de questions

À intervalles réguliers, il sera nécessaire de détruire les questions qui ont trop peu de votes (idéalement seulement celles à score négatif). Vous êtes seul juge de la limite de vote à détruire.

exemple : si vous choisissez de mettre une limite à 2 et lancer la destruction, toutes les question ayant un score inférieur ou égal à 2 seront détruites immédiatement et ne seront pas récupérables.

La proportion cumulée vous indique le pourcentage de questions que vous allez détruire si vous choisissez cette valeur, essayez de ne pas trop en détruire d'un coup si possible.

#### Création de clés

Vous pouvez, si cela est nécessaire, créer de nouvelles clés avec des niveaux d'accès différents (1 pour lieutenant, 2 pour général). Un code vous sera fourni au moment de la création. Il correspond au bon permettant de récupérer cette clé, et n'est utilisable qu'une seule fois. Transmettez ce bon à la personne en question, qui devra l'utiliser sur la page de connection : /admin/login pour récupérer sa clé. Le bon sera détruit au moment où la clé sera attribuée.

#### Logs et flicage

L'index d'administration vous donne accès à un certain nombre d'informations sur les utilisateurs. Ces informations sont utiles à la gestion du site, mais certains pourraient être stressés par le fait que quelqu'un y ait accès à leur insu. Merci de ne pas divulguer ces information autant que faire se peut. Dans la limite du possible, essayez simplement de ne pas donner aux utilisateurs la nature des informations auxquelles vous avez accès, afin d'éviter toute situation de ce genre. Gardez toutefois à l'esprit que les consignes de la présente page sont publiques, et que tout le monde est par conséquent autorisé à les consulter.

*Bonne chance pour votre année, et n'hésitez pas à contacter les développeurs si vous constatez quoi que ce soit qui pourrait être amélioré*
