# 🚀 Sarcoin SRS - Local Setup Guide

This guide helps you set up and test Sarcoin blockchain locally on Windows.

## 📋 Prerequisites

1. **Go 1.20+** - [Download](https://golang.org/dl/)
2. **MSYS2 + MinGW-w64** - For CGO compilation
3. **Git** - For cloning the repository

### Installing MSYS2 and MinGW-w64

```powershell
# Install MSYS2
winget install MSYS2.MSYS2

# Open MSYS2 terminal and install MinGW-w64
pacman -S mingw-w64-x86_64-gcc

# Add to PATH (in PowerShell)
$env:PATH = "C:\msys64\mingw64\bin;" + $env:PATH

# Enable CGO
$env:CGO_ENABLED = "1"
```

## 🔧 Building Sarcoin

```powershell
# Navigate to project directory
cd "C:\Users\sarco\Desktop\Sarcoin SRS\bsc"

# Apply Prysm BLS patch for Windows compatibility
$file = "C:\Users\sarco\go\pkg\mod\github.com\prysmaticlabs\prysm\v5@v5.3.2\crypto\bls\bls.go"
attrib -r $file
(Get-Content $file -Raw) -replace '[\s\t]*"github\.com/prysmaticlabs/prysm/v5/crypto/bls/herumi"[\s\t]*\r?\n', '' -replace 'herumi\.Init\(\)', '// Herumi Init disabled' | Set-Content $file -NoNewline

# Build the binary
go build -o build/bin/geth.exe ./cmd/geth

# Verify the build
.\build\bin\geth.exe version
```

## 🌍 Initialize Networks

### Testnet (Chain ID: 3901)

```powershell
.\build\bin\geth.exe init --datadir ./testnet-data genesis-testnet.json
```

### Mainnet (Chain ID: 3900)

```powershell
.\build\bin\geth.exe init --datadir ./mainnet-data genesis-mainnet.json
```

## ▶️ Running the Node

### Quick Start

```powershell
# Check system status
.\quick-start.ps1

# Start testnet node
.\start-testnet.ps1
```

### Manual Start

```powershell
.\build\bin\geth.exe `
    --datadir ./testnet-data `
    --networkid 3901 `
    --http `
    --http.addr 127.0.0.1 `
    --http.port 8545 `
    --http.api "eth,net,web3,personal" `
    --mine `
    --miner.etherbase 0x0000000000000000000000000000000000000001 `
    console
```

## 🧪 Testing the Node

In a separate PowerShell terminal:

```powershell
# Run RPC tests
.\test-rpc.ps1

# Or test manually
curl -X POST http://127.0.0.1:8545 `
  -H "Content-Type: application/json" `
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

### Expected Response

```json
{ "jsonrpc": "2.0", "id": 1, "result": "0xf3d" }
```

(0xf3d = 3901 in decimal)

## 📊 Network Information

| Parameter      | Testnet     | Mainnet      |
| -------------- | ----------- | ------------ |
| **Chain ID**   | 3901        | 3900         |
| **Token**      | tSRS        | SRS          |
| **Block Time** | 1 second    | 1 second     |
| **Consensus**  | Parlia PoSA | Parlia PoSA  |
| **Validators** | 6 (genesis) | 11 (genesis) |
| **RPC Port**   | 8545        | 8545         |
| **WS Port**    | 8546        | 8546         |

## 🔑 Validator Configuration

The genesis files contain placeholder validator addresses. For production:

1. Generate real validator keys
2. Update `extraData` in genesis files
3. Re-initialize the network
4. Start nodes with proper BLS keys

### Genesis Validators (Testnet)

- `0x0000000000000000000000000000000000000001`
- `0x0000000000000000000000000000000000000002`
- `0x0000000000000000000000000000000000000003`
- `0x0000000000000000000000000000000000000004`
- `0x0000000000000000000000000000000000000005`
- `0x0000000000000000000000000000000000000006`

## 📝 Useful Scripts

| Script              | Description                           |
| ------------------- | ------------------------------------- |
| `quick-start.ps1`   | Check prerequisites and system status |
| `start-testnet.ps1` | Start testnet node with mining        |
| `test-rpc.ps1`      | Test RPC endpoint functionality       |

## 🐛 Troubleshooting

### Binary exits immediately

- **Cause**: CGO disabled or GCC not in PATH
- **Fix**: Run `$env:CGO_ENABLED="1"` and add MinGW to PATH

### "gcc not found"

- **Fix**: Install MSYS2 MinGW-w64 and add to PATH:
  ```powershell
  $env:PATH = "C:\msys64\mingw64\bin;" + $env:PATH
  ```

### "herumi.Init panic"

- **Cause**: Herumi BLS library incompatible with Windows
- **Fix**: Patch Prysm BLS (see Building section above)

### Node starts but no blocks

- **Cause**: Parlia requires validators
- **Fix**: Use `--mine` flag with `--miner.etherbase`

### RPC connection refused

- **Cause**: Node not running or wrong port
- **Fix**: Check node is running and use correct port (8545)

## 🔄 Next Steps

1. ✅ Local testing complete
2. ⏳ Configure multiple validators
3. ⏳ Deploy to cloud infrastructure
4. ⏳ Set up block explorer
5. ⏳ Create faucet for testnet
6. ⏳ Deploy system contracts
7. ⏳ Mainnet launch preparation

## 📚 Additional Resources

- **Sarcoin Network Info**: European blockchain for everyone
- **BSC Documentation**: [docs.bnbchain.org](https://docs.bnbchain.org)
- **Parlia Consensus**: BFT + PoSA hybrid
- **Block Time**: 1 second (faster than BSC's 3s)

## 🆘 Support

For issues or questions:

1. Check this README
2. Review troubleshooting section
3. Check genesis file configuration
4. Verify environment variables (CGO_ENABLED, PATH)

---

**Sarcoin Network** - The European Blockchain Built for Everyone 🇪🇺
