#!/usr/bin/env python

import requests
import sys

DATA_MATRIX = {
    "login.php": {
        "username" : "test",
        "password" : "testpassword"
    },
    "order.php": {
        "nameOfBook" : "Harry Potter and the Chamber of Secret",
        "numberOfBooks" : 1 
    }
}

r = requests.post('http://{ip}/{script}'.format(ip=sys.argv[1], script=sys.argv[2]),
    data = DATA_MATRIX[sys.argv[2]])
