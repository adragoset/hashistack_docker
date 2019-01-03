#!/bin/sh

docker build -t devopsintralox/nomad:arm_v0.8.6 --network=cluster_network -f nomad/64v8/Dockerfile .
docker build -t devopsintralox/consul:arm_v1.2.3 --network=cluster_network -f consul/64v8/Dockerfile .

docker push devopsintralox/nomad:arm_v0.8.6
docker push devopsintralox/consul:arm_v1.2.3