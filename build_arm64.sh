#!/bin/sh

docker build -t devopsintralox/nomad:v0.9.0-arm64v8 --network=cluster_network -f nomad/arm/64v8/Dockerfile .
docker build -t devopsintralox/consul:v1.4.3-arm64v8 --network=cluster_network -f consul/arm/64v8/Dockerfile .

docker push devopsintralox/nomad:v0.9.0-arm64v8
docker push devopsintralox/consul:v1.4.3-arm64v8
