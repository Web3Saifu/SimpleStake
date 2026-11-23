# SimpleStake: goals and requirements

## Purpose

Build and understand a minimal educational ERC-20 staking dApp, one verified milestone at a time. The owner should be able to explain and direct the architecture, implementation, integration, testing, and deployment process.

## Product scope

One staking pool, two ordinary ERC-20 test tokens (STK and RWD), and one responsive dashboard. Users connect MetaMask, read STK balances, approve transfers, stake, withdraw, view and claim RWD rewards, and inspect total deposits and the reward schedule.

Exclude backend servers, databases, lending, borrowing, DEX functions, governance, NFTs, oracles, upgradeable proxies, compounding, and mainnet deployment. Fee-on-transfer and rebasing tokens are unsupported.

## Architecture and responsibilities

```text
User -> React dashboard -> wagmi / viem
                           |-- reads -> RPC -> blockchain
                           |-- transaction request -> MetaMask -> RPC -> blockchain

Blockchain: STK token + StakingPool + RWD token
TanStack Query: cached frontend reads and refresh coordination
Foundry scripts: deployment -> public addresses and compiled ABIs -> frontend configuration
```

| Component | Responsibility |
| --- | --- |
| MockERC20.sol, deployed twice | ERC-20 balances, transfers, allowances, and narrowly scoped owner-only test minting. |
| StakingPool.sol | Individual and total deposits, withdrawals, reward accounting, one reward schedule, claims, events, and errors. |
| React frontend | Inputs, presentation, wallet/network state, transaction progress, and refresh handling. |
| MetaMask | Account access and user-controlled transaction signing. |
| RPC endpoint | Communication with a blockchain node. |
| Deployment artifacts | Public chain IDs, addresses, and contract interfaces; no secrets. |

Blockchain state is authoritative for funds and entitlements. Frontend state contains temporary inputs and UI state; cached reads are snapshots, not a second ledger. No backend or database is required for this scope.

## Planned stack

- Contracts: Solidity, Foundry (Forge, Anvil, Cast), OpenZeppelin Contracts.
- Frontend: React, TypeScript, Vite, wagmi, viem, TanStack Query, plain CSS.
- Development: Git, npm, supported Node.js LTS; GitHub when authorized.
- Networks: local Anvil first, Ethereum Sepolia only after separate approval.

The Phase 02 version baseline and compatibility evidence are in [README.md](README.md). Apply the selected pins and retain lockfiles as the contract and frontend projects are initialized. Verify full dependency resolution and builds in those milestones.

## Functional requirements

| ID | Requirement |
| --- | --- |
| FR-01 | Connect MetaMask, handle account/network changes, and validate the selected chain. |
| FR-02 | Display STK wallet balance using token units accurately. |
| FR-03 | Check allowance and request approval to the configured spender before staking. |
| FR-04 | Deposit STK and record each user's balance and total pool deposits. |
| FR-05 | Withdraw the caller's own deposited principal without lockup or penalty. |
| FR-06 | Activate one fixed-duration, pre-funded RWD schedule using authorized access. |
| FR-07 | Accrue rewards according to stake and elapsed time using reward-per-token accounting. |
| FR-08 | Display and claim earned RWD without double payment. |
| FR-09 | Display total deposits and reward schedule information. |
| FR-10 | Distinguish wallet rejection, submission, pending confirmation, reversion, success, and refresh failure. |

## Business policies

- Deploy MockERC20 twice with 18 decimals and distinct addresses for STK and RWD. Restrict test minting to the token owner.
- Principal-only staking comes first in Phase 12. Phase 14 introduces reward accounting and schedule restrictions using fresh local deployments.
- Pre-fund rewards before activation. Activate once; do not restart or extend the schedule.
- In the final reward-enabled contract, accept new stakes only during the active schedule. Before activation and at/after expiration, reject new stakes.
- Preserve withdrawals and earned reward claims after expiration. Do not impose a claim deadline.
- Update reward accounting before changing individual or total stake. Cap elapsed reward time at schedule expiration.
- Rewards associated with zero-total-stake intervals remain undistributed; later stakers cannot receive them retroactively.
- Leave undistributed rewards, integer-division remainders, and rounding leftovers in the pool. This version has no administrative recovery function.
- Do not allow the owner to arbitrarily withdraw user deposits.
- Validate amounts, balances, and authorization. Final error/function naming and exact reward arithmetic will be specified in their implementation phases.
- Numerical reward duration and budget are not selected yet. Phase 14 will define configuration constraints, including invalid duration and zero-emission cases.

## User and data flows

Read: selected chain/address/account -> RPC contract read -> integer result -> formatted display. Reads require no transaction signature.

Stake: input -> bigint base units -> allowance check -> approval transaction if needed -> confirmed successful approval -> stake transaction -> receipt check -> refresh wallet balance, allowance, and pool state. Approval grants permission; it does not deposit tokens.

Withdraw/claim: validate input and configuration -> user signs -> transaction is submitted -> receipt confirms success or failure -> refresh affected reads. A transaction hash alone does not prove success. If refresh fails after success, preserve confirmed status and offer a refresh retry rather than encouraging a duplicate transaction.

## Interface requirements

Use approximately 60% black, 30% purple (light and deep shades), and 10% white by visual emphasis. Choose exact shades during frontend development. Preserve readable contrast and use text as well as color for status.

Show wallet/network status, wallet STK, deposited STK, earned RWD, allowance/approval controls, stake/withdraw/claim actions, total deposits, and schedule information. Support smaller screens and clearly label amounts and transaction states.

## Security and non-functional requirements

- Pool STK holdings must cover total recorded deposits, and users cannot withdraw another user's principal.
- Claims and outstanding reward entitlements must remain bounded by allocated funding; reward accounting must not double-pay.
- Use integer arithmetic and frontend bigint; test rounding, elapsed time, multiple users, expiration, and empty-pool periods.
- Use SafeERC20, appropriate access control, reentrancy protection, and checks-effects-interactions where applicable.
- Validate security-sensitive operations in contracts even if frontend checks are bypassed.
- Verify deployed bytecode, network IDs, addresses, and ABIs before integration. Redeployment requires configuration refresh.
- Keep secrets out of frontend configuration, documentation, Git, and public artifacts.
- Maintain reproducible builds/tests and evidence-backed verification; keep implementation simple and readable.

## Final completion evidence

Demonstrate the full local wallet-to-contract flow, relevant automated contract tests including fuzz/invariants, frontend checks/build, and documented manual verification. Perform Sepolia checks only after separate approval. Record limitations and unresolved issues; never label the application independently audited or production-ready.

See [PLANS.md](PLANS.md) for sequencing and [LEARNING_LOG.md](LEARNING_LOG.md) for actual progress.
