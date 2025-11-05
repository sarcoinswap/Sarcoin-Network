# Sarcoin SRS - Testnet Node Startup Script
# This script starts a local Sarcoin testnet node for testing

Write-Host "=== Sarcoin SRS Testnet Node ===" -ForegroundColor Cyan
Write-Host ""

# Configuration
$DATADIR = "./testnet-data"
$NETWORK_ID = 3901
$HTTP_PORT = 8545
$HTTP_ADDR = "127.0.0.1"
$VALIDATOR_ADDR = "0x0000000000000000000000000000000000000001"  # First validator from genesis

# Check if geth binary exists
if (-not (Test-Path "build/bin/geth.exe")) {
    Write-Host "ERROR: geth.exe not found. Please compile first with: go build -o build/bin/geth.exe ./cmd/geth" -ForegroundColor Red
    exit 1
}

# Check if datadir is initialized
if (-not (Test-Path "$DATADIR/geth/chaindata")) {
    Write-Host "ERROR: Testnet not initialized. Please run: .\build\bin\geth.exe init --datadir $DATADIR genesis-testnet.json" -ForegroundColor Red
    exit 1
}

Write-Host "Starting Sarcoin testnet node..." -ForegroundColor Green
Write-Host "Network ID: $NETWORK_ID" -ForegroundColor Yellow
Write-Host "HTTP RPC: http://${HTTP_ADDR}:${HTTP_PORT}" -ForegroundColor Yellow
Write-Host "Validator: $VALIDATOR_ADDR" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the node" -ForegroundColor Gray
Write-Host ""

# Start the node
.\build\bin\geth.exe `
    --datadir $DATADIR `
    --networkid $NETWORK_ID `
    --http `
    --http.addr $HTTP_ADDR `
    --http.port $HTTP_PORT `
    --http.api "eth,net,web3,personal,admin,txpool" `
    --http.corsdomain "*" `
    --ws `
    --ws.addr $HTTP_ADDR `
    --ws.port 8546 `
    --ws.api "eth,net,web3" `
    --ws.origins "*" `
    --nodiscover `
    --maxpeers 0 `
    --mine `
    --miner.etherbase $VALIDATOR_ADDR `
    --verbosity 3 `
    console
