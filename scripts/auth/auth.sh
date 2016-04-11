#!/bin/bash

name=${1-invalidname}
password=${2-invalidpassword}

auth() {
    name=${1}
    passwd=${2}
    mysql -uroot -p root auth ${DATABASE_IP}
}

auth ${name} ${password}
