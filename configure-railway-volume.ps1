# Railway Volume Configuration Guide
# This script helps you configure Railway Volume via CLI

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       📦 RAILWAY VOLUME CONFIGURATION GUIDE           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "⚠️  IMPORTANTE: I volumi su Railway sono CRITICI per la persistenza dati!" -ForegroundColor Yellow
Write-Host "   Senza volume, tutti i dati blockchain vengono persi ad ogni redeploy!`n" -ForegroundColor Yellow

Write-Host "📋 PASSI PER CONFIGURARE IL VOLUME:" -ForegroundColor Magenta
Write-Host "`n1️⃣  VAI SU RAILWAY DASHBOARD" -ForegroundColor Cyan
Write-Host "   https://railway.app/dashboard`n" -ForegroundColor White

Write-Host "2️⃣  SELEZIONA IL TUO PROGETTO SARCOIN" -ForegroundColor Cyan
Write-Host "   Clicca sul progetto dalla lista`n" -ForegroundColor White

Write-Host "3️⃣  APRI LA TAB 'VOLUMES'" -ForegroundColor Cyan
Write-Host "   Nel menu laterale, clicca su 'Volumes'`n" -ForegroundColor White

Write-Host "4️⃣  CLICCA 'NEW VOLUME'" -ForegroundColor Cyan
Write-Host "   Bottone blu in alto a destra`n" -ForegroundColor White

Write-Host "5️⃣  CONFIGURA IL VOLUME:" -ForegroundColor Cyan
Write-Host "   • Mount Path: " -NoNewline -ForegroundColor White
Write-Host "/root/.sarcoin" -ForegroundColor Yellow
Write-Host "   • Size: " -NoNewline -ForegroundColor White
Write-Host "10 GB" -ForegroundColor Yellow
Write-Host "   • Name: " -NoNewline -ForegroundColor White
Write-Host "sarcoin-data" -ForegroundColor Yellow
Write-Host "`n"

Write-Host "6️⃣  CLICCA 'CREATE VOLUME'" -ForegroundColor Cyan
Write-Host "   Il volume verrà creato e montato automaticamente`n" -ForegroundColor White

Write-Host "7️⃣  ATTENDI IL REDEPLOY AUTOMATICO" -ForegroundColor Cyan
Write-Host "   Railway riavvierà il servizio con il volume montato" -ForegroundColor White
Write-Host "   Tempo stimato: 2-3 minuti`n" -ForegroundColor Gray

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Gray

Write-Host "💡 PERCHÉ È IMPORTANTE:" -ForegroundColor Yellow
Write-Host "   • Mantiene i dati blockchain tra i redeploy" -ForegroundColor White
Write-Host "   • Evita di ri-sincronizzare da zero ogni volta" -ForegroundColor White
Write-Host "   • Salva lo stato del nodo (accounts, peers, ecc.)" -ForegroundColor White
Write-Host "   • NECESSARIO per un nodo di produzione`n" -ForegroundColor White

Write-Host "📊 DOPO LA CONFIGURAZIONE:" -ForegroundColor Magenta
Write-Host "   Verifica che il volume sia montato controllando i log:" -ForegroundColor White
Write-Host "   Dovresti vedere: 'Allocated cache and file handles database=/root/.sarcoin/geth/chaindata'`n" -ForegroundColor Gray

Write-Host "⚠️  NOTA SUI COSTI:" -ForegroundColor Yellow
Write-Host "   Railway free tier: 500h/mese + 1GB storage incluso" -ForegroundColor White
Write-Host "   Storage extra: ~$0.25/GB/mese ($2.50 per 10GB)" -ForegroundColor White
Write-Host "   Totale stimato: ~$2.50/mese (molto conveniente!)`n" -ForegroundColor Gray

$response = Read-Host "`nHai configurato il volume? (s/n)"

if ($response -eq "s" -or $response -eq "S") {
    Write-Host "`n✅ Ottimo! Ora esegui il test RPC:" -ForegroundColor Green
    Write-Host "   .\test-railway-rpc.ps1`n" -ForegroundColor Yellow
} else {
    Write-Host "`n⚠️  Ricorda di configurare il volume prima di usare il nodo in produzione!`n" -ForegroundColor Yellow
}
