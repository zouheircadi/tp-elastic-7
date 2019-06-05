## Gestion des index
### Suppression index


###### Supprimer l’index tp_elastic_152
```shell
DELETE /tp_elastic_152
```    

###### Vérifier qu’il l’a bien été en testant son existence 
Une requête REST HEAD sur l'alias doit envoyer un code 
* 404 quand l'alias n'existe pas
* 200 si l'alias existe
```shell
HEAD /tp_elastic_152
```
