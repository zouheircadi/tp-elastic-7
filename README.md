# Operations

## Index Lifecycle Management (ILM)

## Allocation awareness

### Sans allocation awareness

###### Démarrez un cluster cluster contenant 4 noeuds

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

* Réponse (sachant que la répartition est aléatoire, la réponse donnée l'est à titre d'exemple et non de résultat absolu)

```
index           shard prirep state   docs store ip           node
awareness_index 0     r      STARTED    0  230b 192.168.1.10 node-1
awareness_index 1     p      STARTED    0  230b 192.168.1.10 node-1

awareness_index 3     p      STARTED    0  230b 192.168.1.10 node-2
awareness_index 0     p      STARTED    0  230b 192.168.1.10 node-2

awareness_index 1     r      STARTED    0  230b 192.168.1.10 node-3
awareness_index 2     p      STARTED    0  230b 192.168.1.10 node-3

awareness_index 2     r      STARTED    0  230b 192.168.1.10 node-4
awareness_index 3     r      STARTED    0    0b 192.168.1.10 node-4
```

### Avec allocation awareness

###### Stoppez le cluster

###### Modifiez la configuration statique de chaque noeud (elasticsearch.yml) de manière à avoir deux datacenters.
* Pour les nodes 1 et 2
** Ouvrir le fichier $INSTALL_DIR/config/elasticsearch.yml
** Ajouter la property ci-dessous 
```properties
node.attr.datacenter: dc1
```
* Pour les nodes 3 et 4
** Ouvrir le fichier $INSTALL_DIR/config/elasticsearch.yml
** Ajouter la property ci-dessous 
```properties
node.attr.datacenter: dc2
```

Si vous éprouvez des difficultés à créer le cluster, un exemple de configuration vous est donné dans le dossier config.
Pour chaque fichier
* Remplacez l'entrée IP_ADDRESS par l'adresse IP de la machine dans laquelle votre cluster est créé
* Renommez le fichier elasticsearch.yml.node<X>.dc.awareness en elasticsearch.yml 
* Déposez chaque fichier elasticsearch.yml.node<X>.dc.awareness renommé dans le dossier $NODE<X>_DIR/config/elasticsearch.yml   



######  Redémarrez le cluster

######  Supprimez l'index précédemment créé
```
DELETE /awareness_index
```

######  Créez le cluster settings permettant l'allocation awareness (répartition des shards de manière homogène par datacenter)
```json
PUT _cluster/settings
{
  "persistent": {
    "cluster.routing.allocation.awareness.attributes": "datacenter"
  }
}
```

###### Recréez l'index awareness_index
* Voir requête ci-dessus

###### En utilisant l'API _cat, contrôlez la répartition des shards par noeuds.

La réponse donnée ci-dessous est donnée à titre d'exemple. 

```
#index           shard prirep state   docs store ip           node
#awareness_index 1     p      STARTED    0  230b 192.168.1.10 node-1
#awareness_index 0     r      STARTED    0  230b 192.168.1.10 node-1

#awareness_index 3     p      STARTED    0  230b 192.168.1.10 node-2
#awareness_index 2     r      STARTED    0  230b 192.168.1.10 node-2

#awareness_index 2     p      STARTED    0  230b 192.168.1.10 node-3
#awareness_index 1     r      STARTED    0  230b 192.168.1.10 node-3

#awareness_index 0     p      STARTED    0  230b 192.168.1.10 node-4
#awareness_index 3     r      STARTED    0  230b 192.168.1.10 node-4
```

###### Quel pourrait être l'intérêt de ce type de dispositif
Contrairement à l'architecture prédécente, avec ce dispositif, nous aurons l'assurance, en cas de réplication des shards, qu'ils seront répartis de manière homogène entre les deux datacenters. Ainsi, le résultat de la requête de l'API _cat précédente montre clairement
* la présence d'un premier groupe de shards (0, 1, 2 et 3) dans les noeuds 1 et 2 a qui la property node.attr.datacenter: dc1 a été affectée
* la présence d'un deuxième groupe de shards (0, 1, 2 et 3) dans les noeuds 3 et 4 a qui la property node.attr.datacenter: dc2 a été affectée.

La répartition des shards ne se fait donc plus de façon aléatoire. Le cluster est au courant de ses particularités physiques et la répartition en tient compte.  
Cette architecture présente au moins deux avantages
* Assurance d'avoir une continuité de service en cas de déploiement en rack (on-premise) ou en availability zone (cloud) et de perte d'un rack ou d'une zone
* Possibilité de sortir un datacenter pour maintenance tout en conservant le service

Attention, les mises à jour de version Elasticsearch pour un cluster ont des procédures particulières (voir documentation officielle en fonction de la version) 