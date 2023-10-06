#!/usr/bin/env bash

source scripts/my-functions.sh

echo
echo "Starting environment"
echo "===================="

docker compose -f mysql-8-master-slave-docker-compose.yml up -d

echo
wait_for_container_log "mysql-master" "port: 3306"
wait_for_container_log "mysql-slave-1" "port: 3306"
wait_for_container_log "mysql-slave-2" "port: 3306"

echo
echo "Setting up MySQL Replication"
echo "-------------------------"
docker exec -i -e MYSQL_PWD=password mysql-master mysql -uroot < sql/master-replication.sql
docker exec -i -e MYSQL_PWD=password mysql-slave-1 mysql -uroot < sql/slave-replication.sql
docker exec -i -e MYSQL_PWD=password mysql-slave-2 mysql -uroot < sql/slave-replication.sql


echo
echo "Checking MySQL Replication"
echo "--------------------------"
./check-replication-status.sh


echo
echo "MySQL cluster is ready!"

