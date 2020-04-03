curl -XPOST "http://localhost:9200/tp_elastic_i18n_262/_bulk" -H 'Content-Type: application/json' -d'
{ "index": { "_id": 1 }}
{"app_name_en" : "Photo Editor & ScrapBook", "app_name_fr" : "Editeur de photo & album photo", "app_name_es" : "Editor de fotos & álbum de fotos", "type" : "Free", "genres" : "Art & Design", "category" : "ART_AND_DESIGN","price" : 0.0, "last_updated" : "2018-01-06T23:00:00.000Z", "content_rating" : "Everyone","rating" : 4.1}
{ "index": { "_id": 2 }}
{ "app_name_en" : "QR Code Reader", "app_name_fr" : "Lecteur de QR code", "app_name_es" : "Lector de código QR", "type" : "Free", "genres" : "Tools", "category" : "TOOLS", "price" : 0.0, "last_updated" : "2016-03-15T23:00:00.000Z", "content_rating" : "Everyone", "rating" : 4.0}
{ "index": { "_id": 4 }}
{ "app_name_en" : "SHAREit - Transfer & Share", "app_name_fr" : "SHAREit - Transférer et partager", "app_name_es" : "SHAREit - Transfiere y comparte", "type" : "Free", "genres" : "Tools", "category" : "TOOLS", "price" : 0.0, "last_updated" : "2018-07-29T22:00:00.000Z", "content_rating" : "Everyone", "rating" : 4.6}
'
