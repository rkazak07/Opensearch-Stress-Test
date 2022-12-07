@echo off

cd C:\Users\ramazan\Desktop\github\opensearch-stress-test

SET indices=5
SET documents=2
SET clients=10
SET seconds=900
SET shards=4
SET bulk_size=500
SET max_fields_per_doc=50
SET max_size_per_field=500
SET stats_frequency=30

SET host=https://10.10.33.101:9200
SET username=admin
SET password=admin

python os-perf-test.py --os_ip %host%  --indices %indices% --documents %documents% --client_conn %clients% --duration %seconds% --shards %shards%  --bulk_number %bulk_size% --not-green --max-fields-per-document %max_fields_per_doc% --max-size-per-field %max_size_per_field% --stats-frequency %stats_frequency% --user %username% --pass %password% --no-verify
pause
