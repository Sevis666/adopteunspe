## Fonctionnement général

L'idée est simple : chacun propose des questions sur le site, et affecte un nombre de points à chaque réponse. Lorsqu'un sup choisit sur le questionnaire une réponse, il gagne envers vous le nombre de points que vous aviez mis sur cette réponse. Après avoir rempli tout le questionnaire, il dispose donc d'une table d'affinité avec l'ensemble des spés : plus il a de points envers vous, et plus il est probable que vous soyez son parrain.

Mais choisir les questions, c'est difficile, alors pour que ce soit moins le bazar, on a introduit des votes : tout le monde peut proposer ses questions, et voter pour ou contre les questions proposées, avec les petites flèches vertes et rouges. La couleur de la bordure vous indique ce que vous avez voté. Les questions validées par presque tout le monde feront partie du questionnaire final, et les autres seront supprimées.

Sauf qu'on a encore un problème : il y a plein de questions qui sont drôles à poser, mais qui ne permettent pas vraiment de choisir un parrain, alors on a introduit encore un paramètre : le coefficient. Chacun choisit pour chaque question un entier entre 1 et 10 correspondant au coefficient qu'il souhaite affecter à la question dans le calcul d'affinité, qui figure dans la petite case grisée. Comme ça, une question avec beaucoup de votes et un coefficient de 1 sera bien posée aux sups, mais ne modifiera que peu les tables d'affinités, alors tout le monde est content.

## Phases de verrouillage

Le but étant au bout d'un moment d'arrêter de toucher à tout pout converger vers un questionnaire avec lequel tout monde est d'accord, la construction se déroulera en quatre phases.

#### Phase 1 : Open bar

Tout le monde peut ajouter ou modifier des questions, des réponses, ses points, tout. Proposez toutes vos idées, c'est le moment.

#### Phase 2 : Verrouillage des questions

Les questions ne pourront plus être ajoutées ni modifiées, mais on peut toujours toucher aux réponses et déplacer son capital de points. Les questions qui n'obtiennent pas suffisamment de votes continuent d'être supprimées.

#### Phase 3 : Verrouillage des réponses

On approche de la fin, le questionnaire est verrouillé, il faut dans cette phase ajuster vos points pour chaque question, mais cette fois vous êtes sûrs que plus rien ne va bouger.

#### Phase 4 : Verrouillage des points

Cette fois tout sera verrouillé, la page d'acceuil du site va changer, pour être remplacée par le questionnaire, et la base de données sera réinitialisée pour enlever les faux utilisateurs que vous avez pu créer dans le mode preview.

## Conseils complémentaires

#### Répartition des points

Les points, c'est comme la confiture, ça s'étale, il est rare qu'une seule réponse vous corresponde, préférez répartir vos points entre les différentes réponses qui vous correspondent même seulement un peu.
Pour éviter tout biais statistique lors du choix des parrains, la somme de vos points sur chaque question sera ramenée à 120 en conservant les proportions que vous aviez choisies. Essayez donc tout de suite de répartir exactement 120 points, ça vous évitera de mauvaises surprise au moment de l'ajustement des points.

#### Pondération des questions
Les coefficients suggérés sont les suivants :

+ 7 à 10 pour les questions qui traitent des centres d'intérêt, de la présence, des méthodes de travail, etc.
+ 4 à 6 pour les blagues qui donnent tout de même des renseignements utiles sur les goûts
+ 1 à 3 pour les private jokes et autres questions auxquelles les sups ne connaissent rien

#### Cumul des votes

Vous pouvez voter contre une question <u>et</u> lui affecter un petit coefficient.
Elle sera peut être retirée, et si elle ne l'est pas, votre coefficient compte dans dans le calcul de la pondération de la question
Suppression des trolls
Si certaines personnes votent de façon étrange, disproportionnée, ou surcoefficientent leurs questions, leur vote sera ignoré lors du calcul final des coefficients, alors ne vous fiez pas trop à la moyenne.

## Description de l'interface

#### Les questions

Les questions sont triées sur cette page dans leur ordre d'apparition.

Chaque question est représentée par une boîte : la partie grisée contient l'énoncé de la question, la partie blanche les réponses, séparées par des barres horizontales. À côté de chaque réponse se trouve le nombre de points que vous avez placé dessus, ou "-" s'il n'y en a aucun.

Une icône avec un petit crayon à côté de l'énoncé de la question permet d'accéder à la page de modification de la question.

Le boîtier flottant au dessus de la question indique le nombre de votes pour cette question, et son coefficient. Vous pouvez voter pour ou countre avec les flèches, et la couleur du contour vous indiquera ce que vous avez voté. La case grisée est le coefficient que vous avez affecté à cette question, et elle contient "-" si vous avez mis 0, ce qui équivaut à s'abstenir. La case blanche à côté du coefficient indique le coefficient moyen choisi à l'heure actuelle.

Les commentaires sur chaque question figurent dans le boîtier flottant en dessous de la question. Vous pouvez écrire votre commentaire dans la boîte de dialogue, et votre nom sera automatiquement ajouté en face lors de l'envoi. Lorsqu'aucun commentaire n'est présent, le boîtier ne s'affiche pas, mais vous pouvez aller sur la page de modification de la question pour ajouter le premier commentaire.

Si vous cliquez sur l'énoncé de la question, vous pourrez afficher/cacher les points que les autres ont placé sur chaque réponse, pour vous donner une idée de comment voter.

Vous pouvez sauter du haut de la page tout en bas et inversement au moyen des petites flèches sur la droite de la page.

#### Filtrage

Pour vous faciliter la tâche, vous pouvez choisir de n'afficher que les questions pour lesquelles vous n'avez pas voté, pas choisi de coefficient, ou pour lesquelles votre total de points ne correspond pas à votre capital complet.

Deux de ces modes de filtrage vous permettent aussi d'echaîner les questions. Ceci vous permet de passer directement à la modification de la question suivante de la catégorie de filtrage choisie, sans repasser par la liste des questions, pour aller plus vite si vous voulez faire plein de questions d'un coup.

#### Les annonces

Si des informations complémentaires devaient vous être données sur le site, elles figureraient sur cette page, et un petit message s'afficherait sur la liste des questions pour vous inviter à aller consulter cette page. À priori cela ne devrait pas se produire, sauf pour signaler les dates auxquelles chaque verrouillage aura lieu.

#### La preview

Vous pouvez visualiser la page d'acceuil et le questionnaire tels qu'ils seront présentés aux sups. Vous pouvez créer sans crainte de faux utilisateurs avant le verrouillage des points, ils seront effacés de toute façon. À partir de l'entrée dans la phase 4 en revanche, le questionnaire ne doit être rempli plus que par les sups.

## Bugs et autres désagréments

Ce site ayant été écrit à l'arrache deux semaines avant la soirée d'intégration de la première année où il a été mis en place, puis patché tant bien que mal par le même illuminé pendant ses oraux à Centrale, il est très fortement probable qu'il grouille encore de petits bugs. N'hésitez pas à les signaler à l'adresse suivante : <a href="mailto:david.robin97@gmail.com">david.robin97@gmail.com</a>

Si vous avez des idées d'améliorations, ou si vous souhaitez mettre à profit vos compétences en informatique pour la maintenance du site, écrivez moi aussi, ou envoyez directement des pull requests sur mon github.

*Merci d'avoir pris le temps lire jusqu'ici, je n'ai malheureusement pas de patate à vous offrir, mais je vous souhaite quand même bonne chance pour votre année, et amusez vous bien*
