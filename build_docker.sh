#!/bin/bash

services="database webserver proxy reserve auth"

CONSUL_ZIP=consul_0.6.4_linux_386.zip

echo "Get consul script ..."

wget -q https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_386.zip
unzip ${CONSUL_ZIP} &> /dev/null
rm -rf ${CONSUL_ZIP}

for service in ${services}
do
    echo "Create ${service} for bookstore ..."
    mkdir -p services/${service}
    cp Dockerfiles/Dockerfile.${service}.service services/${service}/Dockerfile
    cp consul services/${service}/
    cp -R scripts/${service}/* services/${service}/
    docker build -t bookstore_${service} services/${service} &> services/${service}/build.log
done

echo "Microservices has been created!"

