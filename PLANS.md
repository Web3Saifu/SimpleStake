# SimpleStake: phased plan

## Current status

- Phase 00: specification delivered; separate explicit phase acceptance is not recorded.
- Phase 01: five documents created and verified; owner learning review and phase acceptance pending.
- Phase 02: accepted by the owner; learning review pending.
- Phase 03: accepted by the owner; learning review pending.
- Phase 04: accepted by the owner; learning review pending.
- Phase 05: accepted by the owner. Learning review remains open.
- Phase 06: accepted by the owner. Learning review remains open.
- Phase 07: accepted by the owner. Learning review remains open.
- Phase 08: accepted by the owner. Frontend build and browser checks passed.
- Phase 09: wallet controls implemented. Browser verification in progress.
- Phases 10-19: not started.
- Learning understanding: not yet verified through the owner's answers.

The owner explicitly requested Phase 01 planning and approved its implementation. This authorizes the present document work; it does not retroactively establish Phase 00 acceptance or authorize future phases.

## Workflow

For each phase: inspect context -> plan -> explicit plan approval -> implement only that phase -> verify -> hands-on learning -> completion report -> explicit acceptance -> separate instruction to plan the next phase. Follow [AGENTS.md](AGENTS.md).

Each phase depends on the preceding milestone. Do not silently skip or combine phases. Record acceptance separately from implementation status and learning status.

## Roadmap

| Phase | Scope and deliverable | Dependency | Acceptance evidence | Status |
| --- | --- | --- | --- | --- |
| 00 | Define goals, business rules, architecture, repository structure, and roadmap; planning only. | Project brief | Scope, data flow, policies, palette, and criteria documented in the phase response. | Delivered; acceptance unrecorded |
| 01 | Create AGENTS, GOALS, PLANS, LEARNING_LOG, and README. | Phase 00 specification and explicit Phase 01 approval | Five consistent documents, valid local links, accurate status, no fabricated results. | Documents verified; learning review/acceptance pending |
| 02 | Inspect environment; verify compatible stable versions against official documentation; install only approved missing tools. | Project context documents | Tool inventory, version/compatibility decisions, installation approvals, and observed results recorded. | Accepted; learning review pending |
| 03 | Initialize Git and Foundry; pin contract dependencies; explain structure. | Verified tools | Project compiles, dependencies are recorded, appropriate ignore rules prevent secrets/generated clutter entering Git. | Accepted; learning review pending |
| 04 | Create a minimal temporary Solidity learning example. | Foundry project | Compile/test; explain state, functions, storage, callers, transactions; isolate/remove example from final deployable application. | Accepted; learning review pending |
| 05 | Implement MockERC20 using OpenZeppelin. | Contract tooling and learning example | Tests cover metadata, balances, transfers, approvals, and owner-only mint authorization. | Accepted. Learning review open. |
| 06 | Start Anvil; reproducibly deploy STK and RWD. | Tested token | Deployment receipts, bytecode, chain ID, addresses, and repeatable script verified. | Verified on two fresh chains and accepted. |
| 07 | Interact with tokens using Cast. | Local token deployment | Four successful receipts, balances, supply, allowance, and above-allowance simulation verified. | Accepted |
| 08 | Initialize React, TypeScript, Vite, and plain CSS. | Local contract interaction milestone | Minimal frontend runs/builds; explain components, props, state, and events; introduce palette. | Accepted |
| 09 | Configure wagmi, viem, TanStack Query, and MetaMask. | Frontend scaffold | Connection, disconnection, account changes, network changes, and wrong-network behavior checked. | Browser verification pending |
| 10 | Import public deployment addresses and ABIs; display balances. | Wallet integration and deployment artifacts | Correct chain/address/ABI and bigint formatting verified against contract reads. | Not started |
| 11 | Demonstrate approval to an explicitly identified local test spender. | Token reads and wallet integration | Confirm allowance changes and signing/confirmation states; clearly distinguish approval from staking. | Not started |
| 12 | Implement principal-only StakingPool, tests, and local deployment. | Token/allowance fundamentals | Deposit/withdraw accounting, zero amounts, insufficient allowance, invalid withdrawals, and authorization cases tested. | Not started |
| 13 | Integrate approval to the actual pool, stake, and withdrawal. | Principal-only pool and frontend | Complete local transaction lifecycle verified; displays refresh after successful receipts. | Not started |
| 14 | Explain reward mathematics; implement pre-funded, one-time schedule and reward accounting; redeploy with fresh local state. | Verified principal-only flow | Time-based, multi-user, funding, zero-stake, rounding, repeated-claim, and schedule-boundary tests pass. | Not started |
| 15 | Integrate earned rewards and claims. | Updated deployment and reward contract | Updated ABIs/addresses verified; earned display and claim behavior checked end to end. | Not started |
| 16 | Improve validation, errors, and transaction/refresh states. | Complete staking/reward UI | Reject/revert/pending/success/refresh-failure cases checked without misreporting confirmed transactions. | Not started |
| 17 | Review contracts, dependencies, and frontend security; add fuzz and invariant tests. | Integrated application | Principal coverage, reward funding/accounting, authorization, and adversarial behaviors investigated with recorded evidence and limits. | Not started |
| 18 | Prepare Sepolia deployment, then deploy only after separate explicit approval. | Security review and deployment approval | Test funds only; verify chain IDs, bytecode, addresses, frontend configuration, and source verification where practical. | Not started |
| 19 | Complete documentation, architectural review, and knowledge assessment. | Previous milestones and deployment evidence | Reproducible instructions, known limitations, reusable patterns, and honest learning assessment recorded. | Not started |

## Phase 01 approved scope

Create exactly five root Markdown files. Keep each document's purpose separate, link them locally, preserve the 20-phase sequence and confirmed palette, and record security/approval requirements plus the `P` shortcut. Do not initialize Git, install tools, scaffold code, or deploy.

### Acceptance checklist

- [x] Five documents exist and have been read back.
- [x] Relative Markdown links resolve.
- [x] Roadmap contains phases 00-19 once each, in order.
- [x] Scope, policies, stack, and palette are consistent.
- [x] Phase gates, security requirements, and P authorization are recorded.
- [x] No unexecuted tests/commands, learning reflections, or acceptances are claimed.
- [x] Hands-on review exercise and conceptual questions provided in LEARNING_LOG.
- [ ] Owner learning responses reviewed; understanding recorded accurately.
- [ ] Owner explicitly accepts Phase 01.

## Phase 02 verification checklist

- [x] Git, Node.js, npm, Forge, Anvil, and Cast returned versions.
- [x] Record selected versions and check published compatibility constraints.
- [x] Record the proposed Node security patch and its approval status.
- [x] Record runnable version checks and limitations.
- [x] Apply contract pins and verify compiler download, imports, and build in Phase 03.
- [ ] Verify frontend package resolution and builds in the relevant frontend phases.
- [x] Record the owner's explicit Phase 02 acceptance.
- [ ] Review the owner's learning answers when provided.

## Phase 03 verification checklist

- [x] Root Git repository and nested Foundry workspace verified.
- [x] Both library tags resolved and recorded as local Git submodule pins.
- [x] Solidity 0.8.39 build, setup test, and formatting check passed.
- [x] Representative generated paths and local environment files matched the ignore rules.
- [x] Record the owner's explicit Phase 03 acceptance.
- [ ] Review learning responses when provided.

## Phase 04 verification checklist

- [x] Keep the example under the test tree, outside application source.
- [x] Observe the increment test fail against the stub before implementing storage writes.
- [x] Compile with Solidity 0.8.39 and pass all three learning tests plus the existing setup test.
- [x] Pass the formatting check and document the hands-on exercise.
- [x] Record the owner's explicit Phase 04 acceptance.
- [ ] Review learning responses when provided.

## Phase 05 verification checklist

- [x] Reuse the pinned OpenZeppelin ERC20 and Ownable implementations.
- [x] Observe the mint test fail against the stub before implementing minting.
- [x] Verify STK and RWD metadata and state isolation, owner-only minting, direct transfers, and delegated transfers within allowance.
- [x] Verify Solidity build, all tests, format, and lint checks.
- [x] Document the delegated transfer exercise.
- [x] Record the owner's explicit Phase 05 acceptance.
- [ ] Review learning responses when provided.

## Deferred decisions and concerns

- Phase 00 acceptance remains unrecorded; do not infer it from unanswered questions.
- Recheck the installed Node/npm pair before frontend setup. The planned Node security update needs separate installation approval.
- Determine exact contract interfaces in their implementation phases.
- Define reward arithmetic, precision, budget/duration validation, and funding checks in Phase 14 before coding.
- Select exact CSS colors during frontend development while preserving the confirmed ratio and readability.
- Local redeployments replace test state; synchronize public deployment data and frontend ABIs/addresses.
- Sepolia deployment requires its own explicit approval, independent of phase planning.

## Proposed eventual repository structure

```text
Staking/
  AGENTS.md
  GOALS.md
  PLANS.md
  LEARNING_LOG.md
  README.md
  .gitignore                 # Phase 03
  contracts/                # Phase 03 onward
    foundry.toml
    src/
    test/
    script/
    lib/
  deployments/              # Public deployment records when needed
  frontend/                 # Phase 08 onward
    package.json
    package-lock.json
    src/
```

This tree is a future layout, not a claim that these directories exist.
