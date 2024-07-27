#!/bin/bash

docker build -t dns .
docker stop dns
docker rm dns
docker run -d --name dns -p 53:53 -p 53:53/udp -v $PWD/logs:/dnsmasq/logs -v $PWD/config:/dnsmasq/config --restart=always dns