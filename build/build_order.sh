#!/bin/bash

set -euo pipfail

RESERVE_SERVICE_HOME=services/order
RESERVE_SERVICE_DOCKERFILE=Dockerfiles/Dockerfile.order.service
RESERVE_SCRIPT_DIR=scripts/order
RESERVE_CONF_DIR=conf/order
RESERVE_IMAGE_NAME=bookstore_order

#pushd ..
if [[ ! -e consul ]]; then
    echo "Get Consul script from Internet"
    wget https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_386.zip && unzip consul_0.7.0_linux_386.zip
fi

if [[ ! -e consul-template ]]; then
    echo "Get consul-template script from Internet"
    wget https://releases.hashicorp.com/consul-template/0.16.0/consul-template_0.16.0_linux_386.zip && unzip consul-template_0.16.0_linux_386.zip
fi

echo "Create order service for bookstore ..."
echo " - Create directory for Docker data"
mkdir -p ${RESERVE_SERVICE_HOME}
echo " - Move Dockerfile to data directory"
cp ${RESERVE_SERVICE_DOCKERFILE} ${RESERVE_SERVICE_HOME}/Dockerfile
echo " - Move script files to data directory"
cp -R ${RESERVE_SCRIPT_DIR}/* ${RESERVE_SERVICE_HOME}/
echo " - Move config files to data directory"
cp -R ${RESERVE_CONF_DIR}/* ${RESERVE_SERVICE_HOME}/
echo " - Move consul to data directory"
cp consul ${RESERVE_SERVICE_HOME}/
cp consul-template ${RESERVE_SERVICE_HOME}/
echo " - Compile java sources"
cd ${RESERVE_SERVICE_HOME}
mvn install
cd "../.."
echo " - Building Docker image"
docker build -t ${RESERVE_IMAGE_NAME} ${RESERVE_SERVICE_HOME} &> ${RESERVE_SERVICE_HOME}/build.log
echo " - Save image"
docker save --output ${RESERVE_SERVICE_HOME}/${RESERVE_IMAGE_NAME}.img ${RESERVE_IMAGE_NAME}

echo "Order service has been created!"
popd
