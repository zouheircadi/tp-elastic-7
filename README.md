# Recherches
## Partial matching
### Partial matching avec modification de l’indexation : edge-ngrams
###### En vous aidant de la documentation en ligne, créer un index de type index-time-search-as-you-type que vous appellerez tp_elastic_pm3

```shell
DELETE tp_elastic_pm3
```

```json
PUT /tp_elastic_pm3
{
  "settings": 
  {
    "analysis": 
    {
      "filter": 
      {
        "ac_filter": 
        {
          "type": "edge_ngram",
          "min_gram": 1,
          "max_gram": 20
        }
      },
      "analyzer": 
      {
        "ac_analyzer": 
        {
          "type": "custom",
          "tokenizer": "standard",
          "filter": 
          [
            "lowercase",
            "ac_filter"
          ]
        }
      }
    }    
  }, 
  "mappings": 
  {
      "properties" : 
      {
        "code" : 
        {
          "type" : "keyword"
        },
        "country" :
        {
          "type" : "text",
          "fields": 
          {
            "keyword": 
            {
              "type": "keyword"
            },
            "autocomplete": 
            {
              "type": "text",
              "analyzer" : "ac_analyzer",
              "search_analyzer" : "standard"
            }            
          }
        }
      }
  }
}
```


###### Charger les données dans l’index nouvellement créé.
```shell
./data/post-data-3-curl.sh
```

###### Tester le nouvel index en cherchant le token “rep”

```shell
GET tp_elastic_pm3/_search
{
  "query": 
  {
    "match": {
      "country.autocomplete": "rep"
    }
  }
}
```


###### Faites une analyze de la chaine “REPUBLic” sur le champ country.autocomplete
```shell
GET /tp_elastic_pm3/_analyze
{
  "text": ["REPUBLic"],
  "field": "country.autocomplete"
}
```

La sortie devrait être comme indiqué ci-dessous. Le token REPUBLic passe l'analyseur de type edge_ngram.
```shell
{
  "tokens" : [
    {
      "token" : "r",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "re",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "rep",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "repu",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "repub",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "republ",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "republi",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "republic",
      "start_offset" : 0,
      "end_offset" : 8,
      "type" : "<ALPHANUM>",
      "position" : 0
    }
  ]
}
```
