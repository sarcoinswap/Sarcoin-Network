# Test RPC Endpoint Localhost
# Testa l'endpoint RPC del nodo Sarcoin locale

$endpoint = "http://localhost:8545"

Write-Host "`n╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     🧪 TEST RPC ENDPOINT LOCALHOST                   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "🎯 Endpoint: $endpoint`n" -ForegroundColor Yellow

$tests = @(
    @{
        Name = "eth_chainId"
        Method = "eth_chainId"
        Params = @()
        Expected = "0xf3d"
        Description = "Chain ID (dovrebbe essere 0xf3d = 3901)"
    },
    @{
        Name = "eth_blockNumber"
        Method = "eth_blockNumber"
        Params = @()
        Expected = $null
        Description = "Numero blocco corrente"
    },
    @{
        Name = "net_version"
        Method = "net_version"
        Params = @()
        Expected = "3901"
        Description = "Network ID"
    },
    @{
        Name = "net_peerCount"
        Method = "net_peerCount"
        Params = @()
        Expected = $null
        Description = "Numero di peer connessi"
    },
    @{
        Name = "eth_syncing"
        Method = "eth_syncing"
        Params = @()
        Expected = $null
        Description = "Stato sincronizzazione"
    }
)

$results = @()
$passed = 0
$failed = 0

foreach ($test in $tests) {
    Write-Host "📋 Test: $($test.Name) - $($test.Description)" -ForegroundColor White
    
    $body = @{
        jsonrpc = "2.0"
        method = $test.Method
        params = $test.Params
        id = 1
    } | ConvertTo-Json -Compress

    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Post -Body $body -ContentType "application/json" -TimeoutSec 10
        
        if ($response.error) {
            Write-Host "   ❌ ERRORE: $($response.error.message)" -ForegroundColor Red
            $failed++
            $results += @{
                Test = $test.Name
                Status = "FAILED"
                Error = $response.error.message
                Result = $null
            }
        }
        else {
            $resultValue = $response.result
            $statusIcon = "✅"
            $statusColor = "Green"
            $status = "PASSED"
            
            # Verifica risultato atteso se specificato
            if ($test.Expected -and $resultValue -ne $test.Expected) {
                $statusIcon = "⚠️"
                $statusColor = "Yellow"
                $status = "WARNING"
            }
            
            Write-Host "   $statusIcon Risultato: $resultValue" -ForegroundColor $statusColor
            $passed++
            
            $results += @{
                Test = $test.Name
                Status = $status
                Error = $null
                Result = $resultValue
            }
        }
    }
    catch {
        Write-Host "   ❌ ERRORE: $($_.Exception.Message)" -ForegroundColor Red
        $failed++
        $results += @{
            Test = $test.Name
            Status = "FAILED"
            Error = $_.Exception.Message
            Result = $null
        }
    }
    
    Write-Host ""
}

# Riepilogo
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                    📊 RIEPILOGO                       ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Test passati: $passed" -ForegroundColor Green
Write-Host "❌ Test falliti: $failed" -ForegroundColor Red
Write-Host "📈 Totale test: $($tests.Count)" -ForegroundColor White
Write-Host ""

# Salva risultati in JSON
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$reportFile = "localhost-rpc-test-$timestamp.json"

$report = @{
    Timestamp = Get-Date -Format "o"
    Endpoint = $endpoint
    TotalTests = $tests.Count
    Passed = $passed
    Failed = $failed
    Results = $results
}

$report | ConvertTo-Json -Depth 10 | Out-File $reportFile -Encoding UTF8

Write-Host "💾 Report salvato in: $reportFile" -ForegroundColor Cyan
Write-Host ""

# Risultato finale
if ($failed -eq 0) {
    Write-Host "🎉 TUTTI I TEST SONO PASSATI! Il nodo è pronto per Render.com!" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "⚠️  Alcuni test sono falliti. Verifica i log del container." -ForegroundColor Yellow
    exit 1
}
