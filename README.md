# Cas d’utilisation Google Play Store
## Chargement du fichier de travail


Utilisez logstash pour charger le fichier googleplaystore.csv
```shell
$LOGSTATSH_INSTALL_DIR/7.3.1/bin/logstash -f /tp-elastic/tp-elastic-7/data/ls-google-playstore.conf
```

Tester la création de l’index
###### Test de l'existence
```shell
HEAD tp_elastic_gstore_v1
``` 

Contrôler le mapping (voir exemple de mapping inféré sur la branche git).
```shell
GET tp_elastic_gstore_v1
```

Faites un count pour compter la totalité des documents de l’index
```shell
GET tp_elastic_gstore_v1/_count
```


Si la création de l’index est ok, créer un alias appelé tp_elastic_gstore vers l’index tp_elastic_gstore_v1.
```json
POST /_aliases
{
    "actions" : [
        { "add" : { "index" : "tp_elastic_gstore_v1", "alias" : "tp_elastic_gstore" } }
    ]
}
```