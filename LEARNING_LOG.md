# SimpleStake: learning and evidence log

Use this file to record observed work and decisions. Planned behavior is not implemented behavior. Concepts introduced are not automatically concepts mastered. Dates use Asia/Dhaka.

## Phase 00: specification

- Planning delivered in chat on 2026-11-16 and finalized on 2026-11-22.
- Defined one pool, STK/RWD test tokens, a frontend-only dashboard, local Anvil development, and separately approved Sepolia deployment.
- Confirmed palette: 60% black, 30% purple using light/deep shades, 10% white.
- Specified pre-funded rewards, one activation, no principal lockup/penalty, zero-stake handling, retained leftovers, and post-expiration withdrawals/claims.
- Introduced component responsibilities, on-chain versus frontend state, reads versus signed transactions, allowance versus deposit, and transaction submission versus confirmation.
- No application code was created, and no compilation or tests were run in Phase 00.
- Explicit phase acceptance: not recorded.
- Owner answers/reflections: not supplied; understanding remains unverified.

## Phase 01: project context documents — 2026-11-23

### Authorization and inspection

- Owner explicitly approved Phase 01 and clarified that `E:\FY2\Staking` is the project folder, not an input file.
- Immediately before implementation, `Get-ChildItem -LiteralPath 'E:\FY2\Staking' -Force | Select-Object Mode,Length,Name` returned no entries.
- Used the original brief and decisions in the current conversation as source context.

### Work and decisions

- Created AGENTS.md, GOALS.md, PLANS.md, LEARNING_LOG.md, and README.md.
- Separated operating rules, product requirements, phased acceptance, observed evidence, and reader navigation.
- Preserved the owner's P shortcut for an authorized learning commit/private GitHub workflow. It has not been invoked in this phase.
- Recorded Phase 00's acceptance as unrecorded, Phase 01's implementation approval as explicit, and future phases as unstarted.
- Kept versions unknown until Phase 02 and setup commands unavailable until their tooling is introduced and verified.
- No application code, dependency installation, Git initialization, commit, push, or deployment performed.

### Verification

- Read all five files back with `Get-Content -LiteralPath <document> -Encoding UTF8` in a PowerShell loop; command exited successfully.
- Ran a read-only PowerShell check using `Get-Content`, `Test-Path`, regex matching, and `Get-ChildItem`. It verified five nonempty documents, 11 resolving local Markdown links, phases 00-19 once each in order, and exactly five workspace entries. Result: PASS, exit code 0.
- Reviewed content for consistent scope, reward policies, stack, palette, phase gates, security rules, P authorization, and honest status. No inconsistencies requiring changes remained after review.
- Application tests: not applicable; no application exists yet.
- Builds/type checks/lint: not applicable; no toolchain initialized.

### Learning

Introduced Markdown project documentation, persistent project context, acceptance criteria, and the difference between requirements and verification evidence.

Hands-on review: read README, trace GOALS requirement FR-05 to PLANS phases 12/13, and find AGENTS' phase approval rule. Use the PowerShell read commands in README or open the files directly.

Conceptual questions for the owner:

1. Which document defines what SimpleStake must do?
2. Which document records actual test results rather than planned tests?
3. Does approving Phase 01 authorize implementation of Phase 02?

Owner answers are pending and will be recorded separately from document verification.

Owner reflections: awaiting owner input. Understanding: not verified. Phase acceptance: awaiting explicit owner acceptance after review.

Suggested commit message, not executed: `docs: establish SimpleStake scope, phase roadmap, and learning workflow`.

## Phase 02: development environment

- The owner explicitly approved the Phase 02 plan. Phase 00 and Phase 01 acceptance remain unrecorded.
- Ran `git --version`, `node --version`, `npm --version`, `forge --version`, `anvil --version`, and `cast --version`. All six reported versions. All three Foundry tools reported the same release commit.
- The terminal could not resolve the npm registry hostname for metadata. Used publisher release pages, tagged manifests, and official documentation through the browser tool instead. The direct dependency selections and declared version constraints are recorded in [README.md](README.md).
- Existing Node meets the declared Vite requirements. Selected the Node 22.23.5 security release with its bundled npm as the frontend target, pending separate installation approval. No tools were installed or upgraded.
- No contract build, npm dependency resolution, frontend build, or wallet check was performed. Those checks belong to the phases that introduce the corresponding code. Confirm the React type package pins at install, since the Vite template declares version ranges.
- Learning exercise: run the version commands in README and compare Node's reported version with Vite's minimum on the Node 22 line.
- Review questions: What does pinning a dependency do? Which Foundry tool runs a local blockchain? What does a successful version check establish before we run a build?
- The owner explicitly accepted Phase 02 with `ACCEPT PHASE 02`. Learning answers remain pending. Suggested commit message: `docs: record SimpleStake toolchain and dependency versions`.

## Phase 03: Git and Foundry setup

- The owner approved the Phase 03 plan. Initialized the root repository on `main` with `git init -b main` and created the nested scaffold with `forge init --empty --offline --no-git contracts`.
- Forge's installer failed to resolve the nested library path relative to the Git root. Used Git directly from the workspace root. The OpenZeppelin full clone and first tag-only fetch stalled. An HTTP/1.1 tag-only retry succeeded. Verified both exact tag revisions with `git submodule status`; pins are in README. The submodule entries are staged locally.
- Forge's first compiler download failed on DNS inside the sandbox. The approved download succeeded, and after both libraries were present `forge build --root contracts` compiled 23 files with Solidity 0.8.39.
- `forge test --root contracts`: 1 passed, 0 failed, 0 skipped. `forge fmt --root contracts --check`: passed. Forge reported a nonfatal warning while writing its signature cache outside the workspace.
- `git rev-parse --show-toplevel` reported `E:/FY2/Staking`. `git check-ignore` matched sample output, cache, broadcast, and local environment paths.
- Learning exercise: run `git submodule status` and `forge test --root contracts`, then trace the OpenZeppelin import in Setup.t.sol through the remapping in foundry.toml.
- The owner explicitly accepted Phase 03 with `ACCEPT PHASE 03` on 2026-11-24. Learning responses remain pending.

## Phase 04: per-address Solidity counter

- The owner approved the Phase 04 plan. Added a test-only counter and tests. Solidity's `mapping(address => uint256)` defaults to zero for each address. The public mapping generates a getter and `increment()` writes to the caller's entry using `msg.sender`.
- Ran `forge test --root contracts --match-test test_RepeatedIncrementsPersistForCaller` against the stub. It failed as expected with `0 != 1`. Added the storage write and built successfully with `forge build --root contracts` using Solidity 0.8.39.
- `forge test --root contracts` passed all four tests across two suites. The three new cases cover zero defaults, repeated increments, and caller isolation. `forge fmt --root contracts --check` passed. Forge reported a nonfatal warning about writing its signature cache outside the workspace.
- The tests use `vm.prank` to simulate callers. A wallet would submit a transaction to persist an increment on-chain, and a client can use a read call to fetch a count. The counter is exercised locally by Forge.
- The exercise in README asks the owner to add a third caller and predict the counts. The owner explicitly accepted Phase 04 on 2026-11-24. Learning responses remain pending.
- Suggested commit message: `test: demonstrate caller-specific Solidity storage`.

## Phase 05: ERC-20 test token

- The owner approved the Phase 05 plan. Added `MockERC20.sol`, which inherits OpenZeppelin ERC20 and Ownable, takes an explicit initial owner, and starts at zero supply. The owner's `mint(to, amount)` call delegates the balance and supply updates to OpenZeppelin.
- The targeted mint test first failed against the stub because Alice's balance was zero instead of 10 STK. Implemented the mint call and ran `forge build --root contracts` with Solidity 0.8.39.
- `forge test --root contracts` passed all 11 tests across three suites, including seven new token tests. They cover metadata, initial supply, independent token instances, owner minting, unauthorized minting, direct transfers, and delegated spending within and above allowance.
- `forge fmt --root contracts --check` and `forge lint --root contracts` passed. The expected-revert transfer test uses a local lint exception for its unused success value. Forge reported a nonfatal warning about writing its signature cache outside the workspace.
- The README exercise traces how a delegated transfer moves balances and consumes allowance while preserving total supply. On-chain deployment is a Phase 06 milestone.
- The owner explicitly accepted Phase 05 on 2026-11-24. Learning responses remain pending.
- Suggested commit message: `feat: add owner-mintable ERC-20 test token`.

## Phase 06 — Local deployment (2026-11-24)

- Approved by the owner. Added a Foundry deployment script, a PowerShell runner and verifier, and a public deployment record for chain 31337.
- Ran the README deployment procedure on fresh Anvil instances at ports 18545 and 8545. Both broadcasts succeeded. Each run verified two distinct addresses, two successful receipts, nonempty runtime code, names, symbols, 18 decimals, the intended owner, and zero initial supplies.
- The fresh nodes used the same default sender and deployment nonces, so both reproduced the same contract addresses. Their block hashes differed. The final JSON records the 8545 run.
- Windows initially blocked RPC access across execution contexts. Running the node and helper together with loopback proxy bypass succeeded. Forge reported trace-source and signature-cache warnings. Build, format check, and all 11 existing tests passed.
- Exercise: inspect the STK receipt and RWD symbol using the README commands. Compare the sender, created address, and gas used. Learning responses remain pending.
- The owner explicitly accepted Phase 06 on 2026-11-24.
- Suggested commit message: `feat: deploy and verify STK and RWD on local Anvil`.

## Phase 07 — Local Cast exercise (2026-11-25)

The prior node on port 8545 refused the RPC connection. Started fresh loopback Anvil and ran the Phase 06 deployment helper. Both creation receipts matched the recorded addresses and block hashes. Both contracts had runtime code, the expected symbols, and the local deployer as owner. The exercise used chain 31337 and Anvil accounts 0, 1, and 2 as owner, Alice, and Bob.

| Step | Alice STK | Bob STK | Bob's allowance from Alice | STK supply | Successful transaction hash |
| --- | ---: | ---: | ---: | ---: | --- |
| Initial reads | 0 | 0 | 0 | 0 | — |
| Owner mints to Alice | 10 | 0 | 0 | 10 | `0xca7d2b2257ea669ad9993c9f74a1f171d58f31feda9ac3bb013ca2e0783cd662` |
| Alice transfers to Bob | 8 | 2 | 0 | 10 | `0x2089ab182170110dbffb48cd76aab57719c146830341877d8691e7e221392b32` |
| Alice approves Bob | 8 | 2 | 3 | 10 | `0xa92f1efd37741e1c67725e0393431865543e67a0b1ab6a4e3dbc8498f933c374` |
| Bob spends from Alice | 7 | 3 | 2 | 10 | `0x52c6bd1b71b046b21684c5eca46531770353fe95c7b10a4acbfe4a194529df64` |

Read back all four quantities after every receipt. A final `cast call --from` simulated Bob spending 3 STK with only 2 approved. It reverted with selector `0xfb8f41b2` (insufficient allowance). The final readback again returned 7, 3, 2, and 10 STK. Deployment emitted nonfatal Forge trace warnings. The recorded hashes refer to this disposable local chain.

The owner accepted Phase 07 on 2026-11-25. Learning responses remain pending. The README contains the PowerShell exercise. Suggested commit message: `docs: demonstrate STK transfers and allowance consumption with Cast`.

## Phase 08 — Stake draft

Implemented a React draft screen with TypeScript, Vite, plain CSS and exact npm pins. Input state preserves decimal text as typed and passes it to the preview component. The first build identified missing Node declarations for Vite. Added matching Node 22 development types and reran `npm run build` successfully on Node 22.17.1.

Started Vite on loopback. Headless Edge verified typing 12.50, clearing to zero, two columns at 1280 px and one at 375 px, with no horizontal overflow. The exercise and startup commands are in README. The owner accepted Phase 08 on 2026-11-25. Learning review remains open.

Suggested commit: `feat: preview a local STK stake draft in React`.

## Phase 09 wallet integration checkpoint

Installed the pinned wallet libraries and added connection controls for chain 31337. Strict application type checking and the production build passed again with third-party declaration checking skipped due to dependency declaration conflicts. Edge showed the missing-wallet message and preserved the stake draft. The simulated wallet was not detected on the rejection test, so rejection, successful connection, account changes, network switching and disconnect remain unverified. Real extension testing and phase acceptance are pending.

## Phase 10 wallet balance

On 2026-11-26 the owner approved Phase 10 and agreed to proceed with real MetaMask verification still open. Deployed the tokens on a fresh local Anvil and refreshed the public record. Compared three read signatures and output types in viem's ERC-20 ABI against the compiled MockERC20 ABI. All matched.

Cast returned 0, 1250000000000000001 and 1 base units for three accounts. In headless Edge the production dashboard showed 0, 1.250000000000000001 and 0.000000000000000001 STK. A simulated wallet supplied account and chain changes. The disconnected and wrong-chain prompts appeared. Injecting a mismatched receipt block hash or refusing RPC requests showed the unavailable state. Retry recovered after each condition cleared. The frontend production build and type check passed with browser externalization and bundle-size warnings. The owner accepted Phase 10 on 2026-11-26. Learning responses are pending.

Suggested commit: `feat: display verified local STK balances at full precision`.

## Phase 11 allowance

The owner approved implementation. The production build and type check passed with bundle-size and browser externalization warnings. Edge used a simulated wallet with a real local Anvil RPC. Cast confirmed Bob's allowance changed from zero to 1250000000000000000 base units and back to zero, with unchanged owner balance. Browser checks covered invalid input, rejection, revocation before replacement and hiding the form on a wrong network. An injected reverted receipt exercised the revert message. A failed allowance refresh preserved the confirmed status and a read retry recovered. The owner accepted Phase 11 on 2026-11-27. Real MetaMask testing and learning review remain open.

Suggested commit: `feat: approve and revoke a local STK allowance`.

The owner paused Phase 11 learning to focus on Phase 10, then requested the full Phase 11 implementation walkthrough. Learning responses are pending.

The owner clarified that they wanted the Phase 11 implementation removed. Removed the allowance panel and restored the Phase 10 balance reader.

The owner requested Phase 11 again. Restored the allowance panel and shared STK deployment checks. The TypeScript check and production build passed. The prior Anvil browser verification used a simulated wallet.

## Phase 12 principal-only pool

The owner approved the plan. The test-first compile failed because StakingPool.sol did not yet exist. After implementation, `forge test --root contracts` passed 18 tests, including seven pool tests, and `forge fmt --root contracts --check` passed.

Deployed STK and the pool on disposable Anvil on port 8553. Verified the deployment receipt, runtime code, and staking token binding. Cast confirmed that approval left the wallet at 10 STK and the deposit at zero. Staking 5 left the wallet and deposit at 5 STK each. Withdrawing 2 left 7 in the wallet and 3 deposited. Pool holdings matched total deposits at each step. Forge printed nonfatal source-trace warnings. The public deployment record is specific to this Anvil instance. The owner accepted Phase 12 on 2026-11-27. Learning responses are pending.

Suggested commit `feat: add and verify principal-only local staking pool`.

## Future entry format


For each milestone record date, authorization, files/behavior changed, concepts introduced, decisions, actual commands/results/test counts, errors and solutions, remaining concerns, owner's own reflections, learning verification, and phase acceptance. Never fill unknown results with assumed success.
