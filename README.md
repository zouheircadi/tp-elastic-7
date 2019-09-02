## Gestion des index
### Création template


```shell
PUT /_template/template_tp_elastic
{
  "index_patterns": ["tp_*"],
  "settings": 
  {
    "number_of_shards" : 1,
    "number_of_replicas" : 0   
  }
}
```

Le template comprendra 2 parties
* Index patterns : tableau avec l’expression régulière suivante : tp_* 
* Settings
    * Nombre de shards : 1
    * Nombre de replicas : 0

Tous les index dont le nom commencera par tp_ auront 1 shard et zéro réplicas

[Allez plus loin](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html)
