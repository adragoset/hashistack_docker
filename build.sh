#!/bin/sh

docker build -t devopsintralox/nomad:v0.9.1 --network=cluster_network -f nomad/x64/Dockerfile .
docker push devopsintralox/nomad:v0.9.1
docker build -t devopsintralox/nomad:offline-v0.9.1 --network=cluster_network -f nomad/x64/offline/Dockerfile .
docker push devopsintralox/nomad:offline-v0.9.1