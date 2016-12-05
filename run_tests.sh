#!/bin/bash

PROXY_IP=$(docker inspect -f '{{ .NetworkSettings.Networks.bookstore.IPAddress }}' proxy)

test_auth(){
    echo "Testing authentication"
    curl -X "POST" "${PROXY_IP}/login.php?username=test&password=testpassword"
}

test_order(){
    echo "Testing order"
    curl -X "POST" "${PROXY_IP}/order.php?nameOfBook=Harry Potter and the Chamber of Secret&numberOfBooks=1"
}

test_all(){
   test_auth
   test_order
}

test_all
