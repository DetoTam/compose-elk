#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
else
    echo ".env file not found. Please ensure it exists and is properly configured."
    exit 1
fi

# Check if essential environment variables are set
if [ -z "$ES_CONFIG" ] || [ -z "$ES_DATA" ] || [ -z "$ES_LOGS" ] || [ -z "$KBN_CONFIG" ] || [ -z "$KBN_LOGS" ] || [ -z "$LS_CONFIG" ] || [ -z "$LS_LOGS" ] || [ -z "$LS_PIPELINE" ] || [ -z "$LS_DATA" ] || [ -z "$LS_PATTERNS" ]; then
    echo "One or more environment variables are not set. Please check your .env file."
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
    sudo curl -L https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed."
fi

# Setting up required directories
echo "Creating necessary directories..."
mkdir -p "$ES_CONFIG" "$ES_DATA" "$ES_LOGS" \
         "$KBN_CONFIG" "$KBN_LOGS" \
         "$LS_CONFIG" "$LS_LOGS" "$LS_PIPELINE" "$LS_DATA" "$LS_PATTERNS"

# Create groups and users (if they do not exist)
echo "Creating necessary users and groups..."
if ! getent group elasticsearch >/dev/null; then
    groupadd --system elasticsearch
fi
if ! getent group kibana >/dev/null; then
    groupadd --system kibana
fi
if ! getent group logstash >/dev/null; then
    groupadd --system logstash
fi

if ! id "elasticsearch" &>/dev/null; then
    useradd --system --gid elasticsearch --create-home --home-dir /usr/share/elasticsearch elasticsearch
fi
if ! id "kibana" &>/dev/null; then
    useradd --system --gid kibana --create-home --home-dir /usr/share/kibana kibana
fi
if ! id "logstash" &>/dev/null; then
    useradd --system --gid logstash --create-home --home-dir /usr/share/logstash logstash
fi

# Setting correct permissions for the directories
echo "Setting permissions..."
chown -R elasticsearch:elasticsearch "$ES_CONFIG" "$ES_DATA" "$ES_LOGS"
chmod -R 770 "$ES_CONFIG" "$ES_DATA" "$ES_LOGS"

chown -R kibana:kibana "$KBN_CONFIG" "$KBN_LOGS"
chmod -R 770 "$KBN_CONFIG" "$KBN_LOGS"

chown -R logstash:logstash "$LS_CONFIG" "$LS_LOGS" "$LS_PIPELINE" "$LS_DATA" "$LS_PATTERNS"
chmod -R 770 "$LS_CONFIG" "$LS_LOGS" "$LS_PIPELINE" "$LS_DATA" "$LS_PATTERNS"

echo "All requirements are fulfilled! You can now run 'docker-compose up -d'"
