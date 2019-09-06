##Contrôle de la pertinence
### Contrôle du score par un ranking utilisateur (like, rating, …)



1- 
Requête multi_match best_fields sur le token diabete
```shell
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "multi_match": {
      "query": "diabete",
      "fields": ["app_name","app_name.english"]
    }        
  }
}
```

2- 
L'identifiant est variable. Notez le score et le rating du premier élément. Ils devraient être de 
* rating 0.0
* score 8.466572


3- 
Pour ce cas d'utilisation, une function score avec un field value factor sur le rating est une solution
Ci-dessous, requête multi_match best_fields sur le token diabete encapsulée par une function_score de type fieldValueFactore
```shell
GET /tp_elastic_gstore/_search
{
  "query": 
  {
    "function_score": {
      "query": 
      {
        "multi_match": {
          "query": "diabete",
          "fields": ["app_name","app_name.english"]
        }        
      },
      "functions": [
        {
          "field_value_factor": {
            "field": "rating"
          }
        }
      ],
      "boost_mode": "multiply"
    }
  }
}
```


4- 
L'élément qui remontait en premier remonte maintenant en 10eme position