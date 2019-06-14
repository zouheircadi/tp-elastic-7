## Les données géographiques
### Jeu d'essai


###### 1- Commande REST de type POST à exécuter pour charger le jeu d'essai 

```shell
POST  tp_elastic_formations/_doc/_bulk
{ "index": { "_id":1}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-09-16", "end_date" : "2019-09-17", "city" : "Zurich", "country" : "Switzerland","location" : {"lat":"47.3769","lon":"8.5417"}}
{ "index": { "_id":2}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-09-18", "end_date" : "2019-09-19", "city" : "Zurich", "country" : "Switzerland","location" : {"lat":"47.3769","lon":"8.5417"}}
{ "index": { "_id":3}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-06-17", "end_date" : "2019-06-18", "city" : "Brussels", "country" : "Belgium","location" : {"lat":"50.85045","lon":"4.34878"}}
{ "index": { "_id":4}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-06-19", "end_date" : "2019-06-20", "city" : "Brussels", "country" : "Belgium","location" : {"lat":"50.85045","lon":"4.34878"}}
{ "index": { "_id":5}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-07-22", "end_date" : "2019-07-23", "city" : "London", "country" : "UK","location" : {"lat":"51.50853","lon":"-0.12574"}}
{ "index": { "_id":6}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-07-24", "end_date" : "2019-07-25", "city" : "London", "country" : "UK","location" : {"lat":"51.50853","lon":"-0.12574"}}
{ "index": { "_id":7}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-09-23", "end_date" : "2019-09-24", "city" : "Paris", "country" : "France","location" : {"lat":"48.85341","lon":"2.3488"}}
{ "index": { "_id":8}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-09-25", "end_date" : "2019-09-26", "city" : "Paris", "country" : "France","location" : {"lat":"48.85341","lon":"2.3488"}}
{ "index": { "_id":9}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-08-19", "end_date" : "2019-08-20", "city" : "Istamboul", "country" : "Turkey","location" : {"lat":"41.01384","lon":"28.94966"}}
{ "index": { "_id":10}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-08-21", "end_date" : "2019-08-22", "city" : "Istamboul", "country" : "Turkey","location" : {"lat":"41.01384","lon":"28.94966"}}
{ "index": { "_id":11}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-07-15", "end_date" : "2019-07-16", "city" : "Amsterdam", "country" : "Netherlands","location" : {"lat":"52.37403","lon":"4.88969"}}
{ "index": { "_id":12}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-07-17", "end_date" : "2019-07-18", "city" : "Amsterdam", "country" : "Netherlands","location" : {"lat":"52.37403","lon":"4.88969"}}
{ "index": { "_id":13}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-09-02", "end_date" : "2019-09-03", "city" : "Frankfurt", "country" : "Germany","location" : {"lat":"50.11552","lon":"8.68417"}}
{ "index": { "_id":14}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-09-04", "end_date" : "2019-09-05", "city" : "Frankfurt", "country" : "Germany","location" : {"lat":"50.11552","lon":"8.68417"}}
{ "index": { "_id":15}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-09-30", "end_date" : "2019-10-01", "city" : "Milan", "country" : "Italy","location" : {"lat":"45.46427","lon":"9.18951"}}
{ "index": { "_id":16}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-10-02", "end_date" : "2019-10-03", "city" : "Milan", "country" : "Italy","location" : {"lat":"45.46427","lon":"9.18951"}}
{ "index": { "_id":17}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-07-01", "end_date" : "2019-07-02", "city" : "Hamburg", "country" : "Germany","location" : {"lat":"53.57532","lon":"10.01534"}}
{ "index": { "_id":18}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-07-03", "end_date" : "2019-07-04", "city" : "Hamburg", "country" : "Germany","location" : {"lat":"53.57532","lon":"10.01534"}}
{ "index": { "_id":19}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-07-01", "end_date" : "2019-07-02", "city" : "Dublin", "country" : "Ireland","location" : {"lat":"53.33306","lon":"-6.24889"}}
{ "index": { "_id":20}}
{"course" : "Elasticsearch Engineer II", "start_date" : "2019-07-03", "end_date" : "2019-07-04", "city" : "Dublin", "country" : "Ireland","location" : {"lat":"53.33306","lon":"-6.24889"}}
```

######2-RequeteGeo  
```
GET /tp_elastic_formations/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "match_all": {}
        }
      ],
      "filter": {
        "geo_distance": {
          "distance": "240km",
          "location": {
            "lat": 50.63297,
            "lon": 3.05858
          }
        }
      }
    }
  }
}
```

###### 3-  

Diagnostic du problème  
Faites un GET sur l'index pour constater de visu la structure inférée pour le type location
```
GET DELETE tp_elastic_formations
```
 
Si on isole la partie spécifique au type location, on constate qu'il est créé [comme un objet](https://www.elastic.co/guide/en/elasticsearch/reference/current/object.html)

```
  "location": {
    "properties": {
      "lat": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      },
      "lon": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword",
            "ignore_above": 256
          }
        }
      }
    }
  }
``` 

Le type geo-point ne peut pas être inféré. Il faut le créer explicitement. 

Supprimer l'index
```
DELETE tp_elastic_formations
```

Créer l'index avec le mapping adequat de type geopoint
```
PUT tp_elastic_formations
{
  "mappings": {
    "_doc": {
      "properties": {
        "course" : 
        {
          "type" : "text",
          "fields" : 
          {
            "key" : 
            {
              "type" : "keyword"
            }
          }
        },
        "start_date" : {"type" : "date"},
        "end_date" : {"type" : "date"},
        "country" : {"type" : "keyword"},
        "city" : {"type" : "keyword"},        
        "location": {
          "type": "geo_point"
        }
      }
    }
  }
}
```


######4- 
Exécuter de nouveau la [requête précédente](2-RequeteGeo)