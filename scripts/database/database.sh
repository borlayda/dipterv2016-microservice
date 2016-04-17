#!/bin/bash

mysql -u root -e "CREATE DATABASE authenticate;"
mysql -u root -e "CREATE DATABASE bookstore;"
mysql -u root authenticate < /tmp/auth_init.sql
mysql -u root bookstore < /tmp/bookstore_init.sql

service mysql start

while true
do 
    sleep 20
done
