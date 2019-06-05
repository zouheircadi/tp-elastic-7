## Gestion des index
### Gestion Alias


###### Créer un premier index en mode autocréation avec la requête ci-dessous
```shell
POST /tp_elastic_151/_doc/_bulk
{ "index": { "_id": 1 }}
{"app_name" : "Photo Editor", "category" : "ART-AND-DESIGN", "last_updated" : "2018-01-06","rating" : 4.1}
{ "index": { "_id": 2 }}
{ "app_name" : "YouTube Kids", "category" : "FAMILY", "last_updated" : "2018-08-02", "rating" : 4.5}
{ "index": { "_id": 3 }}      
{ "app_name" : "Block Puzzle Classic Legend !","category" : "GAME", "last_updated" : "2018-07-22", "rating" : 4.7}
{ "index": { "_id": 4 }}      
{ "app_name" : "Marble Woka Woka 2018 - Bubble Shooter Match 3", "category" : "GAME", "last_updated" : "2018-08-02","rating" : 4.6}
```    

###### Créer un alias vers le 1er index
* Nom alias : tp_elastic_15
* Pointant vers l'index tp_elastic_151 
```shell
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_151", "alias" : "tp_elastic_15" } }
    ]
}
```

###### Tester-le en lecture avec un get sur une valeur précédemment indexée
Exemple : GET /tp_elastic_15/_doc/1

###### Tester-le en écriture sur l'alias
```shell
PUT /tp_elastic_15/_doc/5
{
    "app_name": "QR Code Reader",
    "category" : "TOOLS",
     "last_updated" : "2016-03-15",
     "rating" : 4.0
}
```

###### Créer un deuxième index en mode autocréation avec la requête ci-dessous
```shell
POST /tp_elastic_152/_doc/_bulk
{ "index": { "_id": 6 }}      
{ "app_name" : "Diabetes:M", "category" : "MEDICAL", "last_updated" : "2018-07-31", "rating" : 4.6}      
```

###### Faire pointer l’alias vers les 2 index avec
* le premier index tp_elastic_151 en lecture
* le deuxième index tp_elastic_152 en lecture/écriture

```shell
POST /_aliases
{
   "actions" : [
      { "add" : { "index" : "tp_elastic_151", "alias" : "tp_elastic_15" }},     
      { "add" : { "index" : "tp_elastic_152", "alias" : "tp_elastic_15","is_write_index":true}}
    ]
}
```

###### Lister les alias
```shell
GET /_alias/tp_elastic_15
```

###### Tester l'écriture sur l'alias (qui maintenant pointe sur deux index) avec la requête POST ci-dessous
```shell
PUT /tp_elastic_15/_doc/7
{
    "app_name": "Q Remote Control",
    "category" : "TOOLS",
     "last_updated" : "2014-07-11",
     "rating" : 3.8
}
```

###### Compter les données
* Dans l’alias
```shell
GET /tp_elastic_15/_count
```

* Dans le premier index
```shell
GET /tp_elastic_151/_count
```

* Dans le deuxième index
```shell
GET /tp_elastic_152/_count
```

###### Supprimer les alias
```shell
DELETE /tp_elastic_15*/_alias/tp_elastic_15
```

###### Vérifier qu’ils ont bien été supprimés. 
Une requête REST HEAD sur l'alias doit envoyer un code 
* 404 quand l'alias n'existe pas
* 200 si l'alias existe
```shell
HEAD /_alias/tp_elastic_15
```
