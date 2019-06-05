## Gestion des index
### Autocréation d’index

Créer un index par injection de données
```shell
POST hol_devoxxfr_11/_doc/_bulk
{ "index": { "_id": 1 }}
{"app_name" : "Photo Editor", "category" : "ART-AND-DESIGN", "last_updated" : "2018-01-06","rating" : 4.1}
{ "index": { "_id": 2 }}
{ "app_name" : "YouTube Kids", "category" : "FAMILY", "last_updated" : "2018-08-02", "rating" : 4.5}
{ "index": { "_id": 3 }}      
{ "app_name" : "Block Puzzle Classic Legend !","category" : "GAME", "last_updated" : "2018-07-22", "rating" : 4.7}
{ "index": { "_id": 4 }}      
{ "app_name" : "Marble Woka Woka 2018 - Bubble Shooter Match 3", "category" : "GAME", "last_updated" : "2018-08-02","rating" : 4.6}
{ "index": { "_id": 5 }}      
{ "app_name" : "QR Code Reader", "category" : "TOOLS", "last_updated" : "2016-03-15", "rating" : 4.0}
{ "index": { "_id": 6 }}      
{ "app_name" : "Diabetes:M", "category" : "MEDICAL", "last_updated" : "2018-07-31", "rating" : 4.6}
```


Afficher les caractéristiques de l’index nouvellement créé
```shell
GET /hol_devoxxfr_11
```

Si on fait un parallèle avec les bases de données relationnelles, tout se passe comme si un insert entrainait la création du schéma avec une inférence des types.
* les chaines de caractères sont mappées simultanément de deux façons dirrérentes
    * type text : chaine de caractère analysée
    * type keyword : chaine de caractère stockée sans modification
* les chaines de caractères qui obéïssent à un template donné sont converties en date
* ... 

Le [mode autocréation](https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-index_.html) est autorisé par défaut. Pour l'interdir, il faut passer la propriété action.auto_create_index à false dans le fichier $INSTALL_DIR/config/elasticsearch.yml ou via l'API _cluster


Résultat de sortie
```json
{
  "hol_devoxxfr_11" : {
    "aliases" : { },
    "mappings" : {
      "_doc" : {
        "properties" : {
          "app_name" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "category" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "last_updated" : {
            "type" : "date"
          },
          "rating" : {
            "type" : "float"
          }
        }
      }
    },
    "settings" : {
      "index" : {
        "creation_date" : "1552820707231",
        "number_of_shards" : "5",
        "number_of_replicas" : "1",
        "uuid" : "9su2-VrDSkuIY0eBtEB55A",
        "version" : {
          "created" : "6060099"
        },
        "provided_name" : "hol_devoxxfr_11"
      }
    }
  }
}
```
