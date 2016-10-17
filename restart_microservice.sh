#!/bin/bash

./clean_docker.sh
pushd build
./build_docker.sh
popd
./run_containers.sh
