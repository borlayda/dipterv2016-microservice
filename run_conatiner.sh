#!/bin/bash

services="database webserver reserve auth"

HAPROXY_ID=$(docker run -d -h proxy -t bookstore_proxy)
echo "${HAPROXY_ID}"
DOCKER_IP_HAPROXY=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' $HAPROXY_ID 2>/dev/null)
echo "${DOCKER_IP_HAPROXY}"

for service in ${services}
do
    echo "Start ${service} service ..."
    docker run -d bookstore_${service} ${service}.sh "${DOCKER_IP_HAPROXY}"
done

