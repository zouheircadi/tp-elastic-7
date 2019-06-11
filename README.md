## Tri -  source exclusion
### Corpus Google playstore




###### 1
###### Ecrivez une requête de type match_all
* qui retourne les 25 premiers documents
* avec un tri CROISSANT sur le category.keyword
```
GET /tp_elastic_gstore/_search
{
  "size": 25,
  "sort": [
    {
      "category.keyword": {
        "order": "asc"
      }
    }
  ], 
  "query": 
  {
    "match_all": {}
  }
}
```


###### 1
######  Ecrivez une requête 
* qui retourne les 5 premiers documents
* contenant network dans le champ app_name
* en ne conservant que les champs app_name, genres, rating, last_updated dans la réponse
* avec un tri ordre DECROISSANT sur le rating
```
GET /tp_elastic_gstore/_search
{
  "size": 5, 
  "_source": ["app_name","genres","rating","last_updated" ],
  "sort": [
    {
      "rating": {
        "order": "desc"
      }
    }
  ], 
  "query": 
  {
    "match": {
      "app_name": "network"
    }  
  }
}
```


###### 1
######  Ecrivez une requête 
* qui retourne les 10 premiers documents
* contenant photo dans le champ app_name ou app_name.english
* Avec un boost de 4 sur le champ app_name
* en vous limitant à la présence des champs app_name, category, type, rating et last_updated
*  avec un tri ordre DECROISSANT sur le rating
```
GET /tp_elastic_gstore/_search
{
  "size": 10, 
  "_source": ["app_name","category","type","rating","last_updated" ], 
  "sort": [
    {
      "last_updated": {
        "order": "asc"
      }
    }
  ], 
  "query": 
  {
    "multi_match": 
    {
      "query": "photo",
      "fields": ["app_name^4","app_name.english"]
    }
  }
}
```