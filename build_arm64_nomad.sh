#!/bin/sh

docker build -t devopsintralox/nomad:v0.10.4-arm64v8 --network=cluster_network -f nomad/arm/64v8/Dockerfile .
docker push devopsintralox/nomad:v0.10.4-arm64v8