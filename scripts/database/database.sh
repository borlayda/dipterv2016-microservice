#!/bin/bash

service mysql start

mysql -u root -e "CREATE DATABASE authenticate;"
mysql -u root -e "CREATE DATABASE bookstore;"
mysql -u root authenticate < /tmp/auth_init.sql
mysql -u root bookstore < /tmp/bookstore_init.sql

while true
do 
    sleep 20
done
