# Operations

## Index Lifecycle Management (ILM)


######  Créer un index avec les caractéristiques suivants

```json
PUT /awareness_index
{
  "settings": 
  {
    "number_of_shards": 4,
    "number_of_replicas": 1
  }
}
```

######   En utilisant l'API _cat, contrôlez la répartition des shards par noeuds

* Query
```
GET /_cat/shards/awareness_index?v
```


######  Stoppez le cluster

. Modifiez la configuration statique de chaque noeud (elasticsearch.yml) de manière à avoir trois types de noeuds
* Nous appellerons la property _box_type_. La clé de la property sera donc node.attr.box_type
* La valeur de la property sera hot pour les nodes 1 et 2 : node.attr.box_type: hot
* La valeur de la property sera dc1 pour les nodes 3      : node.attr.box_type: warm
* La valeur de la property sera dc1 pour les nodes 4      : node.attr.box_type: cold

. Redémarrez le cluster

. Créez la policy

. Créez le template associé à la policy

. Modifiez le settings dynamique indices.lifecycle.poll_interval qui détermine la période à laquelle l'ILM teste si un index respecte la politique à appliquer ; positionnez le à 500 ms

. Indexer les données grâce aux fichiers fournis
.. Chargement avec logstash
