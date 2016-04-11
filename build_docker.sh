#!/bin/bash

# Create Database
mkdir -p database
cp Dockerfile.database.service database/Dockerfile
cp database.sh database/database.sh
docker build -t bookstore_database database

# Create Web server
mkdir -p webserver
cp Dockerfile.bookstore.service webserver/Dockerfile
cp bookstore.sh webserver/bookstore.sh
docker build -t bookstore webserver

# Create Proxy
mkdir -p proxy
cp Dockerfile.proxy.service proxy/Dockerfile
cp proxy.sh proxy/proxy.sh
docker build -t bookstore_proxy proxy

# Create Authserver
mkdir -p auth
cp Dockerfile.auth.service auth/Dockerfile
cp auth.sh auth/auth.sh
docker build -t bookstore_auth auth

# Create Reserve service
mkdir -p reserve
cp Dockerfile.reserve.service reserve/Dockerfile
cp reserve.sh reserve/reserve.sh
docker build -t bookstore_reserve reserve

