# Sarcoin SRS - Cloud Deployment Guide

## 🌐 FREE Cloud Deployment Options

### Option 1: Oracle Cloud Always Free Tier ⭐ RECOMMENDED

**Specs:**

- 2x VM.Standard.E2.1.Micro (1 OCPU, 1 GB RAM each)
- 200 GB Block Storage
- **PERMANENTLY FREE**

**Setup:**

1. Create Oracle Cloud account at [cloud.oracle.com](https://cloud.oracle.com)

2. Create 2 VMs (Ubuntu 22.04):

```bash
# VM 1: RPC Node
# VM 2: Validator Node
```

3. Install Docker on each VM:

```bash
sudo apt update
sudo apt install -y docker.io docker-compose git
sudo usermod -aG docker $USER
```

4. Clone and setup:

```bash
git clone <your-sarcoin-repo>
cd sarcoin-network
```

5. Start services:

```bash
# On RPC VM:
docker-compose -f docker-compose.oracle.yml up -d rpc

# On Validator VM:
docker-compose -f docker-compose.oracle.yml up -d validator
```

---

### Option 2: Railway.app

**Specs:**

- 500 hours/month free (≈20 days)
- 512 MB RAM
- 1 GB storage

**Setup:**

1. Sign up at [railway.app](https://railway.app)

2. Click "New Project" → "Deploy from GitHub"

3. Connect your Sarcoin repository

4. Railway will auto-detect Dockerfile

5. Set environment variables:

```
NETWORK=testnet
CHAIN_ID=3901
```

**Limitations:** Monthly usage cap, need to restart monthly

---

### Option 3: Render.com

**Specs:**

- 750 hours/month free
- 512 MB RAM
- Spin down after 15 min inactivity

**Setup:**

1. Sign up at [render.com](https://render.com)

2. New Web Service → Connect repository

3. Configure:

   - **Name:** sarcoin-testnet-rpc
   - **Docker Command:** (auto-detected)
   - **Environment:** Docker

4. Set environment variables

**Limitations:** Spins down when inactive (30s wake-up time)

---

### Option 4: Google Cloud Free Tier

**Specs:**

- e2-micro instance (0.25-1 vCPU, 1 GB RAM)
- 30 GB storage
- Always free in specific regions (us-west1, us-central1, us-east1)

**Setup:**

1. Create account at [cloud.google.com](https://cloud.google.com)

2. Create VM instance:

```bash
gcloud compute instances create sarcoin-rpc \
  --machine-type=e2-micro \
  --zone=us-west1-b \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud
```

3. SSH and install Docker:

```bash
gcloud compute ssh sarcoin-rpc
# Then install Docker as above
```

---

## 🚀 Quick Deploy Scripts

### Oracle Cloud VM Setup Script

```bash
#!/bin/bash
# Save as: setup-oracle-vm.sh

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y docker.io docker-compose git build-essential

# Add user to docker group
sudo usermod -aG docker $USER

# Clone repository
git clone https://github.com/YOUR-USERNAME/sarcoin-network.git
cd sarcoin-network

# Initialize genesis
./build/bin/geth init --datadir /data/sarcoin genesis-testnet.json

# Start node
docker-compose -f docker-compose.oracle.yml up -d

echo "✓ Sarcoin node deployed!"
echo "RPC: http://$(curl -s ifconfig.me):8545"
```

### Health Check Script

```bash
#!/bin/bash
# Save as: check-node.sh

RPC_URL="http://localhost:8545"

echo "Checking Sarcoin node..."
echo ""

# Check if node is running
if curl -s -X POST $RPC_URL \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
  | grep -q "0xf3d"; then
    echo "✓ Node is running (Chain ID: 3901)"
else
    echo "✗ Node is not responding"
    exit 1
fi

# Get block number
BLOCK=$(curl -s -X POST $RPC_URL \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  | jq -r '.result')

echo "✓ Latest block: $((16#${BLOCK:2}))"

# Get peer count
PEERS=$(curl -s -X POST $RPC_URL \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' \
  | jq -r '.result')

echo "✓ Connected peers: $((16#${PEERS:2}))"
```

---

## 📊 Resource Requirements

| Node Type        | Minimum RAM | Storage | CPU     |
| ---------------- | ----------- | ------- | ------- |
| **RPC Node**     | 2 GB        | 50 GB   | 1 core  |
| **Validator**    | 1 GB        | 30 GB   | 1 core  |
| **Archive Node** | 4 GB        | 500 GB  | 2 cores |

---

## 🔒 Security Best Practices

1. **Firewall Configuration:**

```bash
# Allow only necessary ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8545/tcp  # HTTP RPC
sudo ufw allow 30303/tcp # P2P
sudo ufw allow 30303/udp # P2P
sudo ufw enable
```

2. **Use systemd service:**

```ini
[Unit]
Description=Sarcoin Node
After=network.target

[Service]
Type=simple
User=sarcoin
ExecStart=/usr/local/bin/geth \
  --datadir /data/sarcoin \
  --networkid 3901 \
  --http \
  --http.addr 0.0.0.0 \
  --http.api eth,net,web3
Restart=always

[Install]
WantedBy=multi-user.target
```

3. **Rate limiting with nginx:**

```nginx
limit_req_zone $binary_remote_addr zone=rpc:10m rate=10r/s;

server {
    listen 80;
    server_name rpc.sarcoin.network;

    location / {
        limit_req zone=rpc burst=20;
        proxy_pass http://127.0.0.1:8545;
    }
}
```

---

## 💰 Cost Comparison

| Provider         | Free Tier   | Monthly Cost (Paid) |
| ---------------- | ----------- | ------------------- |
| **Oracle Cloud** | Permanent   | $0 (always free)    |
| **Railway.app**  | 500h/month  | $5-20               |
| **Render.com**   | 750h/month  | $7                  |
| **Google Cloud** | Permanent\* | $5-15               |
| **AWS**          | 12 months   | $10-30              |

\*Permanent in eligible regions

---

## 🎯 Recommended Setup for Testnet

**Free Multi-Node Configuration:**

1. **Oracle Cloud VM 1** → RPC Node (public)
2. **Oracle Cloud VM 2** → Validator 1
3. **Railway** → Validator 2 (backup)
4. **Local Machine** → Validator 3 (development)

**Total Cost: $0/month** ✅

---

## 📝 Environment Variables

```bash
# .env file for Docker deployments
NETWORK=testnet
CHAIN_ID=3901
HTTP_PORT=8545
WS_PORT=8546
P2P_PORT=30303
VALIDATOR_ADDRESS=0x538C13ad0d2B4445a3ED9dE25bA2629a58612F20
MINER_ETHERBASE=0x538C13ad0d2B4445a3ED9dE25bA2629a58612F20
VERBOSITY=3
CACHE_SIZE=1024
MAX_PEERS=50
```

---

## 🔧 Monitoring

### Prometheus + Grafana (Optional)

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=sarcoin2025
```

---

## 🆘 Troubleshooting

### Node won't sync

```bash
# Check peers
geth attach http://localhost:8545 --exec "admin.peers"

# Add bootnode manually
geth attach --exec "admin.addPeer('enode://...')"
```

### Out of memory

```bash
# Reduce cache
--cache 512

# Enable light sync
--syncmode light
```

### High disk usage

```bash
# Enable pruning
--gcmode full
--cache.gc 25
```

---

**Next Steps:**

1. Choose cloud provider
2. Deploy RPC node
3. Deploy 2+ validators
4. Connect nodes
5. Start producing blocks! 🎉
