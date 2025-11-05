# Sarcoin Network - Test Script per 3 Piattaforme Cloud
# Questo script ti guida passo-passo nel testing

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("railway", "render", "gcp", "all")]
    [string]$Platform = "all"
)

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  🧪 SARCOIN NETWORK - TEST CLOUD PLATFORMS               ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

function Test-Railway {
    Write-Host "`n🚂 TEST 1: RAILWAY.APP" -ForegroundColor Magenta
    Write-Host "═══════════════════════`n" -ForegroundColor DarkGray
    
    Write-Host "📋 PASSI DA SEGUIRE:`n" -ForegroundColor Yellow
    
    Write-Host "1️⃣  Vai su: https://railway.app" -ForegroundColor White
    Write-Host "2️⃣  Click 'Start a New Project'" -ForegroundColor White
    Write-Host "3️⃣  Seleziona 'Deploy from GitHub repo'" -ForegroundColor White
    Write-Host "4️⃣  Autorizza GitHub e scegli 'sarcoinswap/Sarcoin-Network'" -ForegroundColor White
    Write-Host "5️⃣  Railway inizierà deploy automatico`n" -ForegroundColor White
    
    Write-Host "⚙️  CONFIGURAZIONE:" -ForegroundColor Yellow
    Write-Host "   • Service Name: sarcoin-testnet" -ForegroundColor Cyan
    Write-Host "   • Environment Variables:" -ForegroundColor Cyan
    Write-Host "     NETWORK_ID=3901" -ForegroundColor DarkCyan
    Write-Host "     HTTP_PORT=8545" -ForegroundColor DarkCyan
    Write-Host "     WS_PORT=8546`n" -ForegroundColor DarkCyan
    
    Write-Host "⏳ TEMPO STIMATO: 5-10 minuti`n" -ForegroundColor Yellow
    
    $deploy = Read-Host "Hai completato il deploy su Railway? (s/n)"
    
    if ($deploy -eq 's') {
        Write-Host "`n🧪 TEST ENDPOINT`n" -ForegroundColor Cyan
        $url = Read-Host "Inserisci l'URL assegnato da Railway (es: https://xxx.railway.app)"
        
        Write-Host "`nTest Chain ID..." -ForegroundColor Yellow
        try {
            $response = Invoke-RestMethod -Uri "$url" -Method Post -ContentType "application/json" -Body '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
            if ($response.result -eq "0xf3d") {
                Write-Host "✅ Chain ID corretto: 3901 (0xf3d)" -ForegroundColor Green
            } else {
                Write-Host "❌ Chain ID errato: $($response.result)" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ Errore connessione: $_" -ForegroundColor Red
        }
    }
}

function Test-Render {
    Write-Host "`n🎨 TEST 2: RENDER.COM" -ForegroundColor Magenta
    Write-Host "═══════════════════════`n" -ForegroundColor DarkGray
    
    Write-Host "📋 PASSI DA SEGUIRE:`n" -ForegroundColor Yellow
    
    Write-Host "1️⃣  Vai su: https://render.com" -ForegroundColor White
    Write-Host "2️⃣  Sign up con GitHub" -ForegroundColor White
    Write-Host "3️⃣  Click 'New +' → 'Web Service'" -ForegroundColor White
    Write-Host "4️⃣  Connect 'sarcoinswap/Sarcoin-Network'" -ForegroundColor White
    Write-Host "5️⃣  Configurazione:" -ForegroundColor White
    Write-Host "     • Name: sarcoin-testnet" -ForegroundColor Cyan
    Write-Host "     • Region: Frankfurt (EU)" -ForegroundColor Cyan
    Write-Host "     • Environment: Docker" -ForegroundColor Cyan
    Write-Host "     • Dockerfile: ./Dockerfile.sarcoin" -ForegroundColor Cyan
    Write-Host "     • Instance: Free" -ForegroundColor Cyan
    Write-Host "6️⃣  Advanced → Add Disk:" -ForegroundColor White
    Write-Host "     • Name: sarcoin-data" -ForegroundColor Cyan
    Write-Host "     • Mount: /root/.sarcoin" -ForegroundColor Cyan
    Write-Host "     • Size: 10GB`n" -ForegroundColor Cyan
    
    Write-Host "⏳ TEMPO STIMATO: 10-15 minuti (primo deploy)`n" -ForegroundColor Yellow
    
    $deploy = Read-Host "Hai completato il deploy su Render? (s/n)"
    
    if ($deploy -eq 's') {
        Write-Host "`n🧪 TEST ENDPOINT`n" -ForegroundColor Cyan
        $url = Read-Host "Inserisci l'URL assegnato da Render (es: https://xxx.onrender.com)"
        
        Write-Host "`nTest Chain ID..." -ForegroundColor Yellow
        Write-Host "⚠️  Nota: Render free tier può richiedere 30-60s per cold start" -ForegroundColor Yellow
        
        try {
            $response = Invoke-RestMethod -Uri "$url" -Method Post -ContentType "application/json" -Body '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' -TimeoutSec 60
            if ($response.result -eq "0xf3d") {
                Write-Host "✅ Chain ID corretto: 3901 (0xf3d)" -ForegroundColor Green
                Write-Host "✅ Deploy Render SUCCESS! 🇪🇺" -ForegroundColor Green
            } else {
                Write-Host "❌ Chain ID errato: $($response.result)" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ Errore: $_" -ForegroundColor Red
            Write-Host "💡 Prova ad aspettare 1-2 minuti e riprova" -ForegroundColor Yellow
        }
    }
}

function Test-GCP {
    Write-Host "`n☁️  TEST 3: GOOGLE CLOUD RUN" -ForegroundColor Magenta
    Write-Host "═══════════════════════════════`n" -ForegroundColor DarkGray
    
    Write-Host "📋 PREREQUISITI:`n" -ForegroundColor Yellow
    Write-Host "• Google Cloud account" -ForegroundColor White
    Write-Host "• gcloud CLI installato`n" -ForegroundColor White
    
    $hasGcloud = Read-Host "Hai gcloud CLI installato? (s/n)"
    
    if ($hasGcloud -ne 's') {
        Write-Host "`n📥 INSTALLA GCLOUD CLI:" -ForegroundColor Yellow
        Write-Host "   https://cloud.google.com/sdk/docs/install`n" -ForegroundColor Cyan
        Write-Host "Dopo installazione, riavvia questo script." -ForegroundColor White
        return
    }
    
    Write-Host "`n📋 COMANDI DA ESEGUIRE:`n" -ForegroundColor Yellow
    
    Write-Host "# 1. Login" -ForegroundColor Cyan
    Write-Host "gcloud auth login`n" -ForegroundColor White
    
    Write-Host "# 2. Set project" -ForegroundColor Cyan
    Write-Host "gcloud config set project YOUR_PROJECT_ID`n" -ForegroundColor White
    
    Write-Host "# 3. Deploy" -ForegroundColor Cyan
    Write-Host @"
gcloud run deploy sarcoin-testnet \
  --source . \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --port 8545 \
  --max-instances 1
"@ -ForegroundColor White
    
    Write-Host "`n⏳ TEMPO STIMATO: 15-20 minuti (primo deploy)`n" -ForegroundColor Yellow
    
    $deploy = Read-Host "Vuoi eseguire il deploy ora? (s/n)"
    
    if ($deploy -eq 's') {
        $projectId = Read-Host "Inserisci il tuo Google Cloud Project ID"
        
        Write-Host "`n🚀 Deploying su Google Cloud Run..." -ForegroundColor Cyan
        Write-Host "(Questo processo può richiedere 15-20 minuti)`n" -ForegroundColor Yellow
        
        # Nota: Questo comando probabilmente fallirà perché richiede Docker build configurato
        # Ma mostra il processo all'utente
        $cmd = "gcloud run deploy sarcoin-testnet --source . --platform managed --region europe-west1 --allow-unauthenticated --memory 1Gi --cpu 1 --port 8545 --max-instances 1 --project $projectId"
        
        Write-Host "Eseguo: $cmd`n" -ForegroundColor Cyan
        Write-Host "⚠️  Nota: Richiede Docker Desktop avviato e configurato`n" -ForegroundColor Yellow
        
        # L'utente deve eseguire manualmente
        Write-Host "Copia e incolla questo comando nel terminale:" -ForegroundColor Yellow
        Write-Host $cmd -ForegroundColor White
    }
}

function Show-Summary {
    Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║  📊 RIEPILOGO TEST                                        ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
    
    Write-Host "✅ Repository GitHub: https://github.com/sarcoinswap/Sarcoin-Network" -ForegroundColor Cyan
    Write-Host "`n📖 Guide disponibili:" -ForegroundColor Yellow
    Write-Host "  • TESTING-GUIDE.md - Guida dettagliata test" -ForegroundColor White
    Write-Host "  • DEPLOYMENT-GUIDE.md - Deploy produzione" -ForegroundColor White
    Write-Host "  • NEXT-STEPS.md - Prossimi passi`n" -ForegroundColor White
    
    Write-Host "🎯 PROSSIMO PASSO:" -ForegroundColor Yellow
    Write-Host "   Dopo i test, deploy su Oracle Cloud Always Free" -ForegroundColor White
    Write-Host "   per produzione permanente gratis!`n" -ForegroundColor White
    
    Write-Host "💰 COSTI MENSILI:" -ForegroundColor Yellow
    Write-Host "  Railway:  `$0 (500h free)" -ForegroundColor Green
    Write-Host "  Render:   `$0 (750h free)" -ForegroundColor Green
    Write-Host "  GCP Run:  `$0 (sotto soglia)" -ForegroundColor Green
    Write-Host "  Oracle:   `$0 (SEMPRE GRATIS)`n" -ForegroundColor Green
}

# Main execution
switch ($Platform) {
    "railway" {
        Test-Railway
    }
    "render" {
        Test-Render
    }
    "gcp" {
        Test-GCP
    }
    "all" {
        Write-Host "🎯 Test completo su tutte e 3 le piattaforme`n" -ForegroundColor Cyan
        
        $choice = Read-Host "Vuoi procedere con tutti i test? (s/n)"
        
        if ($choice -eq 's') {
            Test-Railway
            Write-Host "`n" + ("─" * 60) + "`n" -ForegroundColor DarkGray
            Test-Render
            Write-Host "`n" + ("─" * 60) + "`n" -ForegroundColor DarkGray
            Test-GCP
        }
    }
}

Show-Summary

Write-Host "`n🎉 Test script completato!" -ForegroundColor Green
Write-Host "Per maggiori dettagli, leggi: .\TESTING-GUIDE.md`n" -ForegroundColor Cyan
