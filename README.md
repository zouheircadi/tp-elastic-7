## 3 Cas d’utilisation Google Play Store
### 3.2 Recherches



###### music dans le champ app_name
```
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
```
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

* La recherche sur diabete ne donne rien. Pourquoi ?  
Utilisation de l'analyzer par défaut qui ne fait pas de stemmisation

###### Refaites la recherche avec le token diabetes
```
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
Il faut utiliser un analyzer personnalisé ou présent sur étagère pour réduire les mots à leur racine. On peut dans un premier temps tester l'effet d'un analyzer english par exemple car le texte indexé est dans la langue anglaise.  
Dans l'analyse indiquée ci-dessous, on constate que les tokens diabetes et diabete sont réduits à la racine **diabet**. L'analyzer english présent sur étagère est donc suffisant pour répondre à ce problème.

###### Comment pouvez vous faire des tests d’une solution probable ?
* Endpoint _analyze avec un un analyzer présent sur étagère
```
GET /tp_elastic_gstore/_analyze
{
  "text": ["diabetes","diabete"],
  "analyzer": "english"
}
```



###### Modifier le mapping pour que la recherche donne un résultat avec le token diabete 

* Suppression des index
```
DELETE hol_devoxxfr_gstore_*
```

* Création du nouvel index
```
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


###### Tester la solution choisie avec le endpoint _analyze avant de la mettre en oeuvre (avant le chargement des données).
```
GET /tp_elastic_gstore/_analyze
{
  "text": ["diabetes","diabete"],
  "field": "app_name.english"
}
```

###### Charger les données

* Création de l'alias
```
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v2", "alias" : "tp_elastic_gstore" } }
    ]
}
```

* Renommer l'index dans le fichier $HOME/elastic/tp-elastic/data/ls-google-playstore.conf  
A partir de maintenant, étant donné que l'index est créé avant l'ajout des données, on peut faire pointer l'entrée **index** directement sur l'alias dans la configuration logstash 
```
output {
    stdout { codec => rubydebug }
    elasticsearch {
        action => "index"
        hosts => ["localhost:9200"]
        index => "tp_elastic_gstore"
        workers => 1
    }
}
```

###### Rechercher de nouveau le token diabete. La recherche devrait être fructueuse si vous avez choisi le mapping adequat
```
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
* Le champ ou il y a le moins de modifications des saisies utilisateur est le champ app_name de type text. La seule modification que fait l'analyseur associé à ce champ est une réduction de la casse.
```
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
```
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
```
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


##### Rechercher les documents qui contiennent 
* diabète  dans le champ app_name 
*  pour les applications gratuites 
*  qui ont un rating supérieur à 4.5
*  qui ont été mises à jour (last_updated) en 2019 
```
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
```
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

###### On cherche messaging+ mais c’est messaging qui remonte en premier
Modifier le mapping pour rendre possible les deux requêtes suivantes 
* Une recherche du token messaging+ ne trouve que les documents contenant cette chaîne
* Lors d’une recherche du token messaging+, les documents le contenant remontent en premier

    * Modification du mapping

```
DELETE tp_elastic_gstore_*
```

```shell
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
*  * Création de l'index
    
    
```
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v3", "alias" : "tp_elastic_gstore" } }
    ]
}
```

*   * Tester le nouveau mapping avant le chargement des données
```
GET /tp_elastic_gstore/_analyze
{
  "text": ["messaging+","messaging"],
  "field": "app_name.whitespace"
}
```

*
    * Une recherche du token messaging+ ne trouve que les documents contenant cette chaîne
```
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


* * Lors d’une recherche du token messaging+, les documents le contenant remontent en premier

```
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

###### Rechercher les documents qui contiennent le token food dans le champ "category" 
```
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

* Sans modification du mapping
```
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
 
* Avec modification du mapping

    * Suppression des index
```
DELETE tp_elastic_gstore_*
```

*    * Création du mapping
```
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

*    * Création de l'alias
```
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v4", "alias" : "tp_elastic_gstore" } }
    ]
}
```

*    * Query
```
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

```
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

* Suppression des anciens index

```
DELETE tp_elastic_gstore_*
```

* Création de l'index avec le searchAsYouType
```
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
}
```

* Création de l'alias qui pointe sur l'index nouvellement créé
```
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v5", "alias" : "tp_elastic_gstore" } }
    ]
}
```

* Test du nouvel index avec le endPoint _analyze 
```
GET /tp_elastic_gstore/_analyze
{
  "text" : ["dating","diabete"],
  "field": "app_name.autocomplete"
}
```

* Query
```
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