#!/bin/bash

MYIP=$(ping -c 1 $(hostname) | awk '/PING/ {print $3}' | cut -d "(" -f2 | cut -d ")" -f1 )
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/my.cnf


service mysql start

consul agent -server -node database -data-dir /tmp/consul &
IP=$1
sleep 10
consul join $IP

while true
do 
    sleep 20
done
