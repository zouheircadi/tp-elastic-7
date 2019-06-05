# Recherches
### Partial matching
#### Chargement du jeu d’essai

Le jeu d'essai consiste en une liste de pays tronquée à la lettre F. Le chargement peut se faire de deux manières différentes 
* DevTools Kibana.
    * Copier/Coller dans l'IDE Kibana-devTools les scripts et exécuter les commandes REST l'une après l’autre à partir du fichier ./data/post-data-1-devtools.txt
* Shell. 
    * Exécuter le shell ./data/post-data-1-curl.sh. Il contient les mêmes instructions que le fichier précédent encapsulées dans des commandes Curl
        * Suppression de l’index tp_elastic_pm1
        * Création de l’index tp_elastic_pm1 contenant deux champs code et country de type keyword 
        * Ajout des données sur le endpoint _bulk
