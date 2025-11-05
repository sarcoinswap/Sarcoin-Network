# Test Railway RPC Endpoint
# Usage: .\test-railway-rpc.ps1 -Url "https://your-app.up.railway.app"

param(
    [Parameter(Mandatory=$false)]
    [string]$Url = ""
)

$ErrorActionPreference = "Continue"

function Test-RpcEndpoint {
    param(
        [string]$Endpoint,
        [string]$Method,
        [string]$Description
    )
    
    Write-Host "`n🧪 Testing: $Description" -ForegroundColor Cyan
    Write-Host "   Method: $Method" -ForegroundColor Gray
    
    $body = @{
        jsonrpc = "2.0"
        method = $Method
        params = @()
        id = 1
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri $Endpoint -Method Post -Body $body -ContentType "application/json" -TimeoutSec 10
        
        if ($response.result) {
            Write-Host "   ✅ Success!" -ForegroundColor Green
            Write-Host "   Result: $($response.result)" -ForegroundColor Yellow
            return $true
        } elseif ($response.error) {
            Write-Host "   ❌ Error: $($response.error.message)" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "   ❌ Request failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Banner
Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║         🧪 SARCOIN RAILWAY RPC ENDPOINT TEST          ║" -ForegroundColor Magenta
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Magenta

# Get URL if not provided
if ([string]::IsNullOrEmpty($Url)) {
    Write-Host "📋 Come trovare l'URL Railway:" -ForegroundColor Cyan
    Write-Host "   1. Vai su https://railway.app/dashboard" -ForegroundColor White
    Write-Host "   2. Clicca sul tuo progetto Sarcoin" -ForegroundColor White
    Write-Host "   3. Nella tab 'Settings', copia il 'Public Domain'" -ForegroundColor White
    Write-Host "   4. L'URL sarà tipo: https://sarcoin-xxx.up.railway.app`n" -ForegroundColor White
    
    $Url = Read-Host "Inserisci l'URL pubblico di Railway"
}

# Validate URL
if (-not $Url.StartsWith("http")) {
    $Url = "https://$Url"
}

Write-Host "`n🔗 Testing endpoint: $Url" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Gray

# Track results
$results = @{
    Total = 0
    Passed = 0
    Failed = 0
}

# Test 1: Chain ID
$results.Total++
if (Test-RpcEndpoint -Endpoint $Url -Method "eth_chainId" -Description "Chain ID (should be 0xf3d = 3901)") {
    $results.Passed++
} else {
    $results.Failed++
}

Start-Sleep -Milliseconds 500

# Test 2: Block Number
$results.Total++
if (Test-RpcEndpoint -Endpoint $Url -Method "eth_blockNumber" -Description "Current Block Number") {
    $results.Passed++
} else {
    $results.Failed++
}

Start-Sleep -Milliseconds 500

# Test 3: Network Version
$results.Total++
if (Test-RpcEndpoint -Endpoint $Url -Method "net_version" -Description "Network Version (should be 3901)") {
    $results.Passed++
} else {
    $results.Failed++
}

Start-Sleep -Milliseconds 500

# Test 4: Peer Count
$results.Total++
if (Test-RpcEndpoint -Endpoint $Url -Method "net_peerCount" -Description "Connected Peers Count") {
    $results.Passed++
} else {
    $results.Failed++
}

Start-Sleep -Milliseconds 500

# Test 5: Syncing Status
$results.Total++
if (Test-RpcEndpoint -Endpoint $Url -Method "eth_syncing" -Description "Syncing Status") {
    $results.Passed++
} else {
    $results.Failed++
}

# Summary
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "`n📊 TEST SUMMARY:" -ForegroundColor Cyan
Write-Host "   Total Tests: $($results.Total)" -ForegroundColor White
Write-Host "   ✅ Passed: $($results.Passed)" -ForegroundColor Green
Write-Host "   ❌ Failed: $($results.Failed)" -ForegroundColor Red

if ($results.Failed -eq 0) {
    Write-Host "`n🎉 TUTTI I TEST PASSATI!" -ForegroundColor Green
    Write-Host "   Il nodo Railway è completamente funzionante!`n" -ForegroundColor Green
    
    Write-Host "📌 PROSSIMI PASSI:" -ForegroundColor Magenta
    Write-Host "   1. Configura Railway Volume per persistenza dati" -ForegroundColor White
    Write-Host "   2. Deploy secondo nodo su Render.com" -ForegroundColor White
    Write-Host "   3. Configura bootnodes per connettere i nodi`n" -ForegroundColor White
} else {
    Write-Host "`n⚠️  ALCUNI TEST FALLITI" -ForegroundColor Yellow
    Write-Host "   Verifica che il nodo sia completamente avviato" -ForegroundColor Yellow
    Write-Host "   Controlla i log su Railway per dettagli`n" -ForegroundColor Yellow
}

# Save results
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$resultFile = "railway-rpc-test-$timestamp.json"

$testReport = @{
    timestamp = $timestamp
    endpoint = $Url
    results = $results
    chainId_expected = "0xf3d (3901)"
    network_expected = "3901"
} | ConvertTo-Json -Depth 3

$testReport | Out-File -FilePath $resultFile -Encoding UTF8
Write-Host "📄 Report salvato: $resultFile`n" -ForegroundColor Gray
