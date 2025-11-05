# Sarcoin SRS - Multi-Node Testnet
# Starts multiple validator nodes for local testing

param(
    [int]$NodeCount = 3,
    [int]$StartPort = 30303,
    [int]$StartRPCPort = 8545
)

Write-Host "=== Sarcoin Multi-Node Testnet ===" -ForegroundColor Cyan
Write-Host ""

# Check validators
if (-not (Test-Path "validators/addresses.txt")) {
    Write-Host "ERROR: No validators found. Run .\create-validators.ps1 first" -ForegroundColor Red
    exit 1
}

$validators = Get-Content "validators/addresses.txt"
if ($validators.Count -lt $NodeCount) {
    Write-Host "ERROR: Not enough validators. Found $($validators.Count), need $NodeCount" -ForegroundColor Red
    exit 1
}

Write-Host "Starting $NodeCount validator nodes..." -ForegroundColor Green
Write-Host ""

$processes = @()

for ($i = 1; $i -le $NodeCount; $i++) {
    $nodePort = $StartPort + $i - 1
    $rpcPort = $StartRPCPort + $i - 1
    $validatorAddr = $validators[$i - 1]
    $datadir = "validators/validator$i"
    
    Write-Host "Node $i:" -ForegroundColor Yellow
    Write-Host "  Port: $nodePort" -ForegroundColor Cyan
    Write-Host "  RPC: http://127.0.0.1:$rpcPort" -ForegroundColor Cyan
    Write-Host "  Validator: $validatorAddr" -ForegroundColor Cyan
    
    $logFile = "validators/node$i.log"
    
    # Start node in background
    $proc = Start-Process -FilePath ".\build\bin\geth.exe" -ArgumentList @(
        "--datadir", $datadir,
        "--networkid", "3901",
        "--port", $nodePort,
        "--http",
        "--http.addr", "127.0.0.1",
        "--http.port", $rpcPort,
        "--http.api", "eth,net,web3,admin",
        "--mine",
        "--miner.etherbase", $validatorAddr,
        "--password", "validators/password.txt",
        "--unlock", $validatorAddr,
        "--allow-insecure-unlock",
        "--verbosity", "3"
    ) -RedirectStandardOutput $logFile -PassThru -NoNewWindow
    
    $processes += $proc
    Write-Host "  PID: $($proc.Id)" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "=== All Nodes Started ===" -ForegroundColor Green
Write-Host ""
Write-Host "To connect nodes, get enode from each and use admin.addPeer()" -ForegroundColor Yellow
Write-Host "To stop all nodes: Get-Process geth | Stop-Process" -ForegroundColor Yellow
Write-Host ""
Write-Host "Monitor logs:" -ForegroundColor Yellow
for ($i = 1; $i -le $NodeCount; $i++) {
    Write-Host "  Get-Content validators/node$i.log -Tail 10 -Wait" -ForegroundColor Cyan
}
Write-Host ""
