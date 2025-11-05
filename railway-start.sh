#!/bin/bash
# Railway startup wrapper for Sarcoin geth node
# This script helps Railway's health check by starting geth properly

set -e

echo "🚀 Starting Sarcoin Network Node..."
echo "📦 Data directory: /root/.sarcoin"
echo "🌐 Network ID: 3901"
echo "🔌 HTTP Port: ${PORT:-8545}"

# Check if PORT is set (Railway provides this)
if [ -z "$PORT" ]; then
    export PORT=8545
    echo "⚠️  PORT not set, defaulting to 8545"
fi

echo "✅ Starting geth on port $PORT..."

# Start geth with all configurations
exec geth \
    --datadir /root/.sarcoin \
    --networkid 3901 \
    --http \
    --http.addr 0.0.0.0 \
    --http.port $PORT \
    --http.api eth,net,web3,txpool,admin \
    --http.corsdomain '*' \
    --http.vhosts '*' \
    --ws \
    --ws.addr 0.0.0.0 \
    --ws.port 8546 \
    --ws.api eth,net,web3 \
    --ws.origins '*' \
    --port 30303 \
    --maxpeers 50 \
    --cache 256 \
    --verbosity 3 \
    --syncmode snap \
    --gcmode archive
