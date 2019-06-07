######3 Cas d’utilisation Google Play Store
#######3.2 Recherches



```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "match": {
      "content_rating": "Everyone"
    }
  }
}
```

###########music dans le champ app_name
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "match": {
      "app_name": "music"
    }
  }
}
```

######diabete dans le champ app_name
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "match": {
      "app_name": "diabete"
    }
  }
}
```

######La recherche sur diabete ne donne rien. Pourquoi ?
######Utilisation de l'analyzer par défaut qui ne fait pas de stemmisation

######Refaites la recherche avec le token diabetes
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "match": {
      "app_name": "diabetes"
    }
  }
}
```

######Comment modifier le mapping pour que la recherche donne un résultat avec le token diabete ?
######Il faut utiliser un analyzer personnalisé ou présent sur étagère pour réduire les mots à leur racine. On peut dans un premier temps tester l'effet d'un analyzer english par exemple car le texte indexé est dans la langue anglaise
######Dans l'analyse indiquée ci-dessous, on constate que les tokens diabetes et diabete sont réduits à la racine diabete. L'analyzer english présent sur étagère est donc suffisant pour répondre à ce problème

######tester l'analyzer cible
```json
GET /tp_elastic_gstore/_analyze
{
  "text": ["diabetes","diabete"],
  "analyzer": "english"
}
```



######Création d'un analyzer spécifique à la langue
DELETE hol_devoxxfr_gstore_v1

DELETE hol_devoxxfr_gstore_v2

```json
PUT tp_elastic_gstore_v2
{
  "mappings": 
  {
      "doc" : 
      {
        "properties" : 
        {
          "app_name" : 
          {
            "type" : "text",
            "fields" :
            {
              "english" :
              {
                "type" : "text",
                "analyzer" : "english"
              }
            }
          },
          "genres" : 
          {
            "type" : "text",
            "fields" :
            {
              "english" :
              {
                "type" : "text",
                "analyzer" : "english"
              }              
            }
          }     
        }
      }
  }
}
```


######tester l'analyzer dans l'index créé
```json
GET /tp_elastic_gstore/_analyze
{
  "text": ["diabetes","diabete"],
  "field": "app_name.english"
}

```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v2", "alias" : "tp_elastic_gstore" } }
    ]
}
```


#Rechercher de nouveau le token diabete. La recherche devrait être fructueuse si vous avez choisi le mapping adequat
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "match": {
      "app_name.english": "diabete"
    }
  }
}
```


######Ré-écrivez la requête en recherchant simultanément sur les champs que vous estimez pertinents tout en boostant les recherches des saisies exactes des utilisateurs.
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "diabetes",
      "fields": ["app_name^4","app_name.english","genres.english"]
    }
  }
}
```


######Rechercher les documents qui contiennent photos ou art dans le champ app_name
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "draw art",
      "fields": ["app_name"]
    }
  }
}
```

#Rechercher les documents qui contiennent draw ou art dans le champ app_name
```json
GET /tp_elastic_gstore/_search
{
  "query": {
      "match": {
        "app_name": "draw art"
      }
  }
}
```

######Rechercher les documents qui contiennent draw et art dans le champ app_name
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
      "match": 
      {
        "app_name": 
        {
          "query": "draw art",
          "operator": "and"
        }
      }
  }
}
```


#Rechercher les documents qui contiennent 
#######diabète  dans le champ description 
#######pour les applications gratuites 
#######qui ont un rating supérieur à 4.5
#######qui ont été mises à jour (last_updated) en 2019 
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "bool": 
    {
      "must": 
      [
        {"multi_match": {
          "query": "diabete",
          "fields": ["app_name^4","app_name.english"]
        }}
      ],
      "filter": 
      [
        {
          "term": {
            "type.keyword": "Free"
          }          
        },
        {
          "range" : {
            "rating" : {
              "gte" : 4.5
            }
          }
        },
        {
          "range" : {
            "last_updated" : {
              "gte" : "2018-01-01"
            }
          }
        }
      ]
    }
  }
}
```

######Rechercher les documents qui contiennent messaging+ dans le champ app_name
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "messaging+",
      "fields": ["app_name"]
    }
  }
}
```

#On cherche messaging+ mais c’est messaging qui remonte en premier

##Modification du mapping

DELETE tp_elastic_gstore_*

```json
PUT tp_elastic_gstore_v3
{
  "settings": 
  {
    "analysis": 
    {
      "analyzer": 
      {
        "ws_analyzer": 
        {
          "type": "custom",
          "tokenizer": "whitespace",
          "filter": 
          [
            "lowercase"
          ]
        }        
      }
    }
  }, 
  "mappings": 
  {
      "doc" : 
      {
        "properties" : 
        {
          "app_name" : 
          {
            "type" : "text",
            "fields" :
            {
              "english" :
              {
                "type" : "text",
                "analyzer" : "english"
              },
              "whitespace" :
              {
                "type" : "text",
                "analyzer" : "ws_analyzer"
              }              
            }
          },
          "genres" : 
          {
            "type" : "text",
            "fields" :
            {
              "english" :
              {
                "type" : "text",
                "analyzer" : "english"
              }              
            }
          }     
        }
      }
  }
}
```

```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v3", "alias" : "tp_elastic_gstore" } }
    ]
}
```


######Tester le nouveau mapping avant le chargement des données
```json
GET /tp_elastic_gstore/_analyze
{
  "text": ["messaging+","messaging"],
  "field": "app_name.whitespace"
}
```

#######Une recherche du token messaging+ ne trouve que les documents contenant cette chaîne
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "messaging+",
      "fields": ["app_name.whitespace"]
    }
  }
}```


#######Lors d’une recherche du token messaging+, les documents le contenant remontent en premier

```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "messaging+",
      "fields": ["app_name","app_name.english","app_name.whitespace"],
      "type": "most_fields"
    }
  }
}
```

######Rechercher les documents qui contiennent le token food dans le champ "category" 
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "food",
      "fields": ["category"],
      "type": "best_fields"
    }
  }
}
```

######La recherche devrait être infructueuse. Comment elargir le spectre de la recherche sans modification du mapping.
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "food",
      "fields": ["category","app_name","genres"]
    }
  }
}
```

######Modification du mapping
```
DELETE tp_elastic_gstore_*
```

```json
PUT tp_elastic_gstore_v4
{
  "settings": 
  {
    "analysis": 
    {
      "analyzer": 
      {
        "ws_analyzer": 
        {
          "type": "custom",
          "tokenizer": "whitespace",
          "filter": 
          [
            "lowercase"
          ]
        }        
      }
    }
  }, 
  "mappings": 
  {
      "doc" : 
      {
        "properties" : 
        {
          "app_name" : 
          {
            "type" : "text",
            "copy_to" : "catch_all",
            "fields" :
            {
              "english" :
              {
                "type" : "text",
                "analyzer" : "english"
              },
              "whitespace" :
              {
                "type" : "text",
                "analyzer" : "ws_analyzer"
              }              
            }
          },
          "genres" : 
          {
            "type" : "text",
            "copy_to" : "catch_all",            
            "fields" :
            {
              "english" :
              {
                "type" : "text",
                "analyzer" : "english"
              }              
            }
          },
          "category" : 
          {
            "type" : "text",
            "copy_to" : "catch_all",            
            "fields" :
            {
              "keyword" :
              {
                "type" : "keyword"
              }              
            }
          },          
          "catch_all" : 
          {
            "type" : "text"
          }          
        }
      }
  }
}
```

```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v4", "alias" : "tp_elastic_gstore" } }
    ]
}
```

```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "match": {
      "catch_all": "food"
    }
  }
}  
```

###### dyabete

```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "dyabetes",
      "fields": ["category","app_name","app_name.english","genres","genres.english"],
      "fuzziness": "AUTO"
    }
  }
}
```

###### searchAsYouType 

Suppression des anciens index
DELETE tp_elastic_gstore_*

Création de l'index avec le searchAsYouType
```json
PUT tp_elastic_gstore_v5
{
  "settings": 
  {
    "analysis": 
    {
      "filter" : 
      {
        "ac_filter" :
        {
          "type": "edge_ngram",
          "min_gram": 1,
          "max_gram": 10
        }
      },      
      "analyzer": 
      {
        "ws_analyzer": 
        {
          "type": "custom",
          "tokenizer": "whitespace",
          "filter": 
          [
            "lowercase"
          ]
        },
        "ac_analyzer" : 
        {
          "tokenizer" : "standard",
          "filter" : 
          ["lowercase", "ac_filter"]
        }
      }
    }
  }, 
  "mappings": 
  {
      "doc" : 
      {
        "properties" : 
        {
          "app_name" : 
          {
            "type" : "text",
            "copy_to" : "catch_all",
            "fields" :
            {
              "english" :
              {
                "type" : "text",
                "analyzer" : "english"
              },
              "whitespace" :
              {
                "type" : "text",
                "analyzer" : "ws_analyzer"
              },
              "autocomplete" :
              {
                "type" : "text",
                "analyzer": "ac_analyzer"
              }
            }
          },
          "genres" : 
          {
            "type" : "text",
            "copy_to" : "catch_all",            
            "fields" :
            {
              "english" :
              {
                "type" : "text",
                "analyzer" : "english"
              },
              "autocomplete" :
              {
                "type" : "text",
                "analyzer": "ac_analyzer"
              }              
            }
          },
          "category" : 
          {
            "type" : "text",
            "copy_to" : "catch_all",            
            "fields" :
            {
              "keyword" :
              {
                "type" : "keyword"
              },
              "autocomplete" :
              {
                "type" : "text",
                "analyzer": "ac_analyzer"
              }              
            }
          },          
          "catch_all" : 
          {
            "type" : "text"
          }          
        }
      }
  }
}
```

Création de l'alias qui pointe sur l'index nouvellement créé
```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v5", "alias" : "tp_elastic_gstore" } }
    ]
}
```

Test avec le endPoint 
```json
GET /tp_elastic_gstore/_analyze
{
  "text" : ["dating","diabete"],
  "field": "app_name.autocomplete"
}
```

Query
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "D",
      "fields": ["category.autocomplete","app_name.autocomplete","genres.autocomplete"]
    }
  }
}
```