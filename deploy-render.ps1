# Deploy Sarcoin Network Node to Render.com
# Interactive deployment guide

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       🌍 DEPLOY SARCOIN NODE SU RENDER.COM           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "✨ VANTAGGI DI RENDER.COM:" -ForegroundColor Green
Write-Host "   • 750 ore/mese FREE (più di Railway)" -ForegroundColor White
Write-Host "   • Supporto nativo per Private Services (perfetto per blockchain)" -ForegroundColor White
Write-Host "   • Region Frankfurt (EU Central)" -ForegroundColor White
Write-Host "   • 10GB storage gratis" -ForegroundColor White
Write-Host "   • Auto-deploy da GitHub`n" -ForegroundColor White

Write-Host "📋 PASSI PER IL DEPLOYMENT:`n" -ForegroundColor Yellow

Write-Host "STEP 1: CREA ACCOUNT RENDER" -ForegroundColor Cyan
Write-Host "   1. Vai su https://render.com" -ForegroundColor White
Write-Host "   2. Clicca 'Get Started' o 'Sign Up'" -ForegroundColor White
Write-Host "   3. Scegli 'Sign Up with GitHub' (consigliato)" -ForegroundColor White
Write-Host "   4. Autorizza Render ad accedere al tuo GitHub`n" -ForegroundColor White

$step1 = Read-Host "Hai creato l'account? (s per continuare)"
if ($step1 -ne "s") { exit }

Write-Host "`nSTEP 2: NUOVO PRIVATE SERVICE" -ForegroundColor Cyan
Write-Host "   1. Nella dashboard Render, clicca 'New +'" -ForegroundColor White
Write-Host "   2. Seleziona 'Private Service' (NON Web Service!)" -ForegroundColor Yellow
Write-Host "   3. Connetti il repository GitHub: sarcoinswap/Sarcoin-Network" -ForegroundColor White
Write-Host "   4. Render detecterà automaticamente il Dockerfile`n" -ForegroundColor White

$step2 = Read-Host "Hai selezionato Private Service? (s per continuare)"
if ($step2 -ne "s") { exit }

Write-Host "`nSTEP 3: CONFIGURAZIONE SERVICE" -ForegroundColor Cyan
Write-Host "   Compila i campi con questi valori:`n" -ForegroundColor White

Write-Host "   Name: " -NoNewline -ForegroundColor Gray
Write-Host "sarcoin-node-eu" -ForegroundColor Yellow

Write-Host "   Region: " -NoNewline -ForegroundColor Gray
Write-Host "Frankfurt (EU Central)" -ForegroundColor Yellow

Write-Host "   Branch: " -NoNewline -ForegroundColor Gray
Write-Host "main" -ForegroundColor Yellow

Write-Host "   Runtime: " -NoNewline -ForegroundColor Gray
Write-Host "Docker" -ForegroundColor Yellow

Write-Host "   Dockerfile Path: " -NoNewline -ForegroundColor Gray
Write-Host "./Dockerfile.sarcoin" -ForegroundColor Yellow

Write-Host "`n   Plan: " -NoNewline -ForegroundColor Gray
Write-Host "Free (Starter)" -ForegroundColor Green

Write-Host "`n"
$step3 = Read-Host "Hai configurato il service? (s per continuare)"
if ($step3 -ne "s") { exit }

Write-Host "`nSTEP 4: AGGIUNGI DISCO PERSISTENTE" -ForegroundColor Cyan
Write-Host "   ⚠️  IMPORTANTE per non perdere i dati blockchain!`n" -ForegroundColor Yellow

Write-Host "   1. Scorri fino a 'Disk'" -ForegroundColor White
Write-Host "   2. Clicca 'Add Disk'" -ForegroundColor White
Write-Host "   3. Configura:" -ForegroundColor White
Write-Host "      • Name: " -NoNewline -ForegroundColor Gray
Write-Host "sarcoin-data" -ForegroundColor Yellow
Write-Host "      • Mount Path: " -NoNewline -ForegroundColor Gray
Write-Host "/root/.sarcoin" -ForegroundColor Yellow
Write-Host "      • Size: " -NoNewline -ForegroundColor Gray
Write-Host "10 GB" -ForegroundColor Yellow
Write-Host "`n"

$step4 = Read-Host "Hai aggiunto il disco? (s per continuare)"
if ($step4 -ne "s") { exit }

Write-Host "`nSTEP 5: VARIABILI D'AMBIENTE (OPZIONALE)" -ForegroundColor Cyan
Write-Host "   Puoi aggiungere queste variabili (facoltativo):`n" -ForegroundColor White

Write-Host "   NETWORK_ID = 3901" -ForegroundColor Gray
Write-Host "   HTTP_PORT = 8545" -ForegroundColor Gray
Write-Host "   WS_PORT = 8546" -ForegroundColor Gray
Write-Host "   P2P_PORT = 30303`n" -ForegroundColor Gray

$step5 = Read-Host "Vuoi aggiungere le variabili? (s/n)"

Write-Host "`nSTEP 6: CREA IL SERVICE!" -ForegroundColor Cyan
Write-Host "   1. Clicca 'Create Private Service' in fondo" -ForegroundColor White
Write-Host "   2. Render inizierà il build automaticamente" -ForegroundColor White
Write-Host "   3. Tempo stimato: 15-20 minuti (compilazione Go)`n" -ForegroundColor Gray

$step6 = Read-Host "Hai cliccato 'Create Private Service'? (s per continuare)"
if ($step6 -ne "s") { exit }

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║        ✅ DEPLOYMENT RENDER AVVIATO!                  ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "🔍 MONITORA IL BUILD:" -ForegroundColor Yellow
Write-Host "   • Vai alla tab 'Logs' del tuo service" -ForegroundColor White
Write-Host "   • Guarda il build in tempo reale" -ForegroundColor White
Write-Host "   • Cerca: 'go: downloading go1.24.x'" -ForegroundColor White
Write-Host "   • Poi: 'Building geth...'" -ForegroundColor White
Write-Host "   • Infine: 'HTTP server started'`n" -ForegroundColor White

Write-Host "⏱️  TEMPO PREVISTO: 15-20 minuti" -ForegroundColor Cyan
Write-Host "   Il build include:" -ForegroundColor White
Write-Host "   • Download Go 1.24+ (~2 min)" -ForegroundColor Gray
Write-Host "   • Compilazione geth (~12-15 min)" -ForegroundColor Gray
Write-Host "   • Deploy e avvio nodo (~2-3 min)`n" -ForegroundColor Gray

Write-Host "📝 DOPO IL DEPLOYMENT:" -ForegroundColor Magenta
Write-Host "   1. Copia l'endpoint privato (lo troverai nella dashboard)" -ForegroundColor White
Write-Host "   2. Estrai l'enode address dai log" -ForegroundColor White
Write-Host "   3. Configura bootnodes per connettere i nodi`n" -ForegroundColor White

Write-Host "💡 TIP:" -ForegroundColor Yellow
Write-Host "   Se il build fallisce, controlla i log per l'errore specifico." -ForegroundColor White
Write-Host "   I problemi comuni sono:" -ForegroundColor White
Write-Host "   • Dockerfile path errato" -ForegroundColor Gray
Write-Host "   • Disk mount path non corretto" -ForegroundColor Gray
Write-Host "   • Go version incompatibility (già risolto nel nostro Dockerfile!)`n" -ForegroundColor Gray

Write-Host "✨ Quando il deployment è completo, scrivi 'fatto' per continuare!`n" -ForegroundColor Green
