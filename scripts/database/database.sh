#!/bin/bash

service mysql start

mysql -u root -proot -e "CREATE USER 'store'@'%' IDENTIFIED BY 'store';"
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'store'@'%';"
mysql -u root -proot -e "CREATE USER 'store'@'localhost' IDENTIFIED BY 'store';"
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'store'@'localhost';"
mysql -u root -proot -e "CREATE DATABASE authenticate;"
mysql -u root -proot -e "CREATE DATABASE bookstore;"
mysql -u root -proot authenticate < /tmp/auth_init.sql
mysql -u root -proot bookstore < /tmp/bookstore_init.sql

while true
do
    sleep 20
done
