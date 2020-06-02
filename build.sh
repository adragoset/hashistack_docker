#!/bin/sh

docker build -t devopsintralox/nomad:v0.10.4 --network=cluster_network -f nomad/x64/cpu/Dockerfile .
docker push devopsintralox/nomad:v0.10.4

docker build -t devopsintralox/nomad:v0.10.4-gpu --network=cluster_network -f nomad/x64/gpu/Dockerfile .
docker push devopsintralox/nomad:v0.10.4-gpu