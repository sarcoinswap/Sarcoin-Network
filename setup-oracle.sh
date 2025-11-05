#!/bin/bash
# Sarcoin SRS - Oracle Cloud VM Setup Script
# Run this on a fresh Ubuntu 22.04 VM

set -e

echo "=== Sarcoin Network - Oracle Cloud Setup ==="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "Please don't run as root. Run as ubuntu user."
    exit 1
fi

# Update system
echo "[1/6] Updating system..."
sudo apt update
sudo apt upgrade -y

# Install dependencies
echo "[2/6] Installing dependencies..."
sudo apt install -y \
    docker.io \
    docker-compose \
    git \
    curl \
    jq \
    ufw

# Add user to docker group
echo "[3/6] Configuring Docker..."
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

# Configure firewall
echo "[4/6] Configuring firewall..."
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8545/tcp  # HTTP RPC
sudo ufw allow 8546/tcp  # WebSocket
sudo ufw allow 30303/tcp # P2P
sudo ufw allow 30303/udp # P2P
sudo ufw --force enable

# Clone repository
echo "[5/6] Cloning Sarcoin repository..."
if [ -d "sarcoin-network" ]; then
    echo "Directory exists, pulling latest..."
    cd sarcoin-network
    git pull
else
    git clone https://github.com/YOUR-USERNAME/sarcoin-network.git
    cd sarcoin-network
fi

# Initialize genesis
echo "[6/6] Initializing genesis..."
if [ ! -d "testnet-data/geth/chaindata" ]; then
    ./build/bin/geth init --datadir ./testnet-data genesis-testnet.json
    echo "✓ Genesis initialized"
else
    echo "✓ Genesis already initialized"
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Next steps:"
echo "1. Log out and log back in (for Docker group)"
echo "2. Set validator address:"
echo "   export VALIDATOR_ADDRESS=0x538C13ad0d2B4445a3ED9dE25bA2629a58612F20"
echo "3. Start node:"
echo "   docker-compose -f docker-compose.oracle.yml up -d sarcoin-rpc"
echo ""
echo "Or for validator node:"
echo "   docker-compose -f docker-compose.oracle.yml up -d sarcoin-validator"
echo ""
echo "Check logs:"
echo "   docker logs -f sarcoin-rpc"
echo ""
echo "Your public IP:"
curl -s ifconfig.me
echo ""
echo ""
echo "RPC will be available at: http://$(curl -s ifconfig.me):8545"
echo ""
