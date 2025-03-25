#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
else
    echo ".env file not found. Please ensure it exists and is properly configured."
    exit 1
fi

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

# Setting up required directories
echo "Creating necessary directories..."
mkdir -p "$ES_CONFIG" "$ES_DATA" "$ES_LOGS" \
         "$KBN_CONFIG" "$KBN_LOGS" \
         "$LS_CONFIG" "$LS_LOGS" "$LS_PIPELINE" "$LS_DATA" "$LS_PATTERNS"

echo "Setting permissions..."
chmod -R 777 "$ES_CONFIG" "$ES_DATA" "$ES_LOGS" \
            "$KBN_CONFIG" "$KBN_LOGS" \
            "$LS_CONFIG" "$LS_LOGS" "$LS_PIPELINE" "$LS_DATA" "$LS_PATTERNS"

echo "All requirements are fulfilled! You can now run 'docker-compose up -d'"
