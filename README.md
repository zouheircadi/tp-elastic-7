## Gestion des index
### Suppression index


###### Suivi de production - chargement d'un index problématique

* Supprimer les replicas ce qui permet de n'ecrire que sur les shards primaires. Plus il y a de réplicas, plus les ecritures seront lentes  
* et passer le refresh_interval à -1 ce qui désactive le refresh
```shell
PUT /tp_elastic_17/_settings
{
  "index": 
    {
      "refresh_interval": "-1",
      "number_of_replicas" : 0
    
  }
}
```    

* A l'issue du chargement, revenir aux conditions de production 
```shell
PUT /tp_elastic_17/_settings
{
  "index": 
    {
      "refresh_interval": "30s",
      "number_of_replicas" : 2
    
  }
}
```