# 🚀 SARCOIN NETWORK - Guida Deployment Completa

## 📋 Prerequisiti Completati ✅

- ✅ Binary compilato (154 MB)
- ✅ Genesis testnet (Chain ID 3901) e mainnet (Chain ID 3900)
- ✅ 3 validator accounts generati
- ✅ Docker configuration pronta
- ✅ Repository Git inizializzato

---

## OPZIONE 1: Oracle Cloud Always Free (RACCOMANDATO) 🥇

### Vantaggi

- ✅ **SEMPRE GRATIS** (nessuna scadenza)
- ✅ **2 VM permanenti** (1 OCPU, 1GB RAM ciascuna)
- ✅ **Nessuna carta di credito** richiesta inizialmente
- ✅ **10TB bandwidth/mese**
- ✅ **IP pubblico statico**

### Passo 1: Crea Account Oracle Cloud

1. **Vai su**: https://www.oracle.com/cloud/free/
2. **Click**: "Start for free"
3. **Compila**:
   - Email
   - Paese: Italia o altro paese EU
   - Nome/Cognome
4. **Verifica email** e completa registrazione
5. **IMPORTANTE**: Scegli "Always Free Account" (NON quello con $300 credits)
6. **Accedi** alla console: https://cloud.oracle.com

### Passo 2: Crea Prima VM (RPC Node)

1. **Nella console Oracle Cloud**:

   - Menu ☰ → "Compute" → "Instances"
   - Click "Create Instance"

2. **Configura VM**:

   - **Name**: `sarcoin-rpc-node-1`
   - **Placement**: Lascia default
   - **Image**: ✅ Ubuntu 22.04 Minimal (Always Free eligible)
   - **Shape**: ✅ VM.Standard.E2.1.Micro (Always Free)
     - 1 OCPU
     - 1 GB RAM
     - Se non vedi questa opzione, click "Change Shape" → "Specialty and previous generation" → seleziona E2.1.Micro
   - **Networking**: Lascia default (VCN creata automaticamente)
   - **SSH Keys**:
     - ✅ "Generate SSH key pair"
     - Download **private key** (es: `ssh-key-2025-11-04.key`)
     - ⚠️ **SALVA QUESTO FILE** - serve per connetterti!
   - **Boot Volume**: 50 GB (Always Free include fino a 200GB totali)

3. **Click**: "Create"
4. **Attendi**: 2-3 minuti per provisioning
5. **Annota IP pubblico**: Vedrai l'IP nella pagina Instance Details

### Passo 3: Configura Firewall Oracle Cloud

1. **Nella stessa pagina della VM**:
   - Scroll down → "Primary VNIC" section
   - Click sul nome della Subnet (es: `subnet-xxxxx`)
2. **Nella pagina Subnet**:
   - "Security Lists" → Click sul Security List (es: `Default Security List`)
3. **Aggiungi Ingress Rules**:

   - Click "Add Ingress Rules"

   **Regola 1 - HTTP RPC:**

   - Source CIDR: `0.0.0.0/0`
   - IP Protocol: TCP
   - Destination Port Range: `8545`
   - Description: `Sarcoin RPC HTTP`
   - Click "Add Ingress Rules"

   **Regola 2 - WebSocket:**

   - Source CIDR: `0.0.0.0/0`
   - IP Protocol: TCP
   - Destination Port Range: `8546`
   - Description: `Sarcoin RPC WebSocket`
   - Click "Add Ingress Rules"

   **Regola 3 - P2P TCP:**

   - Source CIDR: `0.0.0.0/0`
   - IP Protocol: TCP
   - Destination Port Range: `30303`
   - Description: `Sarcoin P2P`
   - Click "Add Ingress Rules"

   **Regola 4 - P2P UDP:**

   - Source CIDR: `0.0.0.0/0`
   - IP Protocol: UDP
   - Destination Port Range: `30303`
   - Description: `Sarcoin P2P UDP`
   - Click "Add Ingress Rules"

### Passo 4: Connettiti alla VM

**Su Windows (PowerShell):**

```powershell
# Imposta permessi chiave SSH (solo prima volta)
icacls "C:\path\to\ssh-key-2025-11-04.key" /inheritance:r
icacls "C:\path\to\ssh-key-2025-11-04.key" /grant:r "$env:USERNAME:(R)"

# Connettiti (sostituisci YOUR_PUBLIC_IP con l'IP della VM)
ssh -i "C:\path\to\ssh-key-2025-11-04.key" ubuntu@YOUR_PUBLIC_IP
```

**Prima connessione:**

- Rispondere "yes" quando chiede di aggiungere l'host

### Passo 5: Deploy Automatico con Script

Una volta connesso via SSH alla VM:

```bash
# 1. Crea file setup script
cat > setup-sarcoin.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Sarcoin Network - Oracle Cloud Setup"
echo "========================================"

# Update system
echo "📦 Updating system..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq

# Install Docker
echo "🐳 Installing Docker..."
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -qq
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Install git
sudo apt-get install -y git

# Clone repository
echo "📂 Cloning Sarcoin repository..."
cd ~
git clone https://github.com/sarcoinswap/Sarcoin-Network.git
cd Sarcoin-Network

# Build Docker image
echo "🏗️  Building Docker image (10-15 min)..."
sudo docker build -f Dockerfile.sarcoin -t sarcoin-node:latest .

# Initialize genesis
echo "📜 Initializing genesis..."
sudo docker run --rm -v sarcoin-data:/root/.sarcoin sarcoin-node:latest init /genesis-testnet.json

# Configure firewall
echo "🔥 Configuring firewall..."
sudo iptables -I INPUT -p tcp --dport 8545 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 8546 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 30303 -j ACCEPT
sudo iptables -I INPUT -p udp --dport 30303 -j ACCEPT
sudo apt-get install -y iptables-persistent
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo netfilter-persistent save

# Start node
echo "🚀 Starting Sarcoin node..."
sudo docker run -d \
  --name sarcoin-rpc \
  --restart unless-stopped \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  -p 30303:30303/udp \
  -v sarcoin-data:/root/.sarcoin \
  sarcoin-node:latest \
  --datadir /root/.sarcoin \
  --networkid 3901 \
  --http --http.addr 0.0.0.0 --http.port 8545 \
  --http.api eth,net,web3,txpool \
  --http.corsdomain "*" \
  --http.vhosts "*" \
  --ws --ws.addr 0.0.0.0 --ws.port 8546 \
  --ws.api eth,net,web3 \
  --ws.origins "*" \
  --port 30303 \
  --maxpeers 50 \
  --cache 512 \
  --verbosity 3

# Wait for startup
echo "⏳ Waiting for node to start (30 seconds)..."
sleep 30

# Get public IP
PUBLIC_IP=$(curl -s ifconfig.me)

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  ✅ DEPLOYMENT COMPLETE!                              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "🌍 Public IP: $PUBLIC_IP"
echo "🔗 RPC Endpoint: http://$PUBLIC_IP:8545"
echo "🔗 WebSocket: ws://$PUBLIC_IP:8546"
echo ""
echo "📝 Useful Commands:"
echo "   Check logs:    sudo docker logs -f sarcoin-rpc"
echo "   Stop node:     sudo docker stop sarcoin-rpc"
echo "   Start node:    sudo docker start sarcoin-rpc"
echo "   Restart node:  sudo docker restart sarcoin-rpc"
echo ""
echo "🧪 Test RPC:"
echo "   curl -X POST http://$PUBLIC_IP:8545 -H 'Content-Type: application/json' --data '{\"jsonrpc\":\"2.0\",\"method\":\"eth_chainId\",\"params\":[],\"id\":1}'"
echo ""
EOF

# 2. Rendi eseguibile
chmod +x setup-sarcoin.sh

# 3. Il repository è già configurato correttamente
# (usa https://github.com/sarcoinswap/Sarcoin-Network.git)

# 4. Esegui lo script
./setup-sarcoin.sh
```

### Passo 6: Verifica Deployment

**Dalla VM Oracle Cloud:**

```bash
# Check container status
sudo docker ps

# Check logs (ultimi 50 righe)
sudo docker logs --tail 50 sarcoin-rpc

# Test RPC locale
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
# Output atteso: {"jsonrpc":"2.0","id":1,"result":"0xf3d"}  (0xf3d = 3901)
```

**Dal tuo PC Windows:**

```powershell
# Sostituisci YOUR_PUBLIC_IP con l'IP della VM
$IP = "YOUR_PUBLIC_IP"

# Test chain ID
curl -X POST http://${IP}:8545 -H "Content-Type: application/json" --data '{\"jsonrpc\":\"2.0\",\"method\":\"eth_chainId\",\"params\":[],\"id\":1}'

# Test block number
curl -X POST http://${IP}:8545 -H "Content-Type: application/json" --data '{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1}'

# Test client version
curl -X POST http://${IP}:8545 -H "Content-Type: application/json" --data '{\"jsonrpc\":\"2.0\",\"method\":\"web3_clientVersion\",\"params\":[],\"id\":1}'
```

### Passo 7: Crea Seconda VM (Validator Node)

**Ripeti Passo 2-6 con questi cambiamenti:**

1. **Nome VM**: `sarcoin-validator-1`
2. **Docker command** (nel setup-sarcoin.sh):

```bash
# Invece del comando docker run precedente, usa questo:
sudo docker run -d \
  --name sarcoin-validator \
  --restart unless-stopped \
  -p 30303:30303 \
  -p 30303:30303/udp \
  -v sarcoin-data:/root/.sarcoin \
  -v ~/sarcoin-network/validators/validator1:/keystore \
  sarcoin-node:latest \
  --datadir /root/.sarcoin \
  --networkid 3901 \
  --port 30303 \
  --mine \
  --miner.etherbase 0x538C13ad0d2B4445a3ED9dE25bA2629a58612F20 \
  --unlock 0x538C13ad0d2B4445a3ED9dE25bA2629a58612F20 \
  --password /keystore/password.txt \
  --bootnodes "enode://YOUR_RPC_NODE_ENODE@YOUR_RPC_NODE_IP:30303" \
  --maxpeers 50 \
  --cache 512 \
  --verbosity 3
```

**Per ottenere l'enode del RPC node:**

```bash
# Sulla prima VM (RPC node)
sudo docker exec sarcoin-rpc geth attach --exec "admin.nodeInfo.enode" /root/.sarcoin/geth.ipc
```

---

## OPZIONE 2: Railway.app 🚂

### Vantaggi

- ✅ 500 ore/mese gratis
- ✅ Deployment Git automatico
- ✅ Interfaccia semplice

### Setup

1. **Vai su**: https://railway.app
2. **Registrati** con GitHub
3. **New Project** → "Deploy from GitHub repo"
4. **Seleziona**: `sarcoin-network` repository
5. **Settings**:
   - Service Name: `sarcoin-rpc`
   - Build: Dockerfile
   - Dockerfile Path: `Dockerfile.sarcoin`
6. **Variables**:
   ```
   NETWORK_ID=3901
   PORT=8545
   ```
7. **Deploy**: Automatico dopo commit

### Costi

- **Gratis**: Primi 500h/mese (~20 giorni)
- **Dopo**: $0.000463/GB-s ($3-5/mese per 1GB RAM continuous)

---

## OPZIONE 3: Render.com 🎨

### Vantaggi

- ✅ 750 ore/mese gratis
- ✅ Regione Europa (Frankfurt)
- ✅ Persistent disk incluso

### Setup

1. **Vai su**: https://render.com
2. **Registrati** con GitHub
3. **New** → "Web Service"
4. **Connect** repo: `sarcoin-network`
5. **Config**:
   - Name: `sarcoin-rpc`
   - Environment: Docker
   - Dockerfile Path: `./Dockerfile.sarcoin`
   - Instance Type: Free
   - Region: Frankfurt
6. **Advanced**:
   - Add Disk:
     - Name: `sarcoin-data`
     - Mount Path: `/root/.sarcoin`
     - Size: 10 GB
7. **Deploy**

### Limitazioni Free Tier

- 750h/mese
- Sospensione dopo 15 min inattività
- Riavvio automatico su richiesta

---

## OPZIONE 4: Google Cloud (e2-micro) ☁️

### Vantaggi

- ✅ $300 crediti gratis (90 giorni)
- ✅ e2-micro always free dopo crediti
- ✅ Performance migliore

### Setup

1. **Vai su**: https://console.cloud.google.com
2. **Attiva**: $300 free credits
3. **Compute Engine** → "VM instances"
4. **Create Instance**:
   - Name: `sarcoin-rpc`
   - Region: europe-west1 (Belgium)
   - Machine type: e2-micro (0.25-2 vCPU, 1 GB)
   - Boot disk: Ubuntu 22.04 LTS, 30 GB
   - Firewall: Allow HTTP, HTTPS
5. **SSH** → Follow same steps as Oracle Cloud

### Firewall Rules

```bash
gcloud compute firewall-rules create sarcoin-rpc \
  --allow tcp:8545,tcp:8546,tcp:30303,udp:30303 \
  --source-ranges 0.0.0.0/0 \
  --target-tags sarcoin-node
```

---

## 🧪 Testing Finale

### Test RPC Endpoint (da qualsiasi PC)

```bash
# Chain ID (deve essere 0xf3d = 3901)
curl -X POST http://YOUR_PUBLIC_IP:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'

# Block number
curl -X POST http://YOUR_PUBLIC_IP:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Client version
curl -X POST http://YOUR_PUBLIC_IP:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}'

# Syncing status
curl -X POST http://YOUR_PUBLIC_IP:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```

### Test con MetaMask

1. **Apri MetaMask**
2. **Network** → "Add Network" → "Add a network manually"
3. **Compila**:
   - Network Name: `Sarcoin Testnet`
   - RPC URL: `http://YOUR_PUBLIC_IP:8545`
   - Chain ID: `3901`
   - Currency Symbol: `tSRS`
   - Block Explorer: (lascia vuoto per ora)
4. **Save**
5. **Verifica**: Dovresti vedere "Sarcoin Testnet" selezionabile

---

## 📊 Monitoring

### Check Node Health

```bash
# Container status
sudo docker ps

# Logs real-time
sudo docker logs -f sarcoin-rpc

# Disk usage
df -h

# Memory usage
free -h

# Network stats
sudo docker stats sarcoin-rpc
```

### Prometheus + Grafana (Opzionale)

Per monitoring avanzato, aggiungi al docker-compose:

```yaml
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

## 🔐 Security Best Practices

1. **Firewall**: Apri SOLO porte necessarie (8545, 8546, 30303)
2. **SSH**: Usa chiavi SSH, disabilita password login
3. **Updates**: `sudo apt update && sudo apt upgrade` settimanale
4. **Backup**: Backup periodico di `/root/.sarcoin/keystore`
5. **Monitoring**: Setup alerting per downtime

---

## 🆘 Troubleshooting

### Node non si avvia

```bash
# Check logs
sudo docker logs sarcoin-rpc

# Check disk space
df -h

# Restart container
sudo docker restart sarcoin-rpc

# Recreate container
sudo docker stop sarcoin-rpc
sudo docker rm sarcoin-rpc
# Re-run docker run command
```

### RPC non risponde

```bash
# Check iptables
sudo iptables -L -n

# Check container ports
sudo docker port sarcoin-rpc

# Test interno
curl http://localhost:8545

# Check Oracle Cloud Security List
# (Web console → VCN → Security Lists)
```

### Out of Memory

```bash
# Check memory
free -h

# Reduce cache size (edit docker run command)
--cache 256  # instead of 512

# Enable swap (Oracle Cloud)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 📚 Prossimi Passi

Una volta deployment completato:

1. ✅ **Aggiungi Bootnodes**: Update `params/bootnodes.go` con enodes pubblici
2. ✅ **Deploy Validators**: Setup 3+ validator nodes
3. ✅ **Block Explorer**: Deploy Blockscout
4. ✅ **Faucet**: Web interface per distribuzione tSRS
5. ✅ **Monitoring**: Setup Grafana dashboards
6. ✅ **Documentation**: Public RPC endpoint docs

---

## 📞 Support

- **Repo**: https://github.com/sarcoinswap/Sarcoin-Network
- **Docs**: README.md, SETUP.md
- **Issues**: GitHub Issues

---

**DEPLOYMENT SUMMARY:**

| Platform         | Cost             | RAM    | Deployment Time | Best For       |
| ---------------- | ---------------- | ------ | --------------- | -------------- |
| **Oracle Cloud** | **FREE forever** | 1GB x2 | 15 min          | **Production** |
| Railway          | $0-5/mo          | 1GB    | 5 min           | Testing        |
| Render           | FREE 750h        | 512MB  | 5 min           | Testing        |
| GCP e2-micro     | $7/mo            | 1GB    | 15 min          | Production     |

**RACCOMANDAZIONE: Oracle Cloud Always Free (2 VM permanenti)**
