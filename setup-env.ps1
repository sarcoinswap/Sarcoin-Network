# Sarcoin SRS - Environment Configuration
# Add this to your PowerShell profile or run manually

# Add MinGW-w64 to PATH
$env:PATH = "C:\msys64\mingw64\bin;" + $env:PATH

# Enable CGO for Go compilation
$env:CGO_ENABLED = "1"

# Set working directory
Set-Location "C:\Users\sarco\Desktop\Sarcoin SRS\bsc"

Write-Host "✓ Sarcoin environment configured" -ForegroundColor Green
Write-Host "  - MinGW-w64 GCC: Available" -ForegroundColor Cyan
Write-Host "  - CGO: Enabled" -ForegroundColor Cyan
Write-Host "  - Working Directory: $(Get-Location)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available commands:" -ForegroundColor Yellow
Write-Host "  .\quick-start.ps1     - Check system status" -ForegroundColor White
Write-Host "  .\start-testnet.ps1   - Start testnet node" -ForegroundColor White
Write-Host "  .\test-rpc.ps1        - Test RPC endpoint" -ForegroundColor White
Write-Host ""
