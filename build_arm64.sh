#!/bin/sh

docker build -t devopsintralox/nomad:arm64v8_v0.8.6 --network=cluster_network -f nomad/arm/64v8/Dockerfile .
docker build -t devopsintralox/consul:arm64v8_v1.4.0 --network=cluster_network -f consul/arm/64v8/Dockerfile .

docker push devopsintralox/nomad:arm64v8_v0.8.6
docker push devopsintralox/consul:arm64v8_v1.4.0