#!/bin/bash

services="database webserver proxy reserve auth"

for service in ${services}
do
    echo "Start ${service} service ..."
    docker run -d bookstore_${service}
done

echo "Microservices started

