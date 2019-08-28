## Contrôle de la pertinence
### Autocréation d’index

Le jeu d'essai est le même que pour l'exercice sur la géolocalisation


1- Decay function sur la géolocalisation 
... Mettez en place une requête analogue et tester là en simulant une localisation à Lille.

```json
GET tp_elastic_formations/_search
{
  "query": 
  {
    "function_score": {
      "query": 
      {
        "match": {
          "course": "elasticsearch"
        }
      },
      "functions": [
        {
          "gauss": {
            "location": {
              "origin": "50.633307,3.020001",
              "scale": "50km",
              "offset": "200km",
              "decay": 0.5
            }
          },
          "weight": 1
        }
      ]
    }
  }
}
```

2- Decay function sur la géolocalisation
... Quelle est la requête qui permet d’obéir à ces contraintes ? 
```json
GET tp_elastic_fct_decay/_search
{
  "size": 20, 
  "query": 
  {
    "function_score": {
      "query": 
      {
        "match": {
          "course": "Elasticsearch Engineer I"
        }
      },
      "functions": [
        {
          "linear": {
            "price": {
              "origin": "0",
              "offset": "2000",
              "scale": "200",
              "decay": 0.8
            }
          }
        }
      ]
    }
  }
}
```


###### Avec sort
On trie sur le score ensuite sur le prix. Le tri fonctionne bien car tant que les prix sont inférieurs à l'offset, le score est fixe.

```shell
GET tp_elastic_fct_decay/_search
{
  "size": 20, 
  "sort": [
    {
      "_score": {
        "order": "desc"
      },
      "price": 
      {
        "order": "asc"
      }
    }
  ], 
  "query": 
  {
    "function_score": {
      "query": 
      {
        "match": {
          "course": "elasticsearch"
        }
      },
      "functions": [
        {
          "linear": {
            "price": {
              "origin": "0",
              "offset": "2000",
              "scale": "200",
              "decay": 0.8
            }
          }
        }
      ]
    }
  }
}
```

