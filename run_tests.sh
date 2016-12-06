#!/bin/bash

PROXY_IP=$(docker inspect -f '{{ .NetworkSettings.Networks.bookstore.IPAddress }}' proxy)

echo "Proxy server for tests: ${PROXY_IP}"

test_auth(){
    echo "Testing authentication"
    python run_tests.py "${PROXY_IP}" "login.php"
}

test_order(){
    echo "Testing order"
    python run_tests.py "${PROXY_IP}" "order.php"
}

test_all(){
   test_auth
   test_order
}

# Waiting for service sync
sleep 120
test_all
