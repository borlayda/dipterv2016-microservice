#!/bin/bash

PROXY_IP=$(docker inspect -f '{{ .NetworkSettings.Networks.bookstore.IPAddress }}' proxy)

test_auth(){
    echo "Testing authentication"
}

test_order(){
    echo "Testing order"
}

test_all(){
   test_auth
   test_order
}

test_all
