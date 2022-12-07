# Opensearch Stress Test

### Overview
This script generates a bunch of documents, and indexes as much as it can to Opensearch. While doing so, it prints out metrics to the screen to let you follow how your cluster is doing. 

### Note
* This application is developed in opensearch version 1.3.6
* If you constantly receive a failed error even though the Opensearch server has a low resource usage. Review the resource usage of the computer on which you perform the operation.

### How to use
* Download this project
* Change script
* Make sure you have Python 3.6+
* pip install opensearch-py (Tested in 1.1.0 and 2.0.1)


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
| ` --client_conn `   | Number of threads that send bulks to OS |
| `--duration` | How long should the test run. Note: it might take a bit longer, as sending of all bulks whose creation has been initiated is allowed |


### Optional Parameters
| Parameter | Description | Default
| --- | --- | --- |
| `--shards` | How many shards per index |3|
| `--bulk_number` | How many documents each bulk request should contain |500|
| `--max-fields-per-document` | What is the maximum number of fields each document template should hold |100|
| `--max-size-per-field` | When populating the templates, what is the maximum length of the data each field would get |1000|
| `--no-cleanup` | Boolean field. Don't delete the indices after completion |False|
| `--stats-frequency` | How frequent to show the statistics |30|
| `--not-green` | Script doesn't wait for the cluster to be green |False|
| `--ca-file` | Path to Certificate file ||
| `--no-verify` | No verify SSL certificates|False|
|`--ssl_show_warn` | show ssl warnings|False|
|`--http_compress` | enables gzip compression for request bodies|False|
|`--ssl_assert_hostname` | ssl assert hostname Default variables False|False|
| `--user` | Basic authentication Username ||
| `--pass` | Basic authentication Password ||




### Examples
> Run the test for 1 Opensearch clusters, with 5 indices on each, 10 random documents, don't wait for the cluster to be green, open 2 different writing threads run the script for 120 seconds
```bash
python os-perf-test.py --os_ip https://10.10.33.101:9200 --user admin --pass admin --indices 5 --documents 10 --client_conn 2 --duration 60 --no-verify --not-green --bulk_number 800 --shards 1 --ssl_assert_hostname --http_compress --ssl_show_warn --not-green
```

> Run the test with SSL
```bash
 python os-perf-test.py --os_ip https://10.10.33.101:9200 --indices 5 --documents 5 --client_conn 2  --seconds 120 --ca-file /path/ca.pem
```

> Run the test with SSL without verify the certificate
```bash
 python os-perf-test.py --os_ip https://10.10.33.101:9200 --indices 5 --documents 5 --client_conn 1 --seconds 120 --no-verify
```

> Run the test with HTTP Authentification
```bash
 python os-perf-test.py --os_ip 10.10.33.100 --indices 5 --documents 5 --client_conn 1 --seconds 120 --user admin --pass admin
```

### Example Output
```
python3 os-perf-test.py --os_ip https://10.10.33.102:30650 --user admin --pass admin --indices 5 --documents 10 --client_conn 2 --duration 60 --no-verify --not-green --bulk_number 800 --shards 1 --ssl_assert_hostname --http_compress --ssl_show_warn --not-green

Starting initialization of https://10.10.33.102:30650
Done!
Creating indices..
Generating documents and workers..
Done!
Starting the test. Will print stats every 30 seconds.
The test would run for 60 seconds, but it might take a bit more because we are waiting for current bulk operation to complete.

Elapsed time: 31 seconds
Successful bulks: 52 (26000 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 770.9049263000488 MB which is 24.87 MB/s


Test is done! Final results:
Elapsed time: 60 seconds
Successful bulks: 111 (55500 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 1647.783311843872 MB which is 27.46 MB/s

Cleaning up created indices..
Done!
```


### Docker Installation

> Build Docker images
```bash
 docker build -t rkazak1/os-perf-test:v1 .
```
> While running the Docker image, revise the parameters according to your system.
```bash
 docker run -t -i rkazak1/os-perf-test:v1 --os_ip <https://ip:port> \
--indices <indices number> --documents <document number> \
--client_conn <client number> --duration <duration> \
--shards <shards number> --bulk_number <bulk number> \
--user <username> \
--pass <password> \
--no-verify \
--not-green
```


### Docker Example
> Run the test with ssl without validation the certificate for 1 Opensearch cluster with 5 indices, 5 random documents  in each ,don't wait for the cluster to be green, open 10 different write threads and run the script for 100 seconds
````
[root@server opensearch-stress-test]# docker run -t -i rkazak1/os-perf-test:v1 --os_ip https://10.10.33.102:30650 \
> --user admin \
> --pass admin \
> --no-verify \
> --indices 5 --documents 5 \
> --client_conn 10 --duration 100 \
> --not-green \
> --http_compress \
> --ssl_assert_hostname \
> --ssl_show_warn

Starting initialization of https://10.10.33.102:30650
Done!
Creating indices..

Generating documents and workers..
Done!
Starting the test. Will print stats every 30 seconds.
The test would run for 100 seconds, but it might take a bit more because we are waiting for current bulk operation to complete.

Elapsed time: 32 seconds
Successful bulks: 46 (23000 documents)
Failed bulks: 64 (32000 documents)
Indexed approximately 490.70516300201416 MB which is 15.33 MB/s

Elapsed time: 62 seconds
Successful bulks: 88 (44000 documents)
Failed bulks: 142 (71000 documents)
Indexed approximately 942.7716693878174 MB which is 15.21 MB/s

Elapsed time: 92 seconds
Successful bulks: 101 (50500 documents)
Failed bulks: 363 (181500 documents)
Indexed approximately 1079.806526184082 MB which is 11.74 MB/s


Test is done! Final results:
Elapsed time: 104 seconds
Successful bulks: 101 (50500 documents)
Failed bulks: 440 (220000 documents)
Indexed approximately 1079.806526184082 MB which is 10.38 MB/s

Cleaning up created indices..
Could not delete index: fuqkjzvv. Continue anyway..
Could not delete index: dwgsjik. Continue anyway..
Could not delete index: ikdolzrvmqbov. Continue anyway..
Could not delete index: todhzydcsstmkmc. Continue anyway..
Could not delete index: djtxgcklmygemh. Continue anyway..
Done!