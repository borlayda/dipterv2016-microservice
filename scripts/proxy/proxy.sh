#!/bin/bash

consul agent -server -bootstrap -node "haproxy" -data-dir /tmp/consul &
sleep 10

while true
do 
    sleep 3
done
