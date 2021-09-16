#!/bin/sh

docker build -t devopsintralox/consul:v1.10.2-arm64v8 --network=cluster_network -f consul/arm/64v8/Dockerfile .
docker push devopsintralox/consul:v1.10.2-arm64v8
