# 🧪 GUIDA TEST 3 PIATTAFORME CLOUD

## Sommario Test

Testiamo Sarcoin Network su 3 piattaforme cloud gratuite:

1. **Railway.app** - 500h/mese gratis, deploy automatico da GitHub
2. **Render.com** - 750h/mese gratis, Europa (Frankfurt)
3. **Google Cloud Run** - Pay-as-you-go, sempre gratis sotto soglia

---

## TEST 1: Railway.app 🚂

### Setup (5 minuti)

1. **Vai su**: https://railway.app
2. **Sign up** con GitHub
3. **New Project** → "Deploy from GitHub repo"
4. **Select repo**: `sarcoinswap/Sarcoin-Network`
5. **Configure**:
   - Service Name: `sarcoin-testnet`
   - Start Command: (Railway auto-detect)

### Configurazione Avanzata

1. **Settings** → **Environment Variables**:
   ```
   NETWORK_ID=3901
   HTTP_PORT=8545
   WS_PORT=8546
   ```

2. **Settings** → **Service**:
   - Region: `us-west` (più veloce per test)
   - Instance: Hobby (512MB RAM)

3. **Networking**:
   - Generate Domain → Ottieni URL pubblico
   - Esempio: `sarcoin-testnet.railway.app`

### Deploy

```bash
# Railway deployment automatico da GitHub
# Ogni push su main → auto-deploy
```

### Test

```bash
# Test Chain ID
curl -X POST https://sarcoin-testnet.railway.app:8545 \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'

# Output atteso: {"jsonrpc":"2.0","id":1,"result":"0xf3d"}
```

### Vantaggi
- ✅ Deploy in 2 minuti
- ✅ Auto-deploy da GitHub
- ✅ 500h/mese gratis
- ✅ Facile scalabilità

### Svantaggi
- ⚠️ Sleep dopo 15 min inattività (Hobby plan)
- ⚠️ Limitato a 500h/mese
- ⚠️ RAM limitata (512MB)

---

## TEST 2: Render.com 🎨

### Setup (5 minuti)

1. **Vai su**: https://render.com
2. **Sign up** con GitHub
3. **New** → "Web Service"
4. **Connect Repository**: `sarcoinswap/Sarcoin-Network`

### Configurazione

1. **Basic Settings**:
   - Name: `sarcoin-testnet`
   - Region: **Frankfurt** (Europa! 🇪🇺)
   - Branch: `main`
   - Environment: Docker
   - Dockerfile Path: `./Dockerfile.sarcoin`

2. **Instance Type**:
   - Free (512MB RAM, 0.1 CPU)

3. **Environment Variables**:
   ```
   NETWORK_ID=3901
   PORT=8545
   ```

4. **Advanced** → **Disk**:
   - Name: `sarcoin-data`
   - Mount Path: `/root/.sarcoin`
   - Size: 10GB

### Deploy

Click "Create Web Service" → Auto-deploy inizia

### Test

```bash
# Render assegna URL tipo: https://sarcoin-testnet.onrender.com

# Test Chain ID
curl -X POST https://sarcoin-testnet.onrender.com/rpc \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

### Vantaggi
- ✅ Europa (bassa latenza EU)
- ✅ 750h/mese gratis
- ✅ Persistent disk incluso
- ✅ Auto-deploy da GitHub
- ✅ SSL/HTTPS automatico

### Svantaggi
- ⚠️ Sleep dopo 15 min inattività
- ⚠️ Cold start ~30 secondi
- ⚠️ Free tier limitato

---

## TEST 3: Google Cloud Run ☁️

### Setup (10 minuti)

1. **Vai su**: https://console.cloud.google.com
2. **Attiva** Cloud Run API
3. **Cloud Build** → Abilita

### Deploy da Source

```bash
# Installa gcloud CLI
# Windows: https://cloud.google.com/sdk/docs/install

# Login
gcloud auth login

# Set project
gcloud config set project YOUR_PROJECT_ID

# Deploy (da cartella progetto)
gcloud run deploy sarcoin-testnet \
  --source . \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --port 8545 \
  --max-instances 1 \
  --timeout 3600
```

### Test

```bash
# Cloud Run assegna URL tipo:
# https://sarcoin-testnet-xxxxx-ew.a.run.app

# Test Chain ID
curl -X POST https://sarcoin-testnet-xxxxx-ew.a.run.app \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

### Vantaggi
- ✅ Europa (europe-west1)
- ✅ Sempre gratis sotto soglia (2M richieste/mese)
- ✅ Auto-scaling
- ✅ No cold start se traffic costante
- ✅ Google infrastructure

### Svantaggi
- ⚠️ Setup più complesso
- ⚠️ Richiede gcloud CLI
- ⚠️ Stateless (no persistent disk default)

---

## Confronto Piattaforme

| Feature | Railway | Render | Google Cloud Run |
|---------|---------|--------|------------------|
| **Costo/mese** | $0 (500h) | $0 (750h) | $0 (sotto soglia) |
| **RAM** | 512MB | 512MB | 1GB |
| **Regione EU** | ❌ US only | ✅ Frankfurt | ✅ europe-west1 |
| **Persistent Disk** | ❌ | ✅ 10GB | ⚠️ Extra config |
| **Auto-deploy** | ✅ | ✅ | ⚠️ Manual |
| **Cold Start** | <5s | ~30s | <10s |
| **Sleep Timeout** | 15 min | 15 min | Immediate |
| **Setup Time** | 2 min | 5 min | 10 min |
| **Best For** | Quick test | EU production | Scalability |

---

## 🎯 Raccomandazioni

### Per Testing Rapido
**→ Railway.app** (2 minuti, più facile)

### Per Produzione EU
**→ Render.com** (Frankfurt, persistent disk)

### Per Scalabilità
**→ Google Cloud Run** (auto-scaling, infrastruttura enterprise)

### Per Permanente Gratis
**→ Oracle Cloud Always Free** (2 VM, SEMPRE gratis, vedi DEPLOYMENT-GUIDE.md)

---

## 📊 Piano di Test

### Giorno 1: Railway
1. Deploy su Railway
2. Test RPC endpoints
3. Verifica logs
4. Test MetaMask connection

### Giorno 2: Render
1. Deploy su Render (EU)
2. Test latenza Europa
3. Verifica persistent disk
4. Load testing

### Giorno 3: Google Cloud Run
1. Deploy su GCP
2. Test auto-scaling
3. Verifica costi
4. Performance testing

### Giorno 4: Decisione
- Analizza risultati
- Scegli piattaforma finale
- Deploy Oracle Cloud per produzione

---

## 🆘 Troubleshooting

### Railway: Build Failed
```bash
# Check logs
railway logs

# Redeploy
railway up
```

### Render: Cold Start Lento
```bash
# Upgrade to Starter plan ($7/mo)
# Or keep instance warm con cron job
```

### GCP: Permission Denied
```bash
# Check IAM roles
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:EMAIL" \
  --role="roles/run.admin"
```

---

## 📞 Support

Per problemi o domande, apri issue su:
https://github.com/sarcoinswap/Sarcoin-Network/issues

---

**Pronto per iniziare i test? Scegli una piattaforma e procedi! 🚀**
