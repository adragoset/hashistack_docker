#!/bin/sh

docker build -t devopsintralox/nomad:v1.1.3 --network=cluster_network -f nomad/x64/cpu/Dockerfile .
docker push devopsintralox/nomad:v1.1.3
