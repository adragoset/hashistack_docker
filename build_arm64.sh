#!/bin/sh

docker build -t devopsintralox/nomad:v0.9.1-arm64v8 --network=cluster_network -f nomad/arm/64v8/Dockerfile .
docker push devopsintralox/nomad:v0.9.1-arm64v8
docker build -t devopsintralox/nomad:offline-v0.9.1-arm64v8 --network=cluster_network -f nomad/arm/64v8/offline/Dockerfile .
docker push devopsintralox/nomad:offline-v0.9.1-arm64v8
docker build -t devopsintralox/consul:v1.4.4-arm64v8 --network=cluster_network -f consul/arm/64v8/Dockerfile .
docker push devopsintralox/consul:v1.4.4-arm64v8
