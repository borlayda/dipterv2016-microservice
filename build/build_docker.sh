#!/bin/bash

services="database webserver proxy order auth"

for service in ${services}
do
    ./build_${service}.sh
done

echo "Microservices has been created!"
