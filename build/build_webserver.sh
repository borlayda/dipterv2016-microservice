#!/bin/bash

WEBSERVER_SERVICE_HOME=services/web
WEBSERVER_SERVICE_DOCKERFILE=Dockerfiles/Dockerfile.web.service
WEBSERVER_SCRIPT_DIR=scripts/webserver
WEBSERVER_CONF_DIR=conf/webserver
WEBSERVER_IMAGE_NAME=bookstore_webserver

pushd ..
if [[ ! -e consul ]]; then
    echo "Get Consul script from Internet"
    wget https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_386.zip && unzip consul_0.7.0_linux_386.zip
fi

if [[ ! -e consul-template ]]; then
    echo "Get consul-template script from Internet"
    wget https://releases.hashicorp.com/consul-template/0.16.0/consul-template_0.16.0_linux_386.zip && unzip consul-template_0.16.0_linux_386.zip
fi

echo "Create webserver service for bookstore ..."
echo " - Create directory for Docker data"
mkdir -p ${WEBSERVER_SERVICE_HOME}
echo " - Move Dockerfile to data directory"
cp ${WEBSERVER_SERVICE_DOCKERFILE} ${WEBSERVER_SERVICE_HOME}/Dockerfile
echo " - Move script files to data directory"
cp -R ${WEBSERVER_SCRIPT_DIR}/* ${WEBSERVER_SERVICE_HOME}/
echo " - Move config files to data directory"
cp -R ${WEBSERVER_CONF_DIR}/* ${WEBSERVER_SERVICE_HOME}/
echo " - Move consul to data directory"
cp consul ${WEBSERVER_SERVICE_HOME}/
cp consul-template ${WEBSERVER_SERVICE_HOME}/
echo " - Building Docker image"
docker build -t ${WEBSERVER_IMAGE_NAME} ${WEBSERVER_SERVICE_HOME} &> ${WEBSERVER_SERVICE_HOME}/build.log
echo " - Save image"
docker save --output ${WEBSERVER_SERVICE_HOME}/${WEBSERVER_IMAGE_NAME}.img ${WEBSERVER_IMAGE_NAME}

echo "Webserver service has been created!"
popd
