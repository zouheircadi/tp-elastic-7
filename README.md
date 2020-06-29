
# Cluster - recovery

## Simple recovery

##### Démarrer cluster

##### Requête REST pour la création du repository
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

##### La création échoue (voir trace partielle ci-dessous)
```
 Erreur = "reason" : "[cluster-7.x-backup] location [<CHEMIN_DE_VOTRE_CHOIX>] doesn't match any of the locations specified by path.repo because this setting is empty"
```

Il faut mettre le path dans la configuration statique (elasticearch.yml) des nodes Elasticsearch et les redémarrer


##### Vérification création
```
GET /_snapshot/cluster-7.x-backup
```

##### Créer l'index
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


##### Première indexation des données
```shell script
./bin/logstash   -f <$PATH_TO>/ls-google-playstore.conf
```

##### Vérifier le nombre de documents de l'index créé. Il doit y avoir 100 000 documents
```
GET /recovery_index/_count
```

##### Premier snapshot
```
POST /_snapshot/cluster-7.x-backup/snapshot_1
{
  "indices": "recovery_index",
  "ignore_unavailable": true,
  "include_global_state": false
}
```

##### Deuxième indexation des données
```shell script
./bin/logstash   -f <$PATH_TO>/ls-google-playstore.cluster.conf
```

##### Deuxième snapshot 
L'opération est bloquante en rajoutant à la fin de l'URL la chaine suivante : "?wait_for_completion=true"
```
POST /_snapshot/cluster-7.x-backup/snapshot_2?wait_for_completion=true
{
  "indices": "recovery_index",
  "ignore_unavailable": true,
  "include_global_state": false
}
```

##### Contrôler la distribution des shards 
```
GET /_cat/shards/recovery_index?v
```

##### Vérifier le nombre de documents de l'index créé. Il doit y avoir 200 000 documents
```
GET /recovery_index/_count
```

##### Supprimer l'index
```
DELETE /recovery_index
```

##### Restaurer l'index avec le premier snapshot
```
POST /_snapshot/cluster-7.x-backup/snapshot_1/_restore
```

##### Requête de contôle après la première restauration => 100.000 documents
```
GET /recovery_index/_count
``` 


##### Supprimer l'index
```
DELETE /recovery_index
```

##### Restaurer l'index avec le deuxième snapshot
```
POST /_snapshot/cluster-7.x-backup/snapshot_2/_restore
```

##### Requête de contôle après la première restauration => 200.000 documents 
```
GET /recovery_index/_count
```

##### Contrôler la distribution des shards
```
GET /_cat/shards/recovery_index?v
```


<!---
## Recovery after corruption
## Red state after nodes loss
-->
