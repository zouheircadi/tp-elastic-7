## Les agrégations
### Corpus Google playstore


###### a- Recherchez les applications ayant les tokens network social ou dating dans le app_name
* a-1-1 - Avec une agrégation sur le champ category

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

* a-1-2 - Trier la requête précédente sur la key  
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

* a-2.1 - Avec une agrégation sur le champ rating sur l’étendu des valeurs possibles avec un intervalle de 1

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


* a-2.2  Trier la requête précédente sur le doc_count  
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


* a-3 Avec une aggregation sur le rating pour les intervalles ci-dessous
    * strictement inférieure à 4.0, 
    * entre 4.0 et 4.5, 
    * supérieure ou égale à 4.5

        * a-3-1 - le tri se fait sur l'ordre alphanumérique des clés

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
* * * a-3-2 Nommage des clés pour bénéficier du tri alphanumérique
        
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

*  a-4 Avec l’agrégation 1 (category : agrégation mère) à laquelle on imbrique l’agrégation 3 (agrégation fille)
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

###### b- Combien d’application ayant music dans le champ app_name ont un rating de 4.5 ou plus ?
Cet exercice a pour but de mettre en évidence une contrainte apparue dans Elasticsearch depuis la version 7
* b-1 Avant la version 7, on pouvait le faire avec un filtre
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

* b-2 Si la version est supérieure à la 6, le moteur ne garantit plus la précision du nombre de hits (par défaut au delà de 10000). Il est possible de le faire avec une agrégation.  Voir documentation officielle sur [track total hits](https://www.elastic.co/guide/en/elasticsearch/reference/master/search-request-track-total-hits.html)
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

###### c- Quel est le nombre d’applications agrégées par tranche de 3 mois pour l’année 2017 ?
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
######  d- Trouver la plus petite et la plus grande valeur pour le champ last_updated ?
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

###### e- 
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

###### f

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

###### g
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


###### deep metrics

###### h

```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "aggs": {
    "download": {
      "terms": {
        "field": "installs.keyword",
        "size": 10,
        "order": {
          "categories>average": "desc"
        }
      },
      "aggs": {
        "categories": 
        {
          "filter": 
          {
            "term": {
              "category.keyword": "GAME"
            }
          },
          "aggs": {
            "average": {
              "avg": {
                "field": "rating"
              }
            }
          }
        }
      }
    }
  }
}
```
###### bucket_sort
###### x
* Faites une agrégation de type terms sur le champ download 
* puis une autre agrégation imbriquée sur de type filters sur les champs category pour le termes FAMILY, GAME et TOOLS
* puis une agrégation imbriquée de type average sur le champ rating (moyennes par categorie)
* et faites un bucket_sort sur les moyennes avec un size de 3

```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "aggs": {
    "downloads": {
      "terms": {
        "field": "installs.keyword",
        "size": 20
      },
      "aggs": 
      {
        "ratings" : 
        {
          "terms": 
          {
            "field": "category.keyword",
            "size": 10
          },
          "aggs": 
          {
            "average_rating": 
            {
              "avg": {"field": "rating"}
            },
            "custom_bs" :
            {
              "bucket_sort": {
                "sort": 
                [
                  {"average_rating" : {"order": "desc"}}
                ],
                "size": 2
              }
            }
          }
        }
      }
    }
  }
}
```


###### j
* Faites une agrégation de type terms sur le champ download 
* puis une autre agrégation imbriquée de type terms sur le champ category avec un size de 10
* puis une agrégation imbriquée de type average sur le champ rating (moyennes par categorie)
* et faites un bucket_sort sur les moyennes avec un size de 5

```
GET /tp_elastic_gstore/_search
{
  "size": 0, 
  "aggs": {
    "downloads": {
      "terms": {
        "field": "installs.keyword",
        "size": 20
      },
      "aggs": 
      {
        "ratings" : 
        {
          "terms": 
          {
            "field": "category.keyword",
            "size": 10
          },
          "aggs": 
          {
            "average_rating": 
            {
              "avg": {"field": "rating"}
            },
            "custom_bs" :
            {
              "bucket_sort": {
                "sort": 
                [
                  {"average_rating" : {"order": "desc"}}
                ],
                "size": 5
              }
            }
          }
        }
      }
    }
  }
}
```