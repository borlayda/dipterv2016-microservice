#!/bin/bash

cd /order/java 
mvn install

export CATALINA_BASE=/usr/share/tomcat
export CATALINA_HOME=/usr/share/java/tomcat
export NAME=tomcat
tomcat start

while true
do 
    sleep 3
done
