#!/bin/bash

AUTH_SERVICE_HOME=services/authentication
AUTH_SERVICE_DOCKERFILE=Dockerfiles/Dockerfile.auth.service
AUTH_SCRIPT_DIR=scripts/auth
AUTH_CONF_DIR=conf/auth
AUTH_IMAGE_NAME=bookstore_auth

echo "Create authentication service for bookstore ..."
echo " - Create directory for Docker data"
mkdir -p ${AUTH_SERVICE_HOME}
echo " - Move Dockerfile to data directory"
cp ${AUTH_SERVICE_DOCKERFILE} ${AUTH_SERVICE_HOME}/Dockerfile
echo " - Move script files to data directory"
cp -R ${AUTH_SCRIPT_DIR}/* ${AUTH_SERVICE_HOME}/
echo " - Move config files to data directory"
cp -R ${AUTH_CONF_DIR}/* ${AUTH_SERVICE_HOME}/
echo " - Move consul to data directory"
cp consul ${AUTH_SERVICE_HOME}/
cp consul-template ${AUTH_SERVICE_HOME}/
echo " - Building Docker image"
docker build -t ${AUTH_IMAGE_NAME} ${AUTH_SERVICE_HOME} &> ${AUTH_SERVICE_HOME}/build.log
echo " - Save image"
docker save --output ${AUTH_SERVICE_HOME}/${AUTH_IMAGE_NAME}.img ${AUTH_IMAGE_NAME}

echo "Authentication service has been created!"
