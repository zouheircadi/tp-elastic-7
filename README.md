
# Cluster - capacity planning

## Taille de stockage de N documents ?

### Index avec un mapping par défaut


#### Create template
```json
PUT /_template/template_capacity_planning
{
  "index_patterns" : ["tp_elastic_gstore_cp*"],
  "settings": 
  {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
```

#### Delete all index
```
DELETE tp_elastic_gstore_c*
```

#### Load Data
```shell script
./bin/logstash   -f ./<$PATH_TO>/ls-google-playstore.conf
```

#### Mapping control
```
GET tp_elastic_gstore_cp
```
* Le mapping est inféré. Il est représenté ci-dessous (partie mappings). Tous les champs de type text ont un double mapping text et keyword limité à 256 caractères

```json
{
  "tp_elastic_gstore_cp" : {
    "aliases" : { },
    "mappings" : {
      "properties" : {
        "@timestamp" : {
          "type" : "date"
        },
        "android_ver" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
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
        "content_rating" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "current_ver" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "genres" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "installs" : {
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
        "price" : {
          "type" : "float"
        },
        "rating" : {
          "type" : "float"
        },
        "reviews" : {
          "type" : "long"
        },
        "size" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        },
        "type" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        }
      }
    }
  }
}
```


```
GET tp_elastic_gstore_cp/_count
```

```
GET tp_elastic_gstore_cp/_flush
```


```
POST /tp_elastic_gstore_cp1/_forcemerge?max_num_segments=1
```

```
GET tp_elastic_gstore_cp/_flush
```

#### Faites une statistique rapide de la taille de l'unique shard pour cet index (api _cat)

##### Query
```
GET /_cat/shards/tp_elastic_gstore_cp?v
```

##### Réponse
```
index                 shard prirep state     docs  store ip        node
tp_elastic_gstore_cp 0     p      STARTED 100000 18.2mb 127.0.0.1 iPro-de-zouheir
```

#### Faites une statistique détaillée des caractéristiques de ce index (api _stats)


```
GET /tp_elastic_gstore_cp/_stats
```

* Contrôler bien qu'il ne reste plus qu'un seul segment
* Récupérer la taille des documents (champ "size_in_bytes")
 
 
#### Résultats 
L'idée n'est pas d'avoir exactement les mêmes chiffres mais plutot de comparer la variation de la taille en fonction de différents types d'indexation.

* ES Version 7.3.1
    *  100.000        =>  17522189 bytes
    *  100.000.000    =>  (17522189*1000) / (1024*1024*1024) = 16,3  gb
    *  pendant  30 jours 480 gb
 

* ES Version 7.6.2
    *  100.000        =>  17049761 bytes
    *  100.000.000    =>  (17049761*1000) / (1024*1024*1024) = 15,9  gb
    *  pendant  30 jours 476 gb 
 
 
### Index personnalisé 2

Pour les index dont le mapping n'est pas inféré (au moins en partie), la procédure est la suivante

#### Supprimer les index précédents
```
DELETE tp_elastic_gstore_c*
```

#### Créer l'index avec le mapping fourni
```json
PUT tp_elastic_gstore_cpx
{
  "mappings": 
  {
        "properties" : 
        {
          ...                              
        }
  }
}
```

#### Créer l'alias 
* Remplacer le x par la version de l'index testé
```
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_cpx", "alias" : "tp_elastic_gstore_cp" } }
    ]
}
```


#### Charger les données
```shell script
./bin/logstash   -f ./<$PATH_TO>/ls-google-playstore.conf
```

Pour l'index personnalisé 2, les resultats sont indiqués ci-dessous
* 7.3.1
    *  100.000        =>  17858883  bytes
    *  100.000.000    =>  (17858883*1000) / (1024*1024*1024) = 16,63  gb
    *  pendant  30 jours 499 gb


* *7.6.2
    *  100.000        =>  17335363  bytes
    *  100.000.000    =>  (17335363*1000) / (1024*1024*1024) = 16,1  gb
    *  pendant  30 jours 480 gb



### Index personnalisé 3

* 7.3.1
    *  100.000        =>  27879840  bytes
    *  100.000.000    =>  (27879840*1000) / (1024*1024*1024) = 25,96  gb
    *  pendant  30 jours 779 gb
    
* 7.6.2
    *  100.000        =>  27277207  bytes
    *  100.000.000    =>  (27277207*1000) / (1024*1024*1024) = 25,4  gb
    *  pendant  30 jours 750 gb    


### Index personnalisé 4

* 7.3.1
    *  100.000        =>  15108285  bytes
    *  100.000.000    =>  (15108285*1000) / (1024*1024*1024) = 14,07  gb
    *  pendant  30 jours 422 gb

* 7.6.2
    *  100.000        =>  14682805  bytes
    *  100.000.000    =>  (14682805*1000) / (1024*1024*1024) = 13,6  gb
    *  pendant  30 jours 410 gb


### Bilan
Bilan des résultats

|        Type de mapping              | Numéro index  | Espace disque (GB)  |
| ----------------------------- |:-------------:|:-------------:|
| Mapping personnalisé simple   | Exercice 4    |    410        |
| Mapping inféré                | Exercice 1    |    476        |
| Mapping mixte simple          | Exercice 2    |    480        |
| Mapping mixte complexe        | Exercice 3    |    750        |

### Conclusion
Pour ce test
* Penser à bien passer l'option max_num_segments=1 dans le forcemerge. 
* L'exercice proposé est un cas d'école. Pour un test de sizing, essayer d'injecter une quantité importante et non redondante de données (le plus possible tout en restant sur des temps de chargement raisonnables). 
* Noter que l'espace disque pris par l'index dépend du mapping. Plus le mapping est complexe, plus la taille de l'index sera importante
* Ne pas se fier aux ratios. Faire des tests avec des données et un mapping analogues à la production. 
* L'infrastructure doit également être proche de la production (OS, versions d'Elasticsearch, ...) 
