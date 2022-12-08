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
| `--no-verify` | No verify SSL certificates |False|
| `--use_ssl` | Can be used if the certificate is trusted |False|
|`--ssl_show_warn` | Show ssl warnings |False|
|`--http_compress` | If enabled then HTTP request bodies will be compressed with gzip and HTTP responses |False|
|`--ssl_assert_hostname` | Use the hostname from the URL, if **False** suppress hostname checking |False|
| `--user` | Basic authentication Username ||
| `--pass` | Basic authentication Password ||




### Examples
> Run the test for 1 Opensearch clusters, with 5 indices on each, 10 random documents, don't wait for the cluster to be green, with SSL without verify the certificate, open 2 different writing threads run the script for 60 seconds
```bash
python os-perf-test.py --os_ip https://10.10.33.101:9200 --user admin --pass admin --indices 5 --documents 10 --client_conn 2 --duration 60 --use_ssl --no-verify --not-green --shards 1
```

> Run the test with SSL
```bash
 python os-perf-test.py --os_ip https://10.10.33.101:9200 --user admin --pass admin --use_ssl --indices 5 --documents 5 --client_conn 2  --duration 120 --ca-file /path/ca.pem
```

> Run the test with SSL without verify the certificate
```bash
 python os-perf-test.py --os_ip https://10.10.33.101:9200 --indices 5 --documents 5 --client_conn 1 --duration 120 --use_ssl  --no-verify
```

> Run the test with HTTP Authentification
```bash
 python os-perf-test.py --os_ip 10.10.33.100 --indices 5 --documents 5 --client_conn 1 --duration 120 --user admin --pass admin
```

### Example Output
> Run the test  Opensearch cluster on rhel8 , with 5 indices on each, 10 random documents, don't wait for the cluster to be green, with SSL without verify the certificate, open 2 different writing threads run the script for 60 seconds
```bash
[root@MasterNode opensearch-stress-test]# sh run2.sh

Starting initialization of https://10.10.33.102:30650
/usr/local/lib/python3.6/site-packages/opensearchpy/connection/http_urllib3.py:201: UserWarning: Connecting to https://10.10.33.102:30650 using SSL with verify_certs=False is insecure.
  % self.host
Done!
Creating indices..
Generating documents and workers..
Done!
Starting the test. Will print stats every 30 seconds.
The test would run for 60 seconds, but it might take a bit more because we are waiting for current bulk operation to complete.

Elapsed time: 31 seconds
Successful bulks: 35 (17500 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 494.8754653930664 MB which is 15.96 MB/s


Test is done! Final results:
Elapsed time: 61 seconds
Successful bulks: 78 (39000 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 1104.9954175949097 MB which is 18.11 MB/s

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
> Run the test on O-S cluster 10.10.33.102, with 5 indices, 5 random documents with up to 20 fields in each, the size of each field on each document can be up to 5 chars, each index will have 1 shard and 1 replicas, the test will run from 2 client (thread) for 100 seconds, will print statistics every 15 seconds, will index in bulks of 500 documents  will leave everything in Opensearch after the test 
````
[root@server opensearch-stress-test]# docker run -t -i rkazak1/os-perf-test:v1 --os_ip https://10.10.33.102:30650 \
> --user admin \
> --pass admin \
> --no-verify \
> --use_ssl \
> --indices 5 --documents 5 \
> --client_conn 2 --duration 100 \
> --max-fields-per-document 5 --max-size-per-field 20 \
> --no-cleanup --stats-frequency 15 
> --no-verify \
> --not-green 

Starting initialization of https://10.10.33.102:30650
/usr/local/lib/python3.10/dist-packages/opensearchpy/connection/http_urllib3.py:199: UserWarning: Connecting to https://10.10.33.102:30650 using SSL with verify_certs=False is insecure.
  warnings.warn(
Done!
Creating indices..
Generating documents and workers..
Done!
Starting the test. Will print stats every 15 seconds.
The test would run for 100 seconds, but it might take a bit more because we are waiting for current bulk operation to complete.

Elapsed time: 17 seconds
Successful bulks: 230 (115000 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 11.710894584655762 MB which is 0.69 MB/s

Elapsed time: 32 seconds
Successful bulks: 544 (272000 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 27.701778411865234 MB which is 0.87 MB/s

Elapsed time: 47 seconds
Successful bulks: 866 (433000 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 44.09731578826904 MB which is 0.94 MB/s

Elapsed time: 62 seconds
Successful bulks: 1224 (612000 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 62.339834213256836 MB which is 1.01 MB/s

Elapsed time: 77 seconds
Successful bulks: 1588 (794000 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 80.8918342590332 MB which is 1.05 MB/s

Elapsed time: 92 seconds
Successful bulks: 1913 (956500 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 97.4452133178711 MB which is 1.06 MB/s


Test is done! Final results:
Elapsed time: 100 seconds
Successful bulks: 2092 (1046000 documents)
Failed bulks: 0 (0 documents)
Indexed approximately 106.56290054321289 MB which is 1.07 MB/s

