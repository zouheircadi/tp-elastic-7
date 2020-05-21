
# Cluster - recovery

## Simple recovery

##### Start cluster

##### Create repository
```json
PUT /_snapshot/cluster-7.x-backup
{
  "type": "fs",
  "settings": {
    "location": "<CHEMIN_DE_VOTRE_CHOIX>",
    "compressed" : true
  }
}
```

 Erreur = "reason" : "[cluster-7.x-backup] location [<CHEMIN_DE_VOTRE_CHOIX>] doesn't match any of the locations specified by path.repo because this setting is empty"

Il faut mettre le path dans la configuration statique (elasticearch.yml) des nodes Elasticsearch et redémarrer vos serveurs


##### Vérification création
```
GET /_snapshot/cluster-7.x-backup
```

##### Create index
```
PUT /recovery_index
{
  "settings": 
  {
    "number_of_shards": 4,
    "number_of_replicas": 1
  }
}
```


##### Load data
```shell script
./bin/logstash   -f <$PATH_TO>/ls-google-playstore.cluster.conf
```

##### Count documents
```
GET /recovery_index/_count
```

##### Create first snapshot
```
POST /_snapshot/cluster-7.x-backup/snapshot_1
{
  "indices": "recovery_index",
  "ignore_unavailable": true,
  "include_global_state": false
}
```

##### Second batch : Index 100.000 another documents => 200.000 documents in the index
```shell script
./bin/logstash   -f <$PATH_TO>/ls-google-playstore.cluster.conf
```

##### Create second snapshot
```
POST /_snapshot/cluster-7.x-backup/snapshot_2?wait_for_completion=true
{
  "indices": "recovery_index",
  "ignore_unavailable": true,
  "include_global_state": false
}
```

##### Control shard distribution 
```
GET /_cat/shards/recovery_index?v
```

##### Count documents
```
GET /recovery_index/_count
```

##### Delete index
```
DELETE /recovery_index
```

##### Restore index with the first snapshot
```
POST /_snapshot/cluster-7.x-backup/snapshot_1/_restore
```

##### Control queries 1 => 100.000 documents
```
GET /recovery_index/_count
``` 


##### Delete index
```
DELETE /recovery_index
```

##### Restore index with the second snapshot
```
POST /_snapshot/cluster-7.x-backup/snapshot_2/_restore
```

##### Control queries 1 => 200.000 documents
```
GET /recovery_index/_count
```

##### Control shard distribution
```
GET /_cat/shards/recovery_index?v
```


## Recovery after corruption

## Red state after nodes loss

