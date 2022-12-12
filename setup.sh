#!/bin/bash

cd pinot

docker-compose up -d

cd ..

cd kafka

docker-compose up -d

cd ..

cd spark

docker-compose up -d  

cd ..

cd superset

docker-compose -f docker-compose-non-dev.yml up -d

cd ..

cd airflow

docker-compose up airflow-init 
docker-compose up -d 

cd ..

docker network connect static-network spark
docker network connect static-network pinot-controller
docker network connect static-network pinot-zookeeper
docker network connect static-network pinot-broker
docker network connect static-network pinot-server
docker network connect static-network kafka
docker network connect static-network zookeeper
docker network connect static-network kafka-ui
docker network connect static-network superset_app
docker network connect static-network airflow-airflow-webserver-1
docker network connect static-network airflow-airflow-scheduler-1
docker network connect static-network airflow-airflow-triggerer-1


docker exec -t pinot-controller bin/pinot-admin.sh AddTable \
    -schemaFile examples/addtable/patient_schema.json \
    -tableConfigFile examples/addtable/patient_realtime_table_config.json \
    -exec

docker exec -t superset_app pip install pinotdb==0.3.9 && \ 
    bash -c 'superset import-dashboards -p /superset/import/dashboard.zip'

docker exec -t spark bash -c 'chmod -R 777 *'

docker exec -t spark pip install flask flask-cors kafka-python sseclient pyspark nltk pycaret

docker exec -t spark pip install --upgrade pandas==1.3.4

docker exec -t spark python /home/jovyan/work/api/app.py
