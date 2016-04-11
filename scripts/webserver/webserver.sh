#!/bin/bash

MYIP=$(ping -c 1 $(hostname) | awk '/PING/ {print $3}' | cut -d "(" -f2 | cut -d ")" -f1 )
echo $MYIP
consul agent -server -node webserver -data-dir /tmp/consul &
IP=$1
echo "$IP"
sleep 10
consul join $IP

service apache2 restart

while true
do 
    sleep 3
done
