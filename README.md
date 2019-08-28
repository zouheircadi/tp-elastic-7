## Les données géographiques
### Jeu d'essai


###### Commande REST de type POST à exécuter pour charger le jeu d'essai 

```shell
POST  tp_elastic_formations/_bulk
{ "index": { "_id":1}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-09-16", "end_date" : "2019-09-17", "city" : "Zurich", "country" : "Switzerland","location" : {"lat":"47.3769","lon":"8.5417"},"price" : 2000}
{ "index": { "_id":3}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-06-17", "end_date" : "2019-06-18", "city" : "Brussels", "country" : "Belgium","location" : {"lat":"50.85045","lon":"4.34878"},"price" : 2100}
{ "index": { "_id":5}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-07-22", "end_date" : "2019-07-23", "city" : "London", "country" : "UK","location" : {"lat":"51.50853","lon":"-0.12574"},"price" : 2200}
{ "index": { "_id":7}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-09-23", "end_date" : "2019-09-24", "city" : "Paris", "country" : "France","location" : {"lat":"48.85341","lon":"2.3488"},"price" : 2300}
{ "index": { "_id":9}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-08-19", "end_date" : "2019-08-20", "city" : "Istamboul", "country" : "Turkey","location" : {"lat":"41.01384","lon":"28.94966"},"price" : 2400}
{ "index": { "_id":11}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-07-15", "end_date" : "2019-07-16", "city" : "Amsterdam", "country" : "Netherlands","location" : {"lat":"52.37403","lon":"4.88969"},"price" : 2800}
{ "index": { "_id":13}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-09-02", "end_date" : "2019-09-03", "city" : "Frankfurt", "country" : "Germany","location" : {"lat":"50.11552","lon":"8.68417"},"price" : 1900}
{ "index": { "_id":15}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-09-30", "end_date" : "2019-10-01", "city" : "Milan", "country" : "Italy","location" : {"lat":"45.46427","lon":"9.18951"},"price" : 1800}
{ "index": { "_id":17}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-07-01", "end_date" : "2019-07-02", "city" : "Hamburg", "country" : "Germany","location" : {"lat":"53.57532","lon":"10.01534"},"price" : 1700}
{ "index": { "_id":19}}
{"course" : "Elasticsearch Engineer I", "start_date" : "2019-07-01", "end_date" : "2019-07-02", "city" : "Dublin", "country" : "Ireland","location" : {"lat":"53.33306","lon":"-6.24889"},"price" : 5000}
```

