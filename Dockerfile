FROM python:3.8-slim-buster

MAINTAINER Ramazan KAZAK (ramazankazak_2016@hotmail.com)


WORKDIR /app


# Edit Opensearch Configuration

ENV host=https://10.10.33.101:9200
ENV user=admin
ENV pass=admin
ENV indices=5
ENV documents=2
ENV clients=10
ENV seconds=900
ENV shards=4
ENV bulk_size=500
ENV max_fields_per_doc=50
ENV max_size_per_field=500
ENV stats_frequency=30



RUN pip install opensearch-py

COPY . .

CMD python os-perf-test.py  --es_ip $host \
        --indices $indices --documents $documents \
        --client_conn $clients --seconds $seconds \
        --shards $shards \
        --bulk-size $bulk_size \
        --max-fields-per-document $max_fields_per_doc \
        --max-size-per-field $max_size_per_field \
        --stats-frequency $stats_frequency 
        --user $user \
        --pass $pass \
        --no-verify

