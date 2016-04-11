#!/bin/bash

services=database webserver proxy reserve auth

for service in services
do
    echo "Create ${service} for bookstore"
    mkdir -p ${service}
    cp Dockerfiles/Dockerfile.${service}.service ${service}/Dockerfile
    cp scripts/${service}/* ${scripts}/
    docker build -t bookstore_${service} ${service}
done

echo "Microservices has been created!"

