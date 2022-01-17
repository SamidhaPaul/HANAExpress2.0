#!/bin/bash

sudo apt update;
sudo apt install openssh-server;

ip address > IP.txt;

#install Docker package
sudo apt install docker.io

#sudo sh -c 'echo {"storage-driver": "overlay2"}' >> /etc/docker/daemon.json'

#sudo systemctl restart docker.service


sudo sh -c 'echo fs.file-max=20000000' >> /etc/sysctl.conf'
sudo sh -c 'echo fs.aio-max-nr=262144' >> /etc/sysctl.conf'
sudo sh -c 'echo vm.memory_failure_early_kill=1' >> /etc/sysctl.conf'
sudo sh -c 'echo vm.max_map_count=135217728' >> /etc/sysctl.conf'
sudo sh -c 'echo net.ipv4.ip_local_port_range=40000 60999' >> /etc/sysctl.conf'

sudo /sbin/sysctl -p

sudo sh -c 'echo cat $(IP.txt)  hxehost >> /etc/hosts'

sudo mkdir -p /data/HXE_DOCKER1
sudo chmod 757 /data/HXE_DOCKER1
cd /data/HXE_DOCKER1; touch settings.json;
sudo sh -c 'echo { "master_password" : "Welcome@1" }' >> settings.json'

sudo docker login 

 