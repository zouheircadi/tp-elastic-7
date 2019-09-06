##Contrôle de la pertinence
### Contrôle du score par un ranking utilisateur (like, rating, …)



# Function score sur le rating avec un field value factor

1- 
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