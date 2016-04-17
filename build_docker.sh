#!/bin/bash

services="database webserver proxy reserve auth"

for service in ${services}
do
    echo "Create ${service} for bookstore ..."
    mkdir -p services/${service}
    cp Dockerfiles/Dockerfile.${service}.service services/${service}/Dockerfile
    cp -R scripts/${service}/* services/${service}/
    docker build -t bookstore_${service} services/${service} &> services/${service}/build.log
done

echo "Microservices has been created!"

