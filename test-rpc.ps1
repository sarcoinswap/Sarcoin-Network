# Sarcoin SRS - RPC Test Script
# This script tests the Sarcoin testnet node via RPC calls

Write-Host "=== Sarcoin SRS RPC Test ===" -ForegroundColor Cyan
Write-Host ""

$RPC_URL = "http://127.0.0.1:8545"

function Invoke-RPC {
    param(
        [string]$Method,
        [array]$Params = @()
    )
    
    $body = @{
        jsonrpc = "2.0"
        method = $Method
        params = $Params
        id = 1
    } | ConvertTo-Json -Depth 10
    
    try {
        $response = Invoke-RestMethod -Uri $RPC_URL -Method Post -ContentType "application/json" -Body $body
        return $response.result
    } catch {
        Write-Host "ERROR: $_" -ForegroundColor Red
        return $null
    }
}

Write-Host "Testing RPC connection to $RPC_URL..." -ForegroundColor Yellow
Write-Host ""

# Test 1: Chain ID
Write-Host "[1] Getting Chain ID..." -ForegroundColor Green
$chainId = Invoke-RPC -Method "eth_chainId"
if ($chainId) {
    $chainIdDec = [Convert]::ToInt64($chainId, 16)
    Write-Host "   Chain ID: $chainIdDec (hex: $chainId)" -ForegroundColor Cyan
    if ($chainIdDec -eq 3901) {
        Write-Host "   ✓ Correct Sarcoin Testnet Chain ID!" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Wrong Chain ID (expected 3901)" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ Failed to get Chain ID" -ForegroundColor Red
}
Write-Host ""

# Test 2: Latest Block Number
Write-Host "[2] Getting Latest Block Number..." -ForegroundColor Green
$blockNumber = Invoke-RPC -Method "eth_blockNumber"
if ($blockNumber) {
    $blockDec = [Convert]::ToInt64($blockNumber, 16)
    Write-Host "   Block Number: $blockDec (hex: $blockNumber)" -ForegroundColor Cyan
} else {
    Write-Host "   ✗ Failed to get block number" -ForegroundColor Red
}
Write-Host ""

# Test 3: Network Version
Write-Host "[3] Getting Network Version..." -ForegroundColor Green
$netVersion = Invoke-RPC -Method "net_version"
if ($netVersion) {
    Write-Host "   Network Version: $netVersion" -ForegroundColor Cyan
} else {
    Write-Host "   ✗ Failed to get network version" -ForegroundColor Red
}
Write-Host ""

# Test 4: Peer Count
Write-Host "[4] Getting Peer Count..." -ForegroundColor Green
$peerCount = Invoke-RPC -Method "net_peerCount"
if ($peerCount) {
    $peerDec = [Convert]::ToInt64($peerCount, 16)
    Write-Host "   Peers: $peerDec" -ForegroundColor Cyan
} else {
    Write-Host "   ✗ Failed to get peer count" -ForegroundColor Red
}
Write-Host ""

# Test 5: Gas Price
Write-Host "[5] Getting Gas Price..." -ForegroundColor Green
$gasPrice = Invoke-RPC -Method "eth_gasPrice"
if ($gasPrice) {
    $gasDec = [Convert]::ToInt64($gasPrice, 16)
    $gasGwei = $gasDec / 1000000000
    Write-Host "   Gas Price: $gasDec wei ($gasGwei Gwei)" -ForegroundColor Cyan
} else {
    Write-Host "   ✗ Failed to get gas price" -ForegroundColor Red
}
Write-Host ""

# Test 6: Syncing Status
Write-Host "[6] Getting Sync Status..." -ForegroundColor Green
$syncing = Invoke-RPC -Method "eth_syncing"
if ($syncing -eq $false) {
    Write-Host "   ✓ Node is synced!" -ForegroundColor Green
} elseif ($syncing) {
    Write-Host "   Syncing: Current=$($syncing.currentBlock) Highest=$($syncing.highestBlock)" -ForegroundColor Yellow
} else {
    Write-Host "   ✗ Failed to get sync status" -ForegroundColor Red
}
Write-Host ""

# Test 7: Get Block by Number
if ($blockNumber) {
    Write-Host "[7] Getting Latest Block Details..." -ForegroundColor Green
    $block = Invoke-RPC -Method "eth_getBlockByNumber" -Params @($blockNumber, $false)
    if ($block) {
        Write-Host "   Block Hash: $($block.hash)" -ForegroundColor Cyan
        Write-Host "   Timestamp: $($block.timestamp)" -ForegroundColor Cyan
        Write-Host "   Transactions: $($block.transactions.Count)" -ForegroundColor Cyan
        Write-Host "   Miner: $($block.miner)" -ForegroundColor Cyan
    } else {
        Write-Host "   ✗ Failed to get block details" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "=== Test Complete ===" -ForegroundColor Cyan
