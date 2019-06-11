## Les agrégations
### Corpus Google playstore


###### Recherchez les applications ayant les tokens network social ou dating dans le app_name
* 1.1 - Avec une agrégation sur le champ category

```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": {
    "categories": {
      "terms": {
        "field": "category.keyword",
        "size": 10
      }
    }
  }
}
```

* 1.2 - Trier la requête précédente sur la key  
```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": {
    "categories": {
      "terms": {
        "field": "category.keyword",
        "size": 10,
        "order": {
          "_key": "asc"
        }
      }
    }
  }
}
```

* 2.1 - Avec une agrégation sur le champ rating sur l’étendu des valeurs possibles avec un intervalle de 1

```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": {
    "ratings" : 
    {
      "histogram": {
        "field": "rating",
        "interval": 1
      }
    }
  }
}
```


* 2.2 - Trier la requête précédente sur le doc_count  
```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": {
    "ratings" : 
    {
      "histogram": {
        "field": "rating",
        "interval": 1,
        "order": {
          "_count": "desc"
        }
      }
    }
  }
}
```


* 3 Avec une aggregation sur le rating pour les intervalles ci-dessous
    * strictement inférieure à 4.0, 
    * entre 4.0 et 4.5, 
    * supérieure ou égale à 4.5

        * 3.1 - le tri se fait sur l'ordre alphanumérique des clés

```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": {
    "filtered-ratings" : 
    {
      "filters": {
        "filters": {
          "low"    :{ "range": { "rating": { "lt": 4 }}},
          "Medium" :{ "range": { "rating": { "gte": 4 , "lt": 4.5}}},
          "high"   :{ "range": { "rating": { "gte": 4.5 }}}
        }
      }
    }
  }
}
```
* * * 3-2 Nommage des clés pour bénéficier du tri alphanumérique
        
```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": {
    "filtered-ratings" : 
    {
      "filters": {
        "filters": {
          "1-low"    :{ "range": { "rating": { "lt": 4 }}},
          "2-medium" :{ "range": { "rating": { "gte": 4 , "lt": 4.5}}},
          "3-high"   :{ "range": { "rating": { "gte": 4.5 }}}
        }
      }
    }
  }
}
```

*  4 Avec l’agrégation 1 (category : agrégation mère) à laquelle on imbrique l’agrégation 3 (agrégation fille)
```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": {
    "categories": {
      "terms": {
        "field": "category.keyword",
        "size": 5
      },
      "aggs": {
        "filtered-ratings" : 
        {
          "filters": {
            "filters": {
              "1-low"    :{ "range": { "rating": { "lt": 4 }}},
              "2-medium" :{ "range": { "rating": { "gte": 4 , "lt": 4.5}}},
              "3-high"   :{ "range": { "rating": { "gte": 4.5 }}}
            }
          }
        }
      }
    }
  }
}
```

###### Combien d’application ayant music dans le champ app_name ont un rating de 4.5 ou plus ?

* Avant la version 7, on pouvait le faire avec un filtre
```
GET /tp_elastic_gstore/_search
{
  "size": 10,
  "query": 
  {
    "bool": 
    {
      "must": [
        {"match": {
          "app_name": "music"
        }}
      ],
      "filter": 
      {
        "range": {
          "rating": {
            "gte": 4.5
          }
        }
      }
    }
  }
}
```

* Si la version est supérieure à la 6, il faut le faire avec une agrégation
```
GET /tp_elastic_gstore/_search
{
  "size": 0,
  "query": 
  {
    "match": {
      "app_name": "music"
    }
  },
  "aggs": {
    "filtered-ratings" : 
    {
      "filters": {
        "filters": {
          "3-high"   :{ "range": { "rating": { "gte": 4.5 }}}
        }
      }
    }
  }
}
```

###### Quel est le nombre d’applications agrégées par tranche de 3 mois pour l’année 2017 ?
```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "bool": 
    {
      "filter": 
      {
        "range": {
          "last_updated": {
            "gte": "2016-12-31T23:59:59.000Z",
            "lt": "2018-01-01T00:00:00.000Z"
          }
        }
      }
    }
  }, 
  "aggs": {
    "minmax" : 
    {
      "date_histogram": {
        "field": "last_updated",
        "interval": "quarter"
      }
    }
  }
}
```

##### Metrics
######  Trouver la plus petite et la plus grande valeur pour le champ last_updated ?
```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "aggs": {
    "min" : 
    {
      "min": {
        "field": "last_updated"
      }
    },
    "max" : 
    {
      "max": {
        "field": "last_updated"
      }
    }
  }
}
```

###### Reprendre le 4 et ajouter la moyenne pour chaque sous-imbrication
```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": 
  {
    "categories": 
    {
      "terms": 
      {
        "field": "category.keyword",
        "size": 5
      },
      "aggs": {
        "filtered-ratings" : 
        {
          "filters": {
            "filters": {
              "1-low - x < 4"    :{ "range": { "rating": { "lt": 4 }}},
              "2-medium - 4 < x <= 4.5" :{ "range": { "rating": { "gte": 4 , "lt": 4.5}}},
              "3-high - x > 4.5"   :{ "range": { "rating": { "gte": 4.5 }}}
            }
          },
            "aggs": 
            {
              "avg_rating": {"avg": {"field": "rating"}}
            }          
        }
      }
    }
  }
}
```

###### Rechercher les documents 
* qui contiennent  "network social dating" dans le champ app_name 
* puis agrégez les par catégories (limité à 5) 
* et trouver la note moyenne (rating) pour chaque category

```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": 
  {
    "categories": 
    {
      "terms": 
      {
        "field": "category.keyword",
        "size": 5
      },
      "aggs": {
        "avg_rating": {
          "avg": {
            "field": "rating"
          }
        }
      }
    }
  }
}
```

###### Rechercher les documents 
* qui contiennent  "network social dating" dans le champ app_name 
* puis agrégez les par catégories (limité à 5) 
* et afficher les statistiques étendues (extended_stats) pour chaque category
```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "query": 
  {
    "match": {
      "app_name": "network social dating"
    }
  },
  "aggs": 
  {
    "categories": 
    {
      "terms": 
      {
        "field": "category.keyword",
        "size": 5
      },
      "aggs": {
        "avg_rating": {
          "extended_stats": {
            "field": "rating"
          }
        }
      }
    }
  }
}
```