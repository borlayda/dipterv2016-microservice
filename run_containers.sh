#!/bin/bash

services="proxy database webserver reserve auth"

docker network create bookstore

for service in ${services}
do
    echo "Start ${service} service ..."
    docker run -d --name "${service}" -h "${service}" --net=bookstore bookstore_${service} ${service}.sh "${DOCKER_IP_HAPROXY}"
done

