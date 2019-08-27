## Recherches full-text
### Recherches multichamps - un texte spécifique à chaque champ


###### inject data
```shell
POST /tp_elastic_mf1/_bulk
{ "index": { "_id": 1 }}
{"app_name" : "draw pixel art number", "genres" : "Art & Design;Creativity"}
{ "index": { "_id": 2 }}
{"app_name" : "draw pixel number", "genres" : "Art & Design"}
{ "index": { "_id": 3 }}
{"app_name" : "draw figure", "genres" : "Art & Design"}
```

* Trouver les documents qui contiennent
    * draw dans le champ app_name
    * art dans le champ genres

```shell      
GET  tp_elastic_mf1/_search
{
  "query": 
  {
    "bool": 
    {
      "should": 
      [
        {"match": {"app_name": "draw"}},
        {"match": {"genres": "art"}}
      ]  
    }
  }
}
```
