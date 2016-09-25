#!/bin/bash

services="database webserver proxy reserve auth"

echo "Get Consul script from Internet"
wget https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_386.zip && unzip consul_0.7.0_linux_386.zip

for service in ${services}
do
    echo "Create ${service} for bookstore ..."
    echo " - Create directory for Docker data"
    mkdir -p services/${service}
    echo " - Move Dockerfile to data directory"
    cp Dockerfiles/Dockerfile.${service}.service services/${service}/Dockerfile
    echo " - Move script files to data directory"
    cp -R scripts/${service}/* services/${service}/
    echo " - Move config files to data directory"
    cp -R conf/${service}/* services/${service}/
    echo " - Move consul to data directory"
    cp consul services/${service}/
    echo " - Building Docker image"
    docker build -t bookstore_${service} services/${service} &> services/${service}/build.log
done

echo "Microservices has been created!"

