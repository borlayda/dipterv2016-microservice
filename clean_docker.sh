#!/bin/bash

services="database webserver proxy reserve auth"

for service in ${services}
do
    echo "Delete ${service} image"
    docker rmi bookstore_${service}
done

rm -rf services
rm -rf consul

