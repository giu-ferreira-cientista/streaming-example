# kafka-streaming

Airflow:

    - https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html

Kafka:

    - https://developer.confluent.io/quickstart/kafka-docker/?build=apps

Spark:

    - https://hub.docker.io - Referencia docker compose Jupyter + All Spark

    - docker exec -t spark bash -c 'chmod -R 777 *'

    - Execucao Scripts Jupyter

    - spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:2.4.5,io.delta:delta-core_2.12:0.7.0 --master local[*] --driver-memory 4g --executor-memory 4g /home/jovyan/work/app/json-producer.py

Pinot:

    - https://docs.pinot.apache.org/basics/getting-started/running-pinot-in-docker

    - Connect to Kafka Table

    - docker exec -it pinot-controller bin/pinot-admin.sh AddTable \
            -schemaFile examples/addtable/patient_schema.json \
            -tableConfigFile examples/addtable/patient_realtime_table_config.json \
            -exec
            
    - docker exec -it pinot-controller bin/pinot-admin.sh ChangeTableState -tableName patients -state drop -controllerHost pinot-controller -controllerPort 9000

    Superset:

    - https://superset.apache.org/docs/installation/installing-superset-using-docker-compose/

    - Github fork

    - pip install pinotdb

    - pinot+http://pinot-broker:8099/query?server=http%3A%2F%2Fpinot-controller%3A9000%2F

    - Connect to Pinot Realtime Table

    - docker exec \
        -t superset_app \
        bash -c 'superset import-dashboards -p /superset/import/dashboard.zip'

Docker network:    
        service:
            networks:
            static-network:
                ipv4_address: 172.10.128.103

    - networks:
        static-network:     
            name: static-network
            ipam:
                config:
                    - subnet: 172.10.0.0/16
            #docker-compose v3+ do not use ip_range
            ip_range: 172.18.5.0/24
            external: true
    
    docker network connect static-network spark
    docker network connect static-network pinot-controller
    docker network connect static-network superset_app