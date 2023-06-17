#!/bin/bash
# Deployment of Adobe Commerce 2.4.5 on Ubuntu 22.04 LTS

# Update the system
sudo apt update -y # || sudo apt upgrade -y

# Install a few prerequisite packages which let apt use packages over HTTPS
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Add the GPG key for the official Docker repository to the system
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository to APT sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package database with the Docker packages from the newly added repo
sudo apt update

# Make sure you are about to install from the Docker repo instead of the default Ubuntu repo
apt-cache policy docker-ce

# Install Docker
sudo apt install docker-ce

# Add your username to the docker group:
sudo usermod -aG docker ${USER}

# To apply the new group membership, log out of the server and back in, or type the following:
sudo su - ${USER}

# Rancher minimum installation command.
docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:latest

# Rancher installation command with custom hostname.

