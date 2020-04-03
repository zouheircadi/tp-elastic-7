## I18N


* Rechercher les documents qui contiennent
    * les tokens *transfer photo* (recherche limitée au champ en anglais)
    
    ```json
    GET /tp_elastic_i18n_262/_search
    {
      "query": {
        "multi_match": {
          "query": "transfer photo",
          "fields": [
            "app_name_en"
          ],
          "type": "most_fields"
        }
      }
    }      
    ```  
    
    * les tokens *transfer photo* (recherche sur tous les champs)
    ```json
    GET /tp_elastic_i18n_262/_search
    {
      "query": {
        "multi_match": {
          "query": "transfer photo",
          "fields": [
            "app_name_*"
          ],
          "type": "most_fields"
        }
      }
    }      
    ```    
    
    * les tokens *transfer photo* (recherche sur tous les champs en pondérant le champ en anglais : boost = 2)
    ```json
    GET /tp_elastic_i18n_262/_search
    {
      "query": {
        "multi_match": {
          "query": "transfer photo",
          "fields": [
            "app_name_*",
            "app_name_en^2"
          ],
          "type": "most_fields"
        }
      }
    }      
    ```
