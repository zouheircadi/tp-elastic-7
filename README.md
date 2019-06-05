# Hand On Lab Devoxx France 2019-04
# 3 Cas d’utilisation Google Play Store
## 3.1 Chargement du fichier de travail



###### Mapping inféré après chargement des données
```json
{
  "tp_elastic_gstore_v1" : {
    "aliases" : { },
    "mappings" : {
      "doc" : {
        "properties" : {
          "@timestamp" : {
            "type" : "date"
          },
          "android_ver" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "app_name" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "category" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "content_rating" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "current_ver" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "genres" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "installs" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "last_updated" : {
            "type" : "date"
          },
          "price" : {
            "type" : "float"
          },
          "rating" : {
            "type" : "float"
          },
          "reviews" : {
            "type" : "long"
          },
          "size" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "type" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          }
        }
      }
    },
    "settings" : {
      "index" : {
        "creation_date" : "1553638033456",
        "number_of_shards" : "1",
        "number_of_replicas" : "0",
        "uuid" : "MgqukNFtTVS46wXTHBy_sw",
        "version" : {
          "created" : "6060099"
        },
        "provided_name" : "tp_elastic_gstore_v1"
      }
    }
  }
}
```