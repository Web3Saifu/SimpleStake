# SimpleStake

An educational ERC-20 staking dApp built one human-approved phase at a time.

The planned application lets users connect MetaMask, approve and stake STK, withdraw their deposits, earn and claim RWD, and view pool/schedule information. It uses one pool, two test tokens, and one dashboard.

## Current state

The owner accepted Phase 08 after the React stake draft passed build and browser checks. The public [deployment record](deployments/31337.json) identifies the local Anvil token pair used in Phase 07.

This project is educational, not production-ready or independently audited. Mainnet deployment is excluded.

## Run the frontend

Phase 09 adds MetaMask connection controls for local Anvil (chain ID 31337). The production build and missing-wallet message were verified. Connection and network switching still need browser verification.

From the repository root in PowerShell:

```powershell
cd frontend
npm ci
npm run dev -- --host 127.0.0.1
```

Open the URL Vite prints. Type `12.50` and click **Clear amount**. The input event updates React state and the preview receives the draft through its `amount` prop. Refreshing the page clears the draft. Run `npm run build` for the TypeScript check and production bundle.

## Start here

| Document | Read it to understand |
| --- | --- |
| [GOALS.md](GOALS.md) | Requirements, business rules, architecture, scope, and security boundaries. |
| [PLANS.md](PLANS.md) | The 20 phases, dependencies, acceptance criteria, and progress. |
| [AGENTS.md](AGENTS.md) | How the AI should work and which actions need approval. |
| [LEARNING_LOG.md](LEARNING_LOG.md) | Actual decisions, verification evidence, and learning status. |

## Planned architecture and stack

React/TypeScript/Vite dashboard -> wagmi/viem -> RPC reads or MetaMask-signed transactions -> STK, StakingPool, and RWD contracts.

TanStack Query coordinates cached reads. Solidity, Foundry, and OpenZeppelin support contract development and testing. Anvil provides the local chain; Sepolia deployment requires separate approval. No backend server or database is needed. Use plain CSS with 60% black, 30% light/deep purple, and 10% white.

## Development versions

| Tool | Observed | Project baseline |
| --- | --- | --- |
| Git for Windows | `2.50.1.windows.1` | Retain for local Git setup |
| Forge, Anvil, Cast | `1.7.1`, commit `4072e48705af9d93e3c0f6e29e93b5e9a40caed8` | Retain [Foundry 1.7.1](https://github.com/foundry-rs/foundry/releases/tag/v1.7.1) |
| Node.js and npm | `22.17.1` and `10.9.2` | Installed pair meets the declared Vite engine range. Target [Node 22.23.5 LTS](https://nodejs.org/en/blog/release/v22.23.5) with [bundled npm 10.9.9](https://raw.githubusercontent.com/nodejs/node/v22.23.5/deps/npm/package.json) before frontend setup, pending approval for that installation. |

| Dependency | Exact selection | Source |
| --- | --- | --- |
| Solidity | `0.8.39` | [Compiler release](https://github.com/argotorg/solidity/releases/tag/v0.8.39) |
| OpenZeppelin Contracts | `5.7.0` | [Library release](https://github.com/OpenZeppelin/openzeppelin-contracts/releases/tag/v5.7.0) |
| Forge Standard Library | `1.17.0` | [forge-std release](https://github.com/foundry-rs/forge-std/releases/tag/v1.17.0) |
| React and React DOM | `19.3.1` each | [React release](https://github.com/react/react/releases/tag/v19.3.1), [React DOM manifest](https://raw.githubusercontent.com/react/react/v19.3.1/packages/react-dom/package.json) |
| TypeScript | `7.0.2` | [Published manifest](https://registry.npmjs.org/typescript/latest), [Vite React/TS template](https://raw.githubusercontent.com/vitejs/vite/v8.3.8/packages/create-vite/template-react-ts/package.json) |
| Vite | `8.3.8` | [Release manifest](https://raw.githubusercontent.com/vitejs/vite/v8.3.8/packages/vite/package.json) |
| Vite React plugin | `6.3.0` | [Release manifest](https://raw.githubusercontent.com/vitejs/vite-plugin-react/plugin-react%406.3.0/packages/plugin-react/package.json) |
| React and React DOM types | `19.3.0` each as template-derived pins to confirm at install | [Vite React/TS template](https://raw.githubusercontent.com/vitejs/vite/v8.3.8/packages/create-vite/template-react-ts/package.json) |
| wagmi | `3.7.11` | [Peer requirements](https://raw.githubusercontent.com/wevm/wagmi/wagmi%403.7.11/packages/react/package.json) |
| viem | `2.58.4` | [Release manifest](https://raw.githubusercontent.com/wevm/viem/viem%402.58.4/src/package.json) |
| TanStack React Query | `5.108.3` | [Release](https://github.com/TanStack/query/releases/tag/release-2026-11-22-2009), [React compatibility](https://tanstack.com/query/latest/docs/framework/react/installation) |

Vite and its React plugin require Node `^20.19.0 || >=22.12.0`. Wagmi declares React `>=18`, TypeScript `>=5.9.3`, viem `2.x`, and TanStack React Query `>=5.0.0`. The chosen direct versions satisfy those ranges. Solidity 0.8.39 satisfies the `^0.8.20` pragma on the planned OpenZeppelin ERC20, Ownable, SafeERC20, and ReentrancyGuard modules. Full dependency resolution and builds will be checked as the packages are introduced.

Apply the compiler and contract library pins in Phase 03, the UI tooling and types in Phase 08, and the wallet libraries in Phase 09. Keep the Foundry dependencies at recorded Git revisions and commit the frontend npm lockfile when Git operations are authorized.

## Contract workspace

| Path | Purpose |
| --- | --- |
| `contracts/foundry.toml` | Pins the Solidity compiler and maps imports to the installed libraries. |
| `contracts/src/` and `contracts/script/` | Application contracts and deployment scripts as those phases introduce them. |
| `contracts/test/Setup.t.sol` | Checks that Foundry resolves and uses both pinned libraries. |
| `contracts/lib/` | Git submodules for forge-std and OpenZeppelin. |

The forge-std `v1.17.0` pin is `f3dae6e6ee381f25eb6a246f7da9b85c91a68219`. The OpenZeppelin `v5.7.0` pin is `cab19933c33c2ad1d4c7a84864a3601dddfd16f3`.

From the repository root, run:

```powershell
git submodule status
forge build --root contracts
forge test --root contracts
forge fmt --root contracts --check
```

In a fresh checkout after the submodule pins are committed, run `git submodule update --init` first. Forge downloads the pinned compiler when it is missing. Build output, caches, and local `.env` files are excluded by the root `.gitignore`.

## Phase 04 exercise

[LearningCounter.sol](contracts/test/helpers/LearningCounter.sol) stores one count per address. `increment()` increases the caller's count, and the public mapping gives Solidity a `counts(address)` getter. The example lives under `contracts/test/` for local exercises.

Run the caller isolation test from the repository root:

```powershell
forge test --root contracts --match-test test_CallerCountsStaySeparate -vvvv
```

In [LearningCounter.t.sol](contracts/test/LearningCounter.t.sol), add a third caller to the isolation test. Predict all three counts before running it again. Each `vm.prank(address)` sets `msg.sender` for the next call.

## Phase 05 test token

[MockERC20.sol](contracts/src/MockERC20.sol) takes a name, symbol, and initial owner. Each instance starts with zero supply and uses OpenZeppelin's 18 decimals, transfers, and allowances. The owner can call `mint(to, amount)` to increase the recipient's balance and total supply. Phase 06 will use this constructor to deploy STK and RWD separately on Anvil.

Run the delegated transfer exercise from the repository root:

```powershell
forge test --root contracts --match-test test_TransferFromUsesAllowanceAndMovesBalance -vvvv
```

In [MockERC20.t.sol](contracts/test/MockERC20.t.sol), trace Alice's approval and the spender's transfer. Alice starts with 10 STK and approves 4 STK. Predict Alice's balance, Bob's balance, and the remaining allowance after the spender transfers 3 STK to Bob. In these tests, `1 ether` is Solidity shorthand for `10**18` base units, used here to represent one 18-decimal token.

## Phase 06 local deployment

Anvil exposes a local blockchain through an RPC URL. For a fresh deployment, start a disposable node in one PowerShell terminal:

```powershell
anvil --host 127.0.0.1 --port 8545 --chain-id 31337 --quiet
```

In a second terminal, from the repository root:

```powershell
$env:NO_PROXY = '127.0.0.1,localhost'
.\contracts\script\DeployLocal.ps1 -Port 8545
```

The helper checks the node and chain ID, then uses Anvil's first unlocked account to broadcast two contract creations. This disposable account pays gas in local test ETH and owns both tokens. The Solidity script supplies a different name and symbol to each constructor. A receipt records whether the transaction succeeded, which contract address was created, and how much gas it used.

The helper checks the receipts, runtime code, token metadata, owner, and zero initial supplies before replacing the JSON record. Running it again deploys another pair. Restarting an in-memory node clears its state. Use a fresh node on another port to repeat the exercise and expect the record to describe the most recent verified run.

To inspect the existing deployment without creating another one:

```powershell
$rpc = 'http://127.0.0.1:8545'
$deployment = Get-Content deployments/31337.json -Raw | ConvertFrom-Json
cast chain-id --rpc-url $rpc
cast receipt $deployment.tokens.STK.transactionHash --rpc-url $rpc
cast call $deployment.tokens.RWD.address 'symbol()(string)' --rpc-url $rpc
```

Keep Anvil bound to loopback. Use its unlocked development accounts only on disposable local chains.

## Phase 07 — Follow STK with Cast

On the verified local chain, account 0 owns the tokens, account 1 is Alice, and account 2 is Bob. The owner mints 10 STK to Alice. Alice sends Bob 2 STK and approves him to spend 3 STK. Bob then uses `transferFrom` to move 1 STK from Alice to himself. The units passed to Cast are integers: one STK is 10^18 base units.

### Manual walkthrough in PowerShell

Open PowerShell in the project and check the disposable local node. The expected results are chain ID `31337` and a client string containing `anvil`.

```powershell
Set-Location 'E:\FY2\Staking'
$env:NO_PROXY = '127.0.0.1,localhost'
$rpc = 'http://127.0.0.1:8545'
cast chain-id --rpc-url $rpc
cast rpc web3_clientVersion --rpc-url $rpc
```

If the connection is refused, open a second terminal and run `anvil --host 127.0.0.1 --port 8545 --chain-id 31337 --quiet`. Leave that terminal running. Back in the project terminal, run `.\contracts\script\DeployLocal.ps1` once on the fresh chain, then repeat the two checks above.

Read the public STK address and choose the local accounts. Account 0 owns the token, account 1 plays Alice, and account 2 plays Bob. Check that the code starts with `0x` followed by bytes, the symbol is STK, and the reported owner matches account 0. If any check fails, stop and verify the deployment before sending.

```powershell
$d = Get-Content deployments/31337.json -Raw | ConvertFrom-Json
$stk = $d.tokens.STK.address
$accounts = cast rpc eth_accounts --rpc-url $rpc | ConvertFrom-Json
$owner, $alice, $bob = $accounts[0..2]
cast code $stk --rpc-url $rpc
cast call $stk 'symbol()(string)' --rpc-url $rpc
cast call $stk 'owner()(address)' --rpc-url $rpc
$owner
```

Take a starting snapshot, then repeat these four reads after **each** send. Cast returns token amounts in base units. For this 18-decimal token, `1000000000000000000` means 1 STK.

```powershell
cast call $stk 'balanceOf(address)(uint256)' $alice --rpc-url $rpc
cast call $stk 'balanceOf(address)(uint256)' $bob --rpc-url $rpc
cast call $stk 'allowance(address,address)(uint256)' $alice $bob --rpc-url $rpc
cast call $stk 'totalSupply()(uint256)' --rpc-url $rpc
```

Run **one transaction at a time**. Wait for a successful receipt (`status 1`) before continuing. Each send changes local chain state, including on a repeat run. The `--from` address is the caller. With `--unlocked`, the local Anvil node signs for that account.

```powershell
# 1. Owner mints 10 STK. Alice's balance and total supply each increase by 10.
cast send $stk 'mint(address,uint256)' $alice (cast to-wei 10) --from $owner --unlocked --rpc-url $rpc

# 2. Alice sends 2 STK to Bob. Check both balances.
cast send $stk 'transfer(address,uint256)' $bob (cast to-wei 2) --from $alice --unlocked --rpc-url $rpc

# 3. Alice sets Bob's allowance to 3 STK. Check allowance and both balances.
cast send $stk 'approve(address,uint256)' $bob (cast to-wei 3) --from $alice --unlocked --rpc-url $rpc

# 4. Bob spends 1 of Alice's STK and receives it himself. Allowance falls to 2.
cast send $stk 'transferFrom(address,address,uint256)' $alice $bob (cast to-wei 1) --from $bob --unlocked --rpc-url $rpc
```

Finally, simulate Bob trying to spend 3 STK. This read-only simulation should revert with `ERC20InsufficientAllowance` (selector `0xfb8f41b2`). Repeat the four reads to see that the simulation preserved the final state.

```powershell
cast call $stk 'transferFrom(address,address,uint256)(bool)' $alice $bob (cast to-wei 3) --from $bob --rpc-url $rpc
```

**Inspect the result.** Run these reads from the repository root in PowerShell while the Phase 07 node is running:

```powershell
$rpc = 'http://127.0.0.1:8545'
$d = Get-Content deployments/31337.json -Raw | ConvertFrom-Json
$accounts = cast rpc eth_accounts --rpc-url $rpc | ConvertFrom-Json
cast call $d.tokens.STK.address 'balanceOf(address)(uint256)' $accounts[1] --rpc-url $rpc
cast call $d.tokens.STK.address 'balanceOf(address)(uint256)' $accounts[2] --rpc-url $rpc
cast call $d.tokens.STK.address 'allowance(address,address)(uint256)' $accounts[1] $accounts[2] --rpc-url $rpc
```

**Replay the exercise.** Each replay mints another 10 local STK and performs four transactions. For the original zero baseline use the fresh deployment procedure above. Use PowerShell 7. The checks below compare each change with the observed starting state.

<details>
<summary>PowerShell commands and receipt checks</summary>

```powershell
$ErrorActionPreference = 'Stop'
$env:NO_PROXY = '127.0.0.1,localhost'
$rpc = 'http://127.0.0.1:8545'
function Invoke-Cast {
    $result = & cast @args --rpc-url $rpc
    if ($LASTEXITCODE -ne 0) { throw "Cast failed during $($args[0]). Inspect the last receipt before retrying." }
    ($result -join "`n").Trim()
}
$d = Get-Content deployments/31337.json -Raw | ConvertFrom-Json
if ((Invoke-Cast chain-id) -ne '31337' -or $d.chainId -ne 31337 -or (Invoke-Cast rpc web3_clientVersion) -notmatch 'anvil') { throw 'Expected local Anvil.' }
$accounts = (Invoke-Cast rpc eth_accounts) | ConvertFrom-Json
$owner, $alice, $bob = $accounts[0..2]
if ($owner -ne $d.owner) { throw 'Unexpected token owner.' }
foreach ($symbol in 'STK','RWD') {
    $token = $d.tokens.$symbol
    $receipt = (Invoke-Cast receipt $token.transactionHash --json) | ConvertFrom-Json
    if ($receipt.status -ne '0x1' -or $receipt.blockHash -ne $token.blockHash -or $receipt.contractAddress -ne $token.address -or
        (Invoke-Cast code $token.address) -notmatch '^0x[0-9a-fA-F]{2,}$' -or
        (Invoke-Cast call $token.address 'owner()(address)') -ne $owner -or
        (Invoke-Cast call $token.address 'symbol()(string)').Trim('"') -cne $symbol) { throw "Deployment mismatch for $symbol." }
}
$stk = $d.tokens.STK.address
function Read-Amount {
    $raw = Invoke-Cast call $stk @args
    [bigint]::Parse(($raw -split '\s+')[0])
}
function Read-State {
    @(Read-Amount 'balanceOf(address)(uint256)' $alice
      Read-Amount 'balanceOf(address)(uint256)' $bob
      Read-Amount 'allowance(address,address)(uint256)' $alice $bob
      Read-Amount 'totalSupply()(uint256)')
}
function Send-Token($sender, $signature, $arguments) {
    $receipt = (Invoke-Cast send --unlocked --from $sender $stk $signature @arguments --json) | ConvertFrom-Json
    if ($receipt.status -ne '0x1' -or $receipt.from -ne $sender -or $receipt.to -ne $stk) { throw 'Unexpected receipt.' }
    Write-Host "$signature  $($receipt.transactionHash)"
}
function Check-State($expected) {
    $actual = Read-State
    if (($actual -join ',') -ne ($expected -join ',')) { throw "Unexpected token state: $actual" }
    Write-Host "Alice, Bob, allowance, supply (base units): $actual"
}
$unit = [bigint]::Pow(10,18)
$a, $b, $allowance, $supply = Read-State
Write-Host "Initial state: $a $b $allowance $supply"
Send-Token $owner 'mint(address,uint256)' @($alice, (10*$unit))
Check-State @(($a+10*$unit), $b, $allowance, ($supply+10*$unit))
Send-Token $alice 'transfer(address,uint256)' @($bob, (2*$unit))
Check-State @(($a+8*$unit), ($b+2*$unit), $allowance, ($supply+10*$unit))
Send-Token $alice 'approve(address,uint256)' @($bob, (3*$unit))
Check-State @(($a+8*$unit), ($b+2*$unit), (3*$unit), ($supply+10*$unit))
Send-Token $bob 'transferFrom(address,address,uint256)' @($alice, $bob, $unit)
$final = @(($a+7*$unit), ($b+3*$unit), (2*$unit), ($supply+10*$unit))
Check-State $final
# eth_call simulates Bob attempting to spend 3 more STK. Capture the expected error.
$PSNativeCommandUseErrorActionPreference = $false
$failure = & cast call --from $bob $stk 'transferFrom(address,address,uint256)(bool)' $alice $bob (3*$unit) --rpc-url $rpc 2>&1
$exitCode = $LASTEXITCODE
if ($exitCode -eq 0 -or ($failure -join ' ') -notmatch 'ERC20InsufficientAllowance|fb8f41b2') { throw "Unexpected simulation result: $failure" }
Write-Host "Expected insufficient allowance: $failure"
Check-State $final
```

</details>

## Read the current documents

In PowerShell:

```powershell
Set-Location -LiteralPath 'E:\FY2\Staking'
git --version
node --version
npm --version
forge --version
anvil --version
cast --version
Get-Content -LiteralPath '.\GOALS.md' -Encoding UTF8
Get-Content -LiteralPath '.\PLANS.md' -Encoding UTF8
```

These commands report tool versions and display the project plans. Application setup, development, test, and build commands will be added as they are verified.

## Working agreement

Plan -> explicit phase approval -> implementation -> verification and learning -> explicit acceptance. The next phase requires a separate instruction. The owner can invoke `P` to authorize the documented learning-commit/private-GitHub workflow; no such operation has occurred yet.

Never place private keys or seed phrases in project documents, frontend variables, or public artifacts. Keep wallet signing user-controlled and use only disposable local accounts or a separate testnet wallet.
