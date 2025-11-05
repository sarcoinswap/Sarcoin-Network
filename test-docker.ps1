# Sarcoin SRS - Local Docker Test
# Tests Docker deployment locally before cloud deployment

Write-Host "=== Sarcoin Docker Local Test ===" -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "[1/5] Checking Docker..." -ForegroundColor Green
try {
    $dockerVersion = docker --version
    Write-Host "   ✓ $dockerVersion" -ForegroundColor Cyan
} catch {
    Write-Host "   ✗ Docker not found. Install Docker Desktop for Windows." -ForegroundColor Red
    Write-Host "   Download: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Check docker-compose
Write-Host "[2/5] Checking docker-compose..." -ForegroundColor Green
try {
    $composeVersion = docker-compose --version
    Write-Host "   ✓ $composeVersion" -ForegroundColor Cyan
} catch {
    Write-Host "   ✗ docker-compose not found" -ForegroundColor Red
    exit 1
}

# Build image
Write-Host "[3/5] Building Sarcoin Docker image..." -ForegroundColor Green
Write-Host "   This may take 5-10 minutes..." -ForegroundColor Yellow
docker build -f Dockerfile.sarcoin -t sarcoin/node:latest .

if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ Image built successfully" -ForegroundColor Green
} else {
    Write-Host "   ✗ Build failed" -ForegroundColor Red
    exit 1
}

# Check validator addresses
Write-Host "[4/5] Checking validator configuration..." -ForegroundColor Green
if (Test-Path "validators/addresses.txt") {
    $validators = Get-Content "validators/addresses.txt"
    Write-Host "   ✓ Found $($validators.Count) validators" -ForegroundColor Green
    
    # Set first validator as environment variable
    $env:VALIDATOR_ADDRESS = $validators[0]
    Write-Host "   Using validator: $($env:VALIDATOR_ADDRESS)" -ForegroundColor Cyan
} else {
    Write-Host "   ⚠ No validators found. Using default address." -ForegroundColor Yellow
    $env:VALIDATOR_ADDRESS = "0x0000000000000000000000000000000000000001"
}

# Start containers
Write-Host "[5/5] Starting Docker containers..." -ForegroundColor Green
Write-Host "   Starting RPC node..." -ForegroundColor Yellow
docker-compose -f docker-compose.oracle.yml up -d sarcoin-rpc

Start-Sleep -Seconds 5

# Check status
Write-Host ""
Write-Host "=== Container Status ===" -ForegroundColor Cyan
docker-compose -f docker-compose.oracle.yml ps

Write-Host ""
Write-Host "=== Testing RPC ===" -ForegroundColor Cyan
Start-Sleep -Seconds 3

for ($i = 1; $i -le 10; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8545" -Method Post -ContentType "application/json" -Body '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' -ErrorAction Stop
        
        if ($response.result) {
            $chainId = [Convert]::ToInt64($response.result, 16)
            Write-Host "✓ RPC responding! Chain ID: $chainId" -ForegroundColor Green
            break
        }
    } catch {
        if ($i -eq 10) {
            Write-Host "✗ RPC not responding after 10 attempts" -ForegroundColor Red
            Write-Host "Check logs: docker logs sarcoin-rpc" -ForegroundColor Yellow
        } else {
            Write-Host "Attempt $i/10: Waiting for node to start..." -ForegroundColor Gray
            Start-Sleep -Seconds 3
        }
    }
}

Write-Host ""
Write-Host "=== Commands ===" -ForegroundColor Cyan
Write-Host "View logs:" -ForegroundColor Yellow
Write-Host "  docker logs -f sarcoin-rpc" -ForegroundColor White
Write-Host ""
Write-Host "Stop containers:" -ForegroundColor Yellow
Write-Host "  docker-compose -f docker-compose.oracle.yml down" -ForegroundColor White
Write-Host ""
Write-Host "Test RPC:" -ForegroundColor Yellow
Write-Host "  .\test-rpc.ps1" -ForegroundColor White
Write-Host ""
Write-Host "Access container:" -ForegroundColor Yellow
Write-Host "  docker exec -it sarcoin-rpc sh" -ForegroundColor White
Write-Host ""
