#!/bin/sh

docker build -t devopsintralox/nomad:v1.1.3-gpu --network=cluster_network -f nomad/x64/gpu/Dockerfile .
docker push devopsintralox/nomad:v1.1.3-gpu
