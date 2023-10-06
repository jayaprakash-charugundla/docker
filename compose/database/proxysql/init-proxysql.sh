#!/usr/bin/env bash


echo
echo "Creating ProxySQL monitor user"
echo "------------------------------"
docker exec -i -e MYSQL_PWD=password mysql-master mysql -uroot --ssl-mode=DISABLED < sql/master-proxysql-monitor-user.sql


echo
echo "Starting proxysql"
echo "===================="

docker compose -f proxysql-docker-compose.yml up -d

