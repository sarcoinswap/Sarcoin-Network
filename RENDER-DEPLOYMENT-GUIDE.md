# 🌍 Render.com Deployment - Quick Reference Card

## 🔗 Links Importanti

**Homepage:** https://render.com
**Dashboard:** https://dashboard.render.com
**Docs:** https://render.com/docs
**GitHub Repo:** https://github.com/sarcoinswap/Sarcoin-Network

---

## ✅ Checklist Deployment

### 1. Account Setup
- [ ] Vai su https://render.com
- [ ] Clicca "Get Started" o "Sign Up"
- [ ] Scegli "Sign Up with GitHub"
- [ ] Autorizza Render ad accedere a GitHub

### 2. Create Private Service
- [ ] Dashboard > "New +" button
- [ ] Select "Private Service" ⚠️ (NON Web Service!)
- [ ] Connect GitHub repository: `sarcoinswap/Sarcoin-Network`

### 3. Service Configuration

| Campo | Valore |
|-------|--------|
| **Name** | `sarcoin-node-eu` |
| **Region** | Frankfurt (EU Central) |
| **Branch** | `main` |
| **Runtime** | Docker |
| **Dockerfile Path** | `./Dockerfile.sarcoin` |
| **Plan** | Free (Starter) |

### 4. Add Persistent Disk
- [ ] Scroll to "Disk" section
- [ ] Click "Add Disk"
- [ ] Name: `sarcoin-data`
- [ ] Mount Path: `/root/.sarcoin`
- [ ] Size: `10 GB`

### 5. Environment Variables (Optional)
```
NETWORK_ID = 3901
HTTP_PORT = 8545
WS_PORT = 8546
P2P_PORT = 30303
```

### 6. Deploy!
- [ ] Click "Create Private Service"
- [ ] Wait for build (~15-20 minutes)
- [ ] Monitor logs for "HTTP server started"

---

## 🎯 Cosa Rende Render Migliore

✅ **Private Services** - Perfetti per blockchain nodes (no health checks HTTP)
✅ **750h/mese FREE** - Più di Railway (500h)
✅ **Frankfurt EU** - Bassa latenza per Europa
✅ **10GB Storage** - Incluso nel free tier
✅ **Auto Deploy** - Deploy automatico da GitHub push
✅ **Persistent Disk** - Dati blockchain non si perdono mai

---

## ⏱️ Timeline Prevista

| Fase | Durata | Descrizione |
|------|--------|-------------|
| Setup account | 2 min | Sign up con GitHub |
| Configurazione service | 3 min | Form con tutti i parametri |
| Build Docker | 15-20 min | Compilazione Go 1.24 + geth |
| Startup node | 2-3 min | Inizializzazione blockchain |
| **TOTALE** | **~25 min** | Nodo completamente operativo |

---

## 🔍 Cosa Cercare nei Log

### ✅ Build Success Indicators
```
✓ Downloading Go 1.24.x
✓ Building geth
✓ Image built successfully
✓ Deploying...
```

### ✅ Runtime Success Indicators
```
INFO [date] HTTP server started endpoint=[::]:8545
INFO [date] WebSocket enabled url=ws://[::]:8546
INFO [date] Started P2P networking
INFO [date] Looking for peers
```

### ❌ Errori Comuni
- `Dockerfile not found` → Verifica path: `./Dockerfile.sarcoin`
- `disk mount failed` → Verifica mount path: `/root/.sarcoin`
- `out of memory` → Questo NON dovrebbe succedere con free tier

---

## 📊 Dopo il Deployment

### Ottenere l'Endpoint
1. Dashboard > Your Service
2. Copia "Internal URL" (esempio: `sarcoin-node-eu-xxx.onrender.com`)
3. Il nodo sarà accessibile su questa URL

### Testare l'RPC
```bash
curl -X POST https://sarcoin-node-eu-xxx.onrender.com \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

Risposta attesa:
```json
{"jsonrpc":"2.0","id":1,"result":"0xf3d"}
```
(0xf3d = 3901 in esadecimale)

### Estrarre Enode Address
1. Vai su Logs
2. Cerca: `Started P2P networking self=enode://...`
3. Copia l'intero enode URL per configurare bootnodes

---

## 💰 Costi

| Risorsa | Free Tier | Oltre Free |
|---------|-----------|------------|
| Compute | 750h/mese | $7/mese (unlimited) |
| Disk | 1GB | $0.25/GB/mese |
| Bandwidth | Incluso | Incluso |

**Stima per Sarcoin:**
- Compute: 750h (sufficiente per ~31 giorni 24/7)
- Disk: 10GB = $2.50/mese
- **Totale: ~$2.50/mese**

---

## 🆘 Supporto

**Render Docs:** https://render.com/docs/docker
**Community:** https://community.render.com
**Support:** support@render.com

**Nostro GitHub:** https://github.com/sarcoinswap/Sarcoin-Network/issues

---

## ✨ Prossimi Passi Dopo Deploy

1. ✅ Testare RPC endpoint
2. ✅ Estrarre enode address
3. ⏭️ Configurare bootnodes (connettere più nodi)
4. ⏭️ Deploy Oracle Cloud (nodi permanenti gratuiti)
5. ⏭️ Setup block explorer
6. ⏭️ Creare testnet faucet

---

**🎉 Una volta completato il deployment, torna qui e scrivi "fatto"!**
