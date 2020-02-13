#!/bin/sh

docker build -t devopsintralox/nomad:v0.10.3 --network=cluster_network -f nomad/x64/Dockerfile .
docker push devopsintralox/nomad:v0.10.3