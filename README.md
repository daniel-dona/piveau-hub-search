# Hub Search

## Description

You know, for search.

## Prerequisites

* Java JDK 1.8
* Maven 3
* Elasticsearch 7.1.0

## Elasticsearch

Check if Elasticsearch is running:

```
curl -X GET localhost:9200
{
  "name" : "cb3a03e60f82",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "fEt3Aw5xSX6sb7wF1oj-4A",
  "version" : {
    "number" : "7.1.0",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "606a173",
    "build_date" : "2019-05-16T00:43:15.323135Z",
    "build_snapshot" : false,
    "lucene_version" : "8.0.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

## Setup

* Clone repository
* Navigate into the cloned directory
* Create the configuration file

```
cp conf/config.sample.json conf/config.json
```

* Edit the configuration file to your requirements
* **NOTE**: Mandatory fields:
    * `PIVEAU_HUB_SEARCH_API_KEY`
    * `PIVEAU_HUB_SEARCH_ES_CONFIG`
* Start the application

```
$ mvn package exec:java
```

* Browse to `http://localhost:8080` for api specification

**Note**: The Api-Key and Elasticsearch Config is also configurable through environment variables. 
Then no configuration file is necessary. 
All environment variables have a higher priority then config file variables.

## Integration Tests

Test files are split in `UnitTest` and `IntegrationTest`. 
The name convention for integration tests is `[.*IntegrationTest.*]`.
Integration tests are excluded from normal build.
If you want to run integration tests, type:

```
$ mvn test -Dtest=*IntegrationTest
```

## Result window configuration / Pagination

If from + size > max_result_window an empty results array is returned.

Where "from" equals "page*limit" and "size" equals "limit". 

For the ckan endpoint "from" equals "start" and "size" equals "rows".  

Change max_result_window in the cli by: 

```
% max_result_window value
```

## Config / Environment Variables

##### Change the api key of the Application

```
export PIVEAU_HUB_SEARCH_API_KEY="your-api-key"
```

##### Change the config of the elasticsearch service

```
export PIVEAU_HUB_SEARCH_ES_CONFIG='{
 "host": "localhost",
 "port": 9200,
 "index": {
   "dataset": {
     "max_agg_size": 50,
     "max_result_window": 1500000,
     "settings": "conf/elasticsearch/settings.json",
     "mapping": "conf/elasticsearch/dataset_mapping.json",
     "searchParams": [
       {
         "name": "temporal",
         "field": "temporal_coverages"
       },
       {
         "name": "spatial",
         "field": "spatial"
       }
     ],
     "facets": [
       {
         "name": "country",
         "title": "Countries",
         "path": "country"
       },
       {
         "name": "catalog",
         "title": "Catalogues",
         "path": "catalog"
       },
       {
         "name": "categories",
         "title": "Categories",
         "path": "categories"
       },
       {
         "name": "keywords",
         "title": "Keywords",
         "path": "keywords"
       },
       {
         "name": "format",
         "title": "Formats",
         "path": "distributions.format"
       },
       {
         "name": "licence",
         "title": "Licences",
         "path": "distributions.licence"
       }
     ]
   },
   "catalogue": {
     "max_agg_size": 50,
     "max_result_window": 10000,
     "settings": "conf/elasticsearch/settings.json",
     "mapping": "conf/elasticsearch/catalogue_mapping.json",
     "facets": [
       {
         "name": "country",
         "title": "Countries",
         "path": "country"
       }
     ],
     "searchParams": [
       {
         "name": "temporal",
         "field": "issued"
       }
     ]
   },
   "distribution": {
     "max_agg_size": 50,
     "max_result_window": 10000,
     "settings": "conf/elasticsearch/settings.json",
     "mapping": "conf/elasticsearch/distribution_mapping.json",
     "facets": [
       {
         "name": "format",
         "title": "Formats",
         "path": "format"
       },
       {
         "name": "licence",
         "title": "Licence",
         "path": "licence"
       }
     ],
     "searchParams": [
     ]
   }
 }
}'
```

##### Change the port of the Application

```
export PIVEAU_HUB_SEARCH_SERVICE_PORT=8080
```

##### Change the config of the cli service

```
export PIVEAU_HUB_SEARCH_CLI_CONFIG='{
   "port": 8081,
   "type": "http"
}'
```

**Note**: Possible types are http, ssh and telnet

##### Change boost parameters for ranking

```
export PIVEAU_HUB_SEARCH_BOOST='{
    "field" : 1.0
}'
```

**Note:** The boost parameters can also be changed via the cli

##### Change gazetteer parameters

**Osmnames**:
```
export PIVEAU_HUB_SEARCH_GAZETTEER_CONFIG='{
    "type": "osmnames",
    "url": "http://localhost:8089/q/"
}'
```

**Con Terra**:
```
export PIVEAU_HUB_SEARCH_GAZETTEER_CONFIG='{
    "type": "conterra",
    "url": "http://localhost:8089/gazetteer/gazetteer/query"
}'
```

## Command Line Interface

##### Connect via http (username=admin, password=password):

```
https://localhost:8081/shell.html
```

##### Connect via ssh (password=password):

```
ssh -p 8081 admin@localhost
```

##### Connect via telnet:

```
telnet localhost 8081
```

##### Display commands:

```
% help
```

##### Create index:

```
% index create indexname
```

##### Delete index:

```
% index delete indexname
```

##### Add mapping:

```
% mapping indexname typename
```

##### Boost command:

```
% boost typename fieldname value
```

##### Boost example:

```
% boost dataset title 3.0
```

##### Load mockdata:

```
% load-mockdata
```

##### Increase max_agg_size:

```
% max_agg_size 50
```

##### Increase max_result_window:

```
% max_result_window 1000000
```