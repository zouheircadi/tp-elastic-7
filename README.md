# Cas d’utilisation Google Play Store
## Recherches


###### music dans le champ app_name
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

###### diabete dans le champ app_name
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


###### La recherche sur diabete ne donne rien. Pourquoi ?
Utilisation de l'analyzer par défaut qui ne fait pas de stemmisation

###### Refaites la recherche avec le token diabetes
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

###### Comment modifier le mapping pour que la recherche donne un résultat avec le token diabete ?
###### 
* Il faut utiliser un analyzer personnalisé ou présent sur étagère pour réduire les mots à leur racine. On peut dans un premier temps tester l'effet d'un analyzer english par exemple car le texte indexé est dans la langue anglaise
*  Dans l'analyse indiquée ci-dessous, on constate que les tokens diabetes et diabete sont réduits à la racine diabete. L'analyzer english présent sur étagère est donc suffisant pour répondre à ce problème

###### Comment pouvez vous faire des tests d’une solution probable ?
* Endpoint _analyze avec un un analyzer présent sur étagère
```json
GET /tp_elastic_gstore/_analyze
{
  "text": ["diabetes","diabete"],
  "analyzer": "english"
}
```


###### Modifier le mapping pour que la recherche donne un résultat avec le token diabete ? 
```shell
DELETE tp_elastic_gstore_*
```

Créer l'index
```json
PUT tp_elastic_gstore_v2
{
  "mappings": 
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
```

Créer l'alias sur le nouvel index
# Créer l'alias
```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v2", "alias" : "tp_elastic_gstore" } }
    ]
}
```


###### Tester la solution choisie avec le endpoint _analyze avant de la mettre en oeuvre (avant le chargement des données).
```json
GET /tp_elastic_gstore/_analyze
{
  "text": ["diabetes","diabete"],
  "field": "app_name.english"
}
```


###### Charger les données



###### Rechercher de nouveau le token diabete. La recherche devrait être fructueuse si vous avez choisi le mapping adequat
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


###### Ré-écrivez la requête en recherchant simultanément sur les champs que vous estimez pertinents tout en boostant les recherches des saisies exactes des utilisateurs.
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



###### Rechercher les documents qui contiennent draw ou art dans le champ app_name
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

###### Rechercher les documents qui contiennent draw et art dans le champ app_name
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


###### Rechercher les documents qui contiennent 
* diabète  dans le champ description 
* pour les applications gratuites 
* qui ont un rating supérieur à 4.5
* qui ont été mises à jour (last_updated) en 2019 
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

###### Rechercher les documents qui contiennent messaging+ dans le champ app_name
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


* On cherche messaging+ mais c’est messaging qui remonte en premier

###### Modification du mapping

```shell
DELETE tp_elastic_gstore_*
```


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
```

Créer alias
```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v3", "alias" : "tp_elastic_gstore" } }
    ]
}
```


###### Tester le nouveau mapping avant le chargement des données
```json
GET /tp_elastic_gstore/_analyze
{
  "text": ["messaging+","messaging"],
  "field": "app_name.whitespace"
}
```

###### Charger les données

*  Une recherche du token messaging+ ne trouve que les documents contenant cette chaîne
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
}
```

* Lors d’une recherche du token messaging+, les documents le contenant remontent en premier
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "messaging+",
      "fields": ["app_name","app_name.english","app_name.whitespace"]
    }
  }
}
```


###### Rechercher les documents qui contiennent le token food dans le champ "category" 
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


###### La recherche devrait être infructueuse. Comment elargir le spectre de la recherche sans modification du mapping.
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

###### Modification du mapping
```shell
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
```

Créer alias
```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v4", "alias" : "tp_elastic_gstore" } }
    ]
}
```

Charger les données

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

* Supprimer les index existants
```shell
DELETE tp_elastic_gstore_*
```

* Créer l'index de travail tp_elastic_gstore_v5
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
                "analyzer": "ac_analyzer",
                "search_analyzer" : "standard"
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
                "analyzer": "ac_analyzer",
                "search_analyzer" : "standard"
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
                "analyzer": "ac_analyzer",
                "search_analyzer" : "standard"
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
```


* Créer alias
    * L'alias tp_elastic_gstore va pointer sur l'index tp_elastic_gstore_v5 
```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v5", "alias" : "tp_elastic_gstore" } }
    ]
}
```

* Tester l'index avant chargement des données
```json
GET /tp_elastic_gstore/_analyze
{
  "text" : ["dating","diabete"],
  "field": "app_name.autocomplete"
}
```


* Charger les données
    * Linux
```shell
$LOGSTATSH_INSTALL_DIR/bin/logstash -f <$PATH_TO>/ls-google-playstore.conf
```
*   
    * Windows
```shell
%LOGSTATSH_INSTALL_DIR%\bin\ logstash -f C:\elastic\tp-elastic\data\ls-google-playstore.conf 
```

* Exécuter une requête de test
```json
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "match": {
      "app_name.autocomplete": "D"
    }
  }
}
```