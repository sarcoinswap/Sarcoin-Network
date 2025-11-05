# 🚀 GitHub Repository Setup per Deployment

## Passo 1: Crea GitHub Repository

1. **Vai su**: https://github.com/new
2. **Repository name**: `sarcoin-network`
3. **Description**: `🇪🇺 Sarcoin SRS Network - European EVM blockchain (BSC fork, 1s block time, Parlia PoSA consensus)`
4. **Visibility**: ✅ Public (necessario per deployment gratuito)
5. **NON aggiungere**: README, .gitignore, license (già presenti)
6. **Click**: "Create repository"

## Passo 2: Push del Codice

Dopo aver creato il repository, esegui questi comandi:

```powershell
# Aggiungi remote GitHub
git remote add origin https://github.com/sarcoinswap/Sarcoin-Network.git

# Rinomina branch a main (se necessario)
git branch -M main

# Push del codice
git push -u origin main
```

## Passo 3: Verifica

Dopo il push, verifica su GitHub:

- ✅ Codice sorgente visibile
- ✅ README.md visualizzato
- ✅ genesis-testnet.json e genesis-mainnet.json presenti
- ✅ Dockerfile.sarcoin presente
- ✅ setup-oracle.sh presente

## Prossimo Passo: Oracle Cloud Deployment

Una volta completato il push su GitHub, segui la guida in `DEPLOY.md` sezione "Oracle Cloud Always Free" per:

1. Creare account Oracle Cloud
2. Provisionare 2 VM Ubuntu 22.04
3. Clonare il repository su VM
4. Eseguire `setup-oracle.sh` per deployment automatico

---

**Repository URL**: `https://github.com/sarcoinswap/Sarcoin-Network`

Questo URL sarà necessario per clonare il codice sulle VM Oracle Cloud.
