#!/bin/bash

set -euo pipefail

PROXY_SERVICE_HOME=services/proxy
PROXY_SERVICE_DOCKERFILE=Dockerfiles/Dockerfile.proxy.service
PROXY_SCRIPT_DIR=scripts/proxy
PROXY_CONF_DIR=conf/proxy
PROXY_IMAGE_NAME=bookstore_proxy

#pushd ..
if [[ ! -e consul ]]; then
    echo "Get Consul script from Internet"
    wget https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_386.zip && unzip consul_0.7.0_linux_386.zip
fi

if [[ ! -e consul-template ]]; then
    echo "Get consul-template script from Internet"
    wget https://releases.hashicorp.com/consul-template/0.16.0/consul-template_0.16.0_linux_386.zip && unzip consul-template_0.16.0_linux_386.zip
fi

echo "Create proxy service for bookstore ..."
echo " - Create directory for Docker data"
mkdir -p ${PROXY_SERVICE_HOME}
echo " - Move Dockerfile to data directory"
cp ${PROXY_SERVICE_DOCKERFILE} ${PROXY_SERVICE_HOME}/Dockerfile
echo " - Move script files to data directory"
cp -R ${PROXY_SCRIPT_DIR}/* ${PROXY_SERVICE_HOME}/
echo " - Move config files to data directory"
cp -R ${PROXY_CONF_DIR}/* ${PROXY_SERVICE_HOME}/
echo " - Move consul to data directory"
cp consul ${PROXY_SERVICE_HOME}/
cp consul-template ${PROXY_SERVICE_HOME}/
echo " - Building Docker image"
docker build -t ${PROXY_IMAGE_NAME} ${PROXY_SERVICE_HOME} &> ${PROXY_SERVICE_HOME}/build.log
echo " - Save image"
docker save --output ${PROXY_SERVICE_HOME}/${PROXY_IMAGE_NAME}.img ${PROXY_IMAGE_NAME}

echo "Proxy service has been created!"
#popd
