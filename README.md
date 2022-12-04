# Opensearch Stress Test

### Overview
This script generates a bunch of documents, and indexes as much as it can to Opensearch. While doing so, it prints out metrics to the screen to let you follow how your cluster is doing. Also this project supports working Opensearch up to version 2.2.0.

### How to use
* Download this project
* Change script
* Make sure you have Python 3.6+
* pip install Opensearch 


### How does it work
The script creates document templates based on your input. Say - 5 different documents.
The documents are created without fields, for the purpose of having the same mapping when indexing to OS.
After that, the script takes 10 random documents out of the template pool (with redraws) and populates them with random data.

After we have the pool of different documents, we select an index out of the pool, select documents * bulk size out of the pool, and index them.

The generation of documents is being processed before the run, so it will not overload the server too much during the benchmark.

### Mandatory Parameters
| Parameter | Description |
| --- | --- |
| `--os_ip` | Address of the Opensearch cluster (no protocol and port). You can supply mutiple clusters here, but only **one** node in each cluster (preferably the client node) |
| `--indices` | Number of indices to write to |
| `--documents` | Number of template documents that hold the same mapping |
| `--client_conn` | Number of threads that send bulks to ES |
| `--duration` | How long should the test run. Note: it might take a bit longer, as sending of all bulks whose creation has been initiated is allowed |


### Optional Parameters
| Parameter | Description | Default
| --- | --- | --- |
| `--shards` | How many shards per index |3|
| `--bulk-size` | How many documents each bulk request should contain |1000|
| `--max-fields-per-document` | What is the maximum number of fields each document template should hold |100|
| `--max-size-per-field` | When populating the templates, what is the maximum length of the data each field would get |1000|
| `--no-cleanup` | Boolean field. Don't delete the indices after completion |False|
| `--stats-frequency` | How frequent to show the statistics |30|
| `--not-green` | Script doesn't wait for the cluster to be green |False|
| `--no-verify` | No verify SSL certificates|False|
|`--http_compress` | enables gzip compression for request bodies|False|
|`--ssl_show_warn` | show ssl warnings|False|
|`--ssl_assert_hostname` | ssl assert hostname Default variables False|False|
| `--ca-file` | Path to Certificate file ||
| `--user` | basic authentication Username ||
| `--pass` | basic authentication Password ||




### Examples
> Run the test for 2 Opensearch clusters, with 4 indices on each, 5 random documents, don't wait for the cluster to be green, open 5 different writing threads run the script for 120 seconds and contains 5 client connections
```bash
python os-perf-test.py  --es_ip http://10.10.33.100:9200 http://10.10.33.101:9200 --indices 4 --documents 5 --seconds 120 --not-green --client_conn 5
```

> Run the test with SSL
```bash
 python os-perf-test.py --es_ip https://10.10.33.101:9200 --indices 5 --documents 5 --client_conn 2  --seconds 120 --ca-file /path/ca.pem
```

> Run the test with SSL without verify the certificate
```bash
 python os-perf-test.py --es_ip https://10.10.33.101:9200 --indices 5 --documents 5 --client_conn 1 --seconds 120 --no-verify
```

> Run the test with HTTP Authentification
```bash
 python os-perf-test.py --es_ip 10.10.33.100 --indices 5 --documents 5 --client_conn 1 --seconds 120 --user admin --pass admin
```

### Docker Installation

> Edit Dockerfile 
```bash
 docker build -t rkazak1/os-perf-test:v1.
```
> The content output is in the log.txt file
```bash
 docker run -d rkazak1/os-perf-test:v1 > log.txt
```
### Contribution
You are more then welcome!
Please open a PR or issues here.

