#!/bin/bash

PROXY_IP=$(docker inspect -f '{{ .NetworkSettings.Networks.bookstore.IPAddress }}' proxy)

echo "Proxy server for tests: ${PROXY_IP}"

export HTTP_PROXY=
export http_proxy=

test_auth(){
    echo "Testing authentication"
    curl -X POST -H "Content-Type: application/x-www-form-urlencoded" --data "username=test&password=testpassword" "http://${PROXY_IP}/login.php"
}

test_order(){
    echo "Testing order"
    curl -X POST --data "nameOfBook=Harry Potter and the Chamber of Secret&numberOfBooks=1" "http://${PROXY_IP}/order.php"
}

test_all(){
   test_auth
   test_order
}

test_all
