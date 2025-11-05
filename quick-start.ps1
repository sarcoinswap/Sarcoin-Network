# Sarcoin SRS - Quick Start Guide
# Complete setup and test instructions

Write-Host "=== Sarcoin SRS - Quick Start Guide ===" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow
Write-Host ""

# 1. Check Go
Write-Host "[1] Checking Go installation..." -ForegroundColor Green
try {
    $goVersion = go version
    Write-Host "   ✓ $goVersion" -ForegroundColor Cyan
} catch {
    Write-Host "   ✗ Go not found. Please install Go 1.20 or higher." -ForegroundColor Red
    exit 1
}

# 2. Check GCC
Write-Host "[2] Checking GCC (MinGW) installation..." -ForegroundColor Green
try {
    $gccVersion = gcc --version | Select-Object -First 1
    Write-Host "   ✓ $gccVersion" -ForegroundColor Cyan
} catch {
    Write-Host "   ✗ GCC not found. Please install MSYS2 MinGW-w64." -ForegroundColor Red
    Write-Host "   Install with: winget install MSYS2.MSYS2" -ForegroundColor Yellow
    Write-Host "   Then run: pacman -S mingw-w64-x86_64-gcc" -ForegroundColor Yellow
    Write-Host "   Add to PATH: C:\msys64\mingw64\bin" -ForegroundColor Yellow
    exit 1
}

# 3. Check CGO
Write-Host "[3] Checking CGO status..." -ForegroundColor Green
$cgoEnabled = go env CGO_ENABLED
if ($cgoEnabled -eq "1") {
    Write-Host "   ✓ CGO enabled" -ForegroundColor Cyan
} else {
    Write-Host "   ✗ CGO disabled. Enabling..." -ForegroundColor Yellow
    $env:CGO_ENABLED = "1"
    Write-Host "   ✓ CGO enabled for this session" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "=== Build Status ===" -ForegroundColor Cyan
Write-Host ""

# 4. Check if binary exists
if (Test-Path "build/bin/geth.exe") {
    $binary = Get-Item "build/bin/geth.exe"
    Write-Host "✓ Sarcoin binary found" -ForegroundColor Green
    Write-Host "  Size: $([math]::Round($binary.Length / 1MB, 2)) MB" -ForegroundColor Cyan
    Write-Host "  Modified: $($binary.LastWriteTime)" -ForegroundColor Cyan
    
    # Test binary
    Write-Host ""
    Write-Host "Testing binary..." -ForegroundColor Yellow
    $version = .\build\bin\geth.exe version 2>&1 | Select-String "Version:"
    if ($version) {
        Write-Host "  $version" -ForegroundColor Cyan
    }
} else {
    Write-Host "✗ Binary not found" -ForegroundColor Red
    Write-Host "  Run: go build -o build/bin/geth.exe ./cmd/geth" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Genesis Status ===" -ForegroundColor Cyan
Write-Host ""

# 5. Check testnet genesis
if (Test-Path "genesis-testnet.json") {
    Write-Host "✓ Testnet genesis found" -ForegroundColor Green
} else {
    Write-Host "✗ Testnet genesis not found" -ForegroundColor Red
}

# 6. Check mainnet genesis
if (Test-Path "genesis-mainnet.json") {
    Write-Host "✓ Mainnet genesis found" -ForegroundColor Green
} else {
    Write-Host "✗ Mainnet genesis not found" -ForegroundColor Red
}

# 7. Check if testnet is initialized
if (Test-Path "testnet-data/geth/chaindata") {
    Write-Host "✓ Testnet initialized" -ForegroundColor Green
} else {
    Write-Host "✗ Testnet not initialized" -ForegroundColor Yellow
    Write-Host "  Run: .\build\bin\geth.exe init --datadir ./testnet-data genesis-testnet.json" -ForegroundColor Yellow
}

# 8. Check if mainnet is initialized
if (Test-Path "mainnet-data/geth/chaindata") {
    Write-Host "✓ Mainnet initialized" -ForegroundColor Green
} else {
    Write-Host "✗ Mainnet not initialized" -ForegroundColor Yellow
    Write-Host "  Run: .\build\bin\geth.exe init --datadir ./mainnet-data genesis-mainnet.json" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "To start the testnet node:" -ForegroundColor Green
Write-Host "  .\start-testnet.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "To test RPC (in another terminal):" -ForegroundColor Green
Write-Host "  .\test-rpc.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "Network Information:" -ForegroundColor Green
Write-Host "  Testnet Chain ID: 3901" -ForegroundColor Cyan
Write-Host "  Mainnet Chain ID: 3900" -ForegroundColor Cyan
Write-Host "  Token: SRS (mainnet), tSRS (testnet)" -ForegroundColor Cyan
Write-Host "  Block Time: 1 second" -ForegroundColor Cyan
Write-Host "  RPC: http://127.0.0.1:8545" -ForegroundColor Cyan
Write-Host "  WebSocket: ws://127.0.0.1:8546" -ForegroundColor Cyan
Write-Host ""
