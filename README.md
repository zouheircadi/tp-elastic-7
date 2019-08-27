## Recherches full-text
### Recherches sur un champ unique


#### Match query
Quels sont les documents qui contiennent le terme draw dans le champ app_name ?
```shell
GET tp_elastic_mq/_search
{
  "query": 
  {
    "match": {
      "app_name": "draw"
    }
  }
}
      
```    

#### Comprendre le score - recherche d’un terme unique 
Comment se décompose le score du premier document trouvé pour la requête précédente ?


###### Explain sur tous les documents
```shell
GET tp_elastic_mq/_search?explain=true
{
  "query": 
  {
    "match": {
      "app_name": "draw"
    }
  }
}      
```   
###### Explain pour le document d'identifiant 3
GET /tp_elastic_mq/_explain/3
{
  "query": 
  {
    "match": {
      "app_name": "draw"
    }
  }
}


Décomposition du score du premier document remonté qui a le score le plus élevé (la sortie JSON détaillée est également indiquée ci-dessous) 
* 0.15461528 = 
    * 0,13353139 => idf log(1 + (docCount - docFreq + 0.5) / (docFreq + 0.5))
    * (*)
    *  1,1578947 => tf (freq * (k1 + 1)) / (freq + k1 * (1 - b + b * fieldLength / avgFieldLength))


Résultat de la requête avec un explain
```json
{
  "took" : 26,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 0.15461528,
    "hits" : [
      {
        "_shard" : "[tp_elastic_mq][0]",
        "_node" : "YgaDyGWxQ86eKKynrH5QdQ",
        "_index" : "tp_elastic_mq",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 0.15461528,
        "_source" : {
          "app_name" : "draw figure"
        },
        "_explanation" : {
          "value" : 0.1546153,
          "description" : "weight(app_name:draw in 2) [PerFieldSimilarity], result of:",
          "details" : [
            {
              "value" : 0.1546153,
              "description" : "score(doc=2,freq=1.0 = termFreq=1.0\n), product of:",
              "details" : [
                {
                  "value" : 0.13353139,
                  "description" : "idf, computed as log(1 + (docCount - docFreq + 0.5) / (docFreq + 0.5)) from:",
                  "details" : [
                    {
                      "value" : 3.0,
                      "description" : "docFreq",
                      "details" : [ ]
                    },
                    {
                      "value" : 3.0,
                      "description" : "docCount",
                      "details" : [ ]
                    }
                  ]
                },
                {
                  "value" : 1.1578947,
                  "description" : "tfNorm, computed as (freq * (k1 + 1)) / (freq + k1 * (1 - b + b * fieldLength / avgFieldLength)) from:",
                  "details" : [
                    {
                      "value" : 1.0,
                      "description" : "termFreq=1.0",
                      "details" : [ ]
                    },
                    {
                      "value" : 1.2,
                      "description" : "parameter k1",
                      "details" : [ ]
                    },
                    {
                      "value" : 0.75,
                      "description" : "parameter b",
                      "details" : [ ]
                    },
                    {
                      "value" : 3.0,
                      "description" : "avgFieldLength",
                      "details" : [ ]
                    },
                    {
                      "value" : 2.0,
                      "description" : "fieldLength",
                      "details" : [ ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      }
    ]
  }
}
```


#### OR
Quels sont les documents qui contiennent les termes draw ou art dans le champ app_name ?

```shell
GET tp_elastic_mq/_search
{
  "query": 
  {
    "match": {
      "app_name": "draw art"
    }
  }
}      
```    

#### Comprendre le score - recherche de plusieurs termes 
Comment se décompose le score du premier document trouvé pour la requête OR ?

```shell
GET tp_elastic_mq/_search?explain=true
{
  "query": 
  {
    "match": {
      "app_name": "draw art"
    }
  }
}      
```   

Décomposition du score du premier document remonté qui a le score le plus élevé
* 0.9806374 = 
    * score de draw
    * 0.11750762 => (0,13353139 * 0,88)
    * (+)
    * score de art
    * 0.86312973 => (0,98082924 * 0,88)


Résultat de la requête avec un explain (seul le premier document retourné est représenté)
```json      
{
  "took" : 497,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 3,
    "max_score" : 0.12503365,
    "hits" : [
      {
        "_shard" : "[tp_elastic_mq][0]",
        "_node" : "YgaDyGWxQ86eKKynrH5QdQ",
        "_index" : "tp_elastic_mq",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 0.12503365,
        "_source" : {
          "app_name" : "draw figure"
        },
        "_explanation" : {
          "value" : 0.12503365,
          "description" : "weight(app_name:draw in 2) [PerFieldSimilarity], result of:",
          "details" : [
            {
              "value" : 0.12503365,
              "description" : "score(doc=2,freq=1.0 = termFreq=1.0\n), product of:",
              "details" : [
                {
                  "value" : 0.105360515,
                  "description" : "idf, computed as log(1 + (docCount - docFreq + 0.5) / (docFreq + 0.5)) from:",
                  "details" : [
                    {
                      "value" : 4.0,
                      "description" : "docFreq",
                      "details" : [ ]
                    },
                    {
                      "value" : 4.0,
                      "description" : "docCount",
                      "details" : [ ]
                    }
                  ]
                },
                {
                  "value" : 1.186722,
                  "description" : "tfNorm, computed as (freq * (k1 + 1)) / (freq + k1 * (1 - b + b * fieldLength / avgFieldLength)) from:",
                  "details" : [
                    {
                      "value" : 1.0,
                      "description" : "termFreq=1.0",
                      "details" : [ ]
                    },
                    {
                      "value" : 1.2,
                      "description" : "parameter k1",
                      "details" : [ ]
                    },
                    {
                      "value" : 0.75,
                      "description" : "parameter b",
                      "details" : [ ]
                    },
                    {
                      "value" : 3.25,
                      "description" : "avgFieldLength",
                      "details" : [ ]
                    },
                    {
                      "value" : 2.0,
                      "description" : "fieldLength",
                      "details" : [ ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      }
    ]
  }
}

```

#### AND
Quels sont les documents qui contiennent les termes draw et art dans le champ app_name ?

```shell
GET tp_elastic_mq/_search
{
  "query": 
  {
    "match": 
    {
      "app_name" :
      {
        "query": "draw art",
        "operator": "and"
      }
    }
  }
}      
```    
