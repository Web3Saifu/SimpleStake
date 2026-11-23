# SimpleStake

An educational ERC-20 staking dApp built one human-approved phase at a time.

The planned application lets users connect MetaMask, approve and stake STK, withdraw their deposits, earn and claim RWD, and view pool/schedule information. It uses one pool, two test tokens, and one dashboard.

## Current state

The local Git repository and Foundry setup are verified. Phase 03 is awaiting owner acceptance. Phase 04 introduces the first Solidity learning contract.

This project is educational, not production-ready or independently audited. Mainnet deployment is excluded.

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
