# Sarcoin SRS - Validator Account Generator
# Creates multiple validator accounts for the network

param(
    [int]$Count = 3,
    [string]$Password = "validator123"
)

Write-Host "=== Sarcoin Validator Generator ===" -ForegroundColor Cyan
Write-Host ""

# Check if geth exists
if (-not (Test-Path "build/bin/geth.exe")) {
    Write-Host "ERROR: geth.exe not found" -ForegroundColor Red
    exit 1
}

# Create validator directory
$validatorDir = "./validators"
if (-not (Test-Path $validatorDir)) {
    New-Item -ItemType Directory -Path $validatorDir | Out-Null
    Write-Host "✓ Created validators directory" -ForegroundColor Green
}

# Create password file
$passwordFile = "$validatorDir/password.txt"
$Password | Out-File -FilePath $passwordFile -Encoding ASCII -NoNewline

Write-Host "Generating $Count validator accounts..." -ForegroundColor Yellow
Write-Host ""

$validators = @()

for ($i = 1; $i -le $Count; $i++) {
    Write-Host "[$i/$Count] Creating validator account..." -ForegroundColor Green
    
    $datadir = "$validatorDir/validator$i"
    
    # Create account
    $output = .\build\bin\geth.exe account new --datadir $datadir --password $passwordFile 2>&1
    
    # Extract address
    $address = $output | Select-String "Public address of the key:" | ForEach-Object { 
        $_.ToString() -replace ".*Public address of the key:\s*", "" 
    }
    
    if (-not $address) {
        $address = $output | Select-String "0x[a-fA-F0-9]{40}" | ForEach-Object {
            if ($_ -match "(0x[a-fA-F0-9]{40})") { $matches[1] }
        } | Select-Object -First 1
    }
    
    if ($address) {
        Write-Host "   Address: $address" -ForegroundColor Cyan
        $validators += $address
        
        # Find keystore file
        $keystoreFile = Get-ChildItem -Path "$datadir/keystore" -File | Select-Object -First 1
        if ($keystoreFile) {
            Write-Host "   Keystore: $($keystoreFile.Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ERROR: Failed to extract address" -ForegroundColor Red
    }
    Write-Host ""
}

# Save validator addresses
$validatorListFile = "$validatorDir/addresses.txt"
$validators | Out-File -FilePath $validatorListFile -Encoding ASCII

Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "✓ Created $($validators.Count) validator accounts" -ForegroundColor Green
Write-Host "✓ Addresses saved to: $validatorListFile" -ForegroundColor Green
Write-Host "✓ Password: $Password (saved in $passwordFile)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Validator Addresses:" -ForegroundColor Yellow
$validators | ForEach-Object { Write-Host "  $_" -ForegroundColor Cyan }
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Copy these addresses to genesis extraData" -ForegroundColor White
Write-Host "2. Re-initialize the network with updated genesis" -ForegroundColor White
Write-Host "3. Start nodes with these validator accounts" -ForegroundColor White
Write-Host ""
