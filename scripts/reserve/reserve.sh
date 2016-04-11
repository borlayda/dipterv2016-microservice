#!/bin/bash

MYIP=$(ping -c 1 $(hostname) | awk '/PING/ {print $3}' | cut -d "(" -f2 | cut -d ")" -f1 )
echo $MYIP
consul agent -server -node reserve -data-dir /tmp/consul &
IP=$1
sleep 10
consul join $IP

while true
do 
    sleep 3
done
