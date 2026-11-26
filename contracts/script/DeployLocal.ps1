# Run against a disposable Anvil instance. Use a different port for a fresh-chain rehearsal.
param([ValidateRange(1, 65535)][int]$Port = 8545)

$ErrorActionPreference = 'Stop'
$rpc = "http://127.0.0.1:$Port"
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path

function Read-Cast {
    $output = & cast @args --rpc-url $rpc
    if ($LASTEXITCODE -ne 0) { throw "Cast failed: $($args[0])" }
    ($output -join "`n").Trim()
}

if ((Read-Cast chain-id) -ne '31337' -or (Read-Cast rpc web3_clientVersion) -notmatch 'anvil') {
    throw 'Expected a local Anvil node on chain 31337.'
}
$accounts = (Read-Cast rpc eth_accounts) | ConvertFrom-Json
$sender = $accounts[0]
if ($sender -notmatch '^0x[0-9a-fA-F]{40}$') { throw 'Expected an unlocked Anvil account.' }

Push-Location (Join-Path $root 'contracts')
try {
    & forge script script/DeployTokens.s.sol:DeployTokens --root . --rpc-url $rpc --sender $sender --unlocked --broadcast
    if ($LASTEXITCODE -ne 0) { throw 'Deployment failed. Inspect the broadcast receipts before retrying.' }
    $run = Get-Content 'broadcast/DeployTokens.s.sol/31337/run-latest.json' -Raw | ConvertFrom-Json
    $creates = @($run.transactions | Where-Object { $_.transactionType -eq 'CREATE' -and $_.contractName -eq 'MockERC20' })
    if ($creates.Count -ne 2) { throw 'Expected two token creation transactions.' }
    $tokens = [ordered]@{}
    foreach ($tx in $creates) {
        $receipt = (Read-Cast receipt $tx.hash --json) | ConvertFrom-Json
        $address = $receipt.contractAddress
        if ($receipt.status -ne '0x1' -or $receipt.transactionHash -ne $tx.hash -or $receipt.from -ne $sender -or
            $address -ne $tx.contractAddress -or (Read-Cast code $address) -notmatch '^0x[0-9a-fA-F]{2,}$') {
            throw "Invalid creation receipt or missing runtime code for $($tx.hash)"
        }
        $symbol = (Read-Cast call $address 'symbol()(string)').Trim('"')
        $name = (Read-Cast call $address 'name()(string)').Trim('"')
        $names = @{ STK = 'SimpleStake Token'; RWD = 'SimpleStake Reward' }
        if (!$names.ContainsKey($symbol) -or $tokens.Contains($symbol) -or $name -cne $names[$symbol] -or
            (Read-Cast call $address 'decimals()(uint8)') -ne '18' -or
            (Read-Cast call $address 'totalSupply()(uint256)') -ne '0' -or
            (Read-Cast call $address 'owner()(address)') -ne $sender) {
            throw "Token verification failed for $address"
        }
        $tokens[$symbol] = [ordered]@{ address = $address; transactionHash = $tx.hash; blockHash = $receipt.blockHash }
    }
    if ($tokens.STK.address -eq $tokens.RWD.address) { throw 'Expected distinct addresses.' }
    $record = [ordered]@{ chainId = 31337; owner = $sender; tokens = $tokens }
    $directory = [IO.Directory]::CreateDirectory((Join-Path $root 'deployments'))
    $file = Join-Path $directory.FullName '31337.json'
    $temp = "$file.$PID.tmp"
    try {
        [IO.File]::WriteAllText($temp, ($record | ConvertTo-Json -Depth 4) + [Environment]::NewLine)
        Move-Item -LiteralPath $temp -Destination $file -Force
    } finally {
        if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp }
    }
    Write-Output "Verified both tokens on port $Port and wrote $file"
} finally {
    Pop-Location
}
