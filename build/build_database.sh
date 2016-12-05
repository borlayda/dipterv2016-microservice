#!/bin/bash

set -euo pipfail

DATABASE_SERVICE_HOME=services/database
DATABASE_SERVICE_DOCKERFILE=Dockerfiles/Dockerfile.database.service
DATABASE_SCRIPT_DIR=scripts/database
DATABASE_CONF_DIR=conf/database
DATABASE_IMAGE_NAME=bookstore_database

#pushd ..
if [[ ! -e consul ]]; then
    echo "Get Consul script from Internet"
    wget https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_386.zip && unzip consul_0.7.0_linux_386.zip
fi

if [[ ! -e consul-template ]]; then
    echo "Get consul-template script from Internet"
    wget https://releases.hashicorp.com/consul-template/0.16.0/consul-template_0.16.0_linux_386.zip && unzip consul-template_0.16.0_linux_386.zip
fi

echo "Create database service for bookstore ..."
echo " - Create directory for Docker data"
mkdir -p ${DATABASE_SERVICE_HOME}
echo " - Move Dockerfile to data directory"
cp ${DATABASE_SERVICE_DOCKERFILE} ${DATABASE_SERVICE_HOME}/Dockerfile
echo " - Move script files to data directory"
cp -R ${DATABASE_SCRIPT_DIR}/* ${DATABASE_SERVICE_HOME}/
echo " - Move config files to data directory"
cp -R ${DATABASE_CONF_DIR}/* ${DATABASE_SERVICE_HOME}/
echo " - Move consul to data directory"
cp consul ${DATABASE_SERVICE_HOME}/
cp consul-template ${DATABASE_SERVICE_HOME}/
echo " - Building Docker image"
docker build -t ${DATABASE_IMAGE_NAME} ${DATABASE_SERVICE_HOME} &> ${DATABASE_SERVICE_HOME}/build.log
echo " - Save image"
docker save --output ${DATABASE_SERVICE_HOME}/${DATABASE_IMAGE_NAME}.img ${DATABASE_IMAGE_NAME}

echo "Database service has been created!"
popd
