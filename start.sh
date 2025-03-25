#!/bin/bash

# Checking Docker
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    sudo apt update && sudo apt install docker.io -y
else
    echo "Docker is already installed."
fi

# Checking Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed."
fi

echo "All requirements are fulfilled! You can now run 'docker-compose up -d'"
