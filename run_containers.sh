#!/bin/bash

services="database webserver order auth proxy"

docker network create bookstore

for service in ${services}
do
    echo "Start ${service} service ..."
    docker run -d --name "${service}" -h "${service}" --net=bookstore bookstore_${service}
done
