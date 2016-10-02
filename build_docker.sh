#!/bin/bash

services="database webserver proxy order auth"

echo "Get Consul script from Internet"
wget https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_386.zip && unzip consul_0.7.0_linux_386.zip
echo "Get consul-template script from Internet"
wget https://releases.hashicorp.com/consul-template/0.16.0/consul-template_0.16.0_darwin_amd64.zip && unzip consul-template_0.16.0_darwin_amd64.zip

for service in ${services}
do
    ./build_${service}.sh
done

echo "Microservices has been created!"

