## Gestion des index
### Création template


```shell
PUT /_template/template_tp_elastic
{
  "index_patterns": ["tp_elastic*"],
  "settings": 
  {
    "number_of_shards" : 1,
    "number_of_replicas" : 0   
  }
}
```

Le template comprendra 2 parties
* Index patterns : tableau avec l’expression régulière suivante : tp_elastic* 
* Settings
    * Nombre de shards : 1
    * Nombre de replicas : 0

Tous les index dont le nom commencera par tp_elastic auront 1 shard et zéro réplicas

[Allez plus loin](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html)
