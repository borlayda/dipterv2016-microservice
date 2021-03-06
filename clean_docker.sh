#!/bin/bash

services="database webserver proxy order auth"

docker stop $(docker ps -a | awk '/bookstore/ {print $1}')
docker rm $(docker ps -a | awk '/bookstore/ {print $1}')

for service in ${services}
do
    echo "Delete ${service} image"
    docker rmi bookstore_${service}
done

if [ -d services ]; then
    rm -rf services
fi
docker network rm bookstore

if [ -e consul ]; then
    rm -rf consul*
fi
