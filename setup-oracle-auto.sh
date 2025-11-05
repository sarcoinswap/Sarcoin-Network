#!/bin/bash

# Sarcoin Network - Complete Oracle Cloud Deployment Script
# This script sets up a complete Sarcoin node on Oracle Cloud Always Free VM
# Ubuntu 22.04 LTS - 1 OCPU, 1GB RAM

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  🚀 SARCOIN NETWORK - ORACLE CLOUD SETUP 🚀          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Update system
echo "📦 [1/8] Updating system packages..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq

# Install Docker
echo "🐳 [2/8] Installing Docker..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -qq
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
echo "🐳 [3/8] Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install Docker Compose standalone
echo "🐳 [4/8] Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone repository
echo "📂 [5/8] Cloning Sarcoin Network repository..."
cd ~
if [ -d "Sarcoin-Network" ]; then
    echo "   Repository already exists, pulling latest..."
    cd Sarcoin-Network
    git pull
else
    git clone https://github.com/sarcoinswap/Sarcoin-Network.git
    cd Sarcoin-Network
fi

# Build Docker image
echo "🏗️  [6/8] Building Sarcoin Docker image (this may take 10-15 minutes)..."
sudo docker build -f Dockerfile.sarcoin -t sarcoin-node:latest .

# Configure firewall
echo "🔥 [7/8] Configuring firewall..."
sudo iptables -I INPUT -p tcp --dport 8545 -j ACCEPT  # HTTP RPC
sudo iptables -I INPUT -p tcp --dport 8546 -j ACCEPT  # WebSocket
sudo iptables -I INPUT -p tcp --dport 30303 -j ACCEPT # P2P
sudo iptables -I INPUT -p udp --dport 30303 -j ACCEPT # P2P UDP
sudo apt-get install -y iptables-persistent
sudo netfilter-persistent save

# Start node with Docker Compose
echo "🚀 [8/8] Starting Sarcoin node..."
sudo docker-compose -f docker-compose.oracle.yml up -d

# Wait for node to start
echo "⏳ Waiting for node to initialize (30 seconds)..."
sleep 30

# Check status
echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  ✅ DEPLOYMENT COMPLETE!                              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Get public IP
PUBLIC_IP=$(curl -s ifconfig.me)
echo "🌍 Public IP: $PUBLIC_IP"
echo ""

# Show node info
echo "📊 Node Status:"
sudo docker-compose -f docker-compose.oracle.yml ps
echo ""

echo "🔗 RPC Endpoints:"
echo "   HTTP:  http://$PUBLIC_IP:8545"
echo "   WS:    ws://$PUBLIC_IP:8546"
echo ""

echo "📝 Useful Commands:"
echo "   Check logs:      sudo docker-compose -f docker-compose.oracle.yml logs -f"
echo "   Stop node:       sudo docker-compose -f docker-compose.oracle.yml down"
echo "   Restart node:    sudo docker-compose -f docker-compose.oracle.yml restart"
echo "   Check status:    sudo docker-compose -f docker-compose.oracle.yml ps"
echo ""

echo "🧪 Test RPC:"
echo "   curl -X POST http://$PUBLIC_IP:8545 -H 'Content-Type: application/json' --data '{\"jsonrpc\":\"2.0\",\"method\":\"eth_chainId\",\"params\":[],\"id\":1}'"
echo ""

echo "📖 Next Steps:"
echo "   1. Test RPC endpoint from external machine"
echo "   2. Add this node's enode to bootnodes.go"
echo "   3. Deploy validator nodes"
echo "   4. Configure block explorer"
echo ""
