#!/bin/bash

service mysql start

mysql -u root -proot -e "CREATE DATABASE authenticate;"
mysql -u root -proot -e "CREATE DATABASE bookstore;"
mysql -u root -proot authenticate < /tmp/auth_init.sql
mysql -u root -proot bookstore < /tmp/bookstore_init.sql

while true
do 
    sleep 20
done
