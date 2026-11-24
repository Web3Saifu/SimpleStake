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
- The README exercise traces how a delegated transfer moves balances and consumes allowance while preserving total supply. On-chain deployment is a Phase 06 milestone. Learning responses and phase acceptance are pending.
- Suggested commit message: `feat: add owner-mintable ERC-20 test token`.

## Future entry format

For each milestone record date, authorization, files/behavior changed, concepts introduced, decisions, actual commands/results/test counts, errors and solutions, remaining concerns, owner's own reflections, learning verification, and phase acceptance. Never fill unknown results with assumed success.
