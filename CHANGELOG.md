# Changelog

All notable changes to the Ruflo project (formerly Claude Flow) are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.7.0-alpha.91] - 2026-07-05

### Changed
- Bump version `3.7.0-alpha.90` → `3.7.0-alpha.91` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.91` dated 2026-07-05
- Daily maintenance update: packages confirmed operational

---

## [3.7.0-alpha.90] - 2026-07-02

### Changed
- Bump version `3.7.0-alpha.89` → `3.7.0-alpha.90` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.90` dated 2026-07-02
- Daily maintenance update: packages confirmed operational

---

## [3.7.0-alpha.89] - 2026-07-01

### Changed
- Bump version `3.7.0-alpha.88` → `3.7.0-alpha.89` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.89` dated 2026-07-01
- Daily maintenance update: packages confirmed operational

Supersedes PR #47 (`claude/focused-rubin-jisfrn`).

---

## [3.7.0-alpha.88] - 2026-06-30

### Changed
- Bump version `3.7.0-alpha.87` → `3.7.0-alpha.88` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.88` dated 2026-06-30
- Daily maintenance update: packages confirmed operational

Supersedes PR #46 (`claude/focused-rubin-10vad4`).

---

## [3.7.0-alpha.87] - 2026-06-29

### Changed
- Bump version `3.7.0-alpha.86` → `3.7.0-alpha.87` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.87` dated 2026-06-29
- Daily maintenance update: packages confirmed operational

Supersedes PR #45 (`claude/focused-rubin-9q34r3`).

---

## [3.7.0-alpha.86] - 2026-06-28

### Changed
- Bump version `3.7.0-alpha.85` → `3.7.0-alpha.86` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.86` dated 2026-06-28
- Daily maintenance update: packages confirmed operational

Supersedes PR #44 (`claude/focused-rubin-9egkxk`).

---

## [3.7.0-alpha.85] - 2026-06-27

### Changed
- Bump version `3.7.0-alpha.84` → `3.7.0-alpha.85` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.85` dated 2026-06-27
- Daily maintenance update: packages confirmed operational

Supersedes PR #43 (`claude/focused-rubin-nam8oy`).

---

## [3.7.0-alpha.84] - 2026-06-26

### Changed
- Bump version `3.7.0-alpha.83` → `3.7.0-alpha.84` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.84` dated 2026-06-26
- Daily maintenance update: packages confirmed operational

Supersedes PR #42 (`claude/focused-rubin-ka3mfz`).

---

## [3.7.0-alpha.83] - 2026-06-25

### Changed
- Bump version `3.7.0-alpha.82` → `3.7.0-alpha.83` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Add `CHANGELOG.md` entry for `3.7.0-alpha.83` dated 2026-06-25
- Daily maintenance update: packages confirmed operational

---

## [3.7.0-alpha.74] - 2026-06-03

### Fixed
- CI: Add build step to `Type Check V3` job before typecheck (PR #17) — workspace packages expose types only through compiled `dist/index.d.ts`; running `pnpm typecheck` without a prior build caused unresolvable module errors on every run

### Changed
- Update `package-lock.json` and `ruflo/package-lock.json` after `npm install` (PR #16)
- Bump version `3.7.0-alpha.73` → `3.7.0-alpha.74` across all three packages (`claude-flow`, `ruflo`, `@claude-flow/cli`)
- Sync stale `v3/@claude-flow/cli` dependency pins to match root `package.json` (drifted across PRs #7–#15)

| Package | Before | After |
|---------|--------|-------|
| `@claude-flow/mcp` | `^3.0.0-alpha.8` | `^3.0.0-alpha.9` |
| `@claude-flow/shared` | `^3.0.0-alpha.7` | `^3.0.0-alpha.8` |
| `semver` | `^7.6.0` | `^7.8.1` |
| `@claude-flow/codex` (optional) | `^3.0.0-alpha.8` | `^3.0.0-alpha.12` |
| `@claude-flow/plugin-gastown-bridge` (optional) | `^0.1.3` | `^0.1.4` |

---

## [3.7.0-alpha.73] - 2026-05-25

### Fixed
- CLAUDE.md: Aligned heading "Ruflo v3.5" to match version banner "Ruflo v3.6" (cosmetic)

### Changed
- Bump version `3.7.0-alpha.71` → `3.7.0-alpha.73`

---

## [3.5.0] - 2026-02-27

### Ruflo v3.5 — First Major Stable Release

This release marks the official rebranding from **Claude Flow** to **Ruflo** and represents the first major stable release after 5,800+ commits, 55 alpha iterations, and 10 months of development.

### Highlights

- **Rebranding**: Claude Flow → Ruflo across all packages (`@claude-flow/cli`, `claude-flow`, `ruflo`)
- **agentic-flow v3.0.0-alpha.1 Integration**: Full deep integration with 10 subpath exports (ReasoningBank, Router, Orchestration, Agent Booster, SDK, Security, QUIC transport)
- **AgentDB v3.0.0-alpha.9**: 8 new controllers (HierarchicalMemory, MemoryConsolidation, SemanticRouter, GNNService, RVFOptimizer, MutationGuard, AttestationLog, GuardedVectorBackend) + 6 MCP tools
- **215 MCP Tools**: Full Model Context Protocol server with vector memory, neural training, swarm coordination
- **Security Hardening**: Command injection fix, TOCTOU race fix, eliminated hardcoded HMAC keys, timing attack fixes
- **Doctor Health Check**: New `agentic-flow` diagnostic (filesystem-based, ESM-compatible)
- **0 Production Vulnerabilities**: Clean `npm audit` across all packages

### Added

- `agentic-flow-bridge.ts` — Unified lazy-loading bridge for all agentic-flow v3 modules
- Tiered embedding resolution: ReasoningBank WASM (Tier 1) → @claude-flow/embeddings (Tier 2) → mock fallback (Tier 3)
- Agent Booster local import with npx fallback
- `checkAgenticFlow()` doctor health check
- 7 TypeScript module declarations for agentic-flow subpath exports
- ADR-056: agentic-flow v3 Integration Architecture

### Fixed

- Command injection vulnerability in enhanced-model-router.ts (SAFE_LANGUAGES whitelist)
- TOCTOU race condition in bridge singleton initialization (Promise-based caching)
- 22 agent/skill files updated from stale v1.5.11/v2.0.0-alpha to v3.0.0-alpha.1
- ESM compatibility for doctor checks (filesystem-based instead of `require.resolve`)
- @ruvector/gnn pinned to 0.1.25 to fix fatal process crash (issue #216)

### Changed

- All 3 packages bumped from `3.1.0-alpha.55` to `3.5.0`
- Publish tags changed from `alpha`/`v3alpha` to `latest`
- agentic-flow minimum version: `0.1.0` → `3.0.0-alpha.1`
- agentdb minimum version: `2.0.0-alpha.3.4` → `3.0.0-alpha.10`

---

## [3.1.0-alpha.55] - 2026-02-27

### AgentDB 3.0.0-alpha.9 Integration (ADR-053/ADR-055)

- Activated 8 AgentDB v3 controllers with MutationGuard proof engine
- Added 6 new MCP tools: `agentdb_hierarchical_*`, `agentdb_consolidation_*`, `agentdb_semantic_*`
- Fixed controller registry activation bugs (ADR-055)
- Statusline fixes for real-time controller status
- Pinned @ruvector/gnn@0.1.25 to fix fatal process crash

## [3.1.0-alpha.43] - 2026-02-15

### Ruflo Branding Fix

- Fixed CLI branding: show 'ruflo' instead of 'claude-flow' when run via `npx ruflo`
- Fixed Windows ESM import crash with `pathToFileURL`
- Fixed init hook prompt overflow and description field

## [3.1.0-alpha.36] - 2026-02-10

### Stability & Compatibility

- Fixed hooks backward compatibility: `--success` and `--file` made optional
- Fixed Windows npm install crash (404 optional dependencies)
- Bumped agentdb to 2.0.0-alpha.3.6
- Fixed V3 build errors (missing helmet, VERSION type, vitest spy)

## [3.1.0-alpha.29] - 2026-02-01

### Security & Agent Teams

- Security fixes, backward compatibility, and Agent Teams hooks
- Added `--settings` flag to upgrade command for Agent Teams
- Fixed npm 11 install crash by pinning agentdb

---

## v3.0.0-alpha Series (2025-10 to 2026-02)

### v3.0.0-alpha.184 — CLI Help & Categorization (2025-12)

- Fixed CLI help categorization across 26 commands
- Published install optimizations
- curl-style installer script
- SEO-optimized npm packages for discovery

### v3.0.0-alpha.170 — Plugins & Marketplace (2025-12)

- **Plugin Marketplace**: 8 official plugins + IPFS registry via Pinata
- **Gas Town Bridge Plugin**: WASM-accelerated orchestrator integration
- **10 RuVector WASM Plugins**: 50 MCP tools for neural computation
- **@claude-flow/teammate-plugin**: MCP tools for Agent Teams coordination

### v3.0.0-alpha.150 — SONA & SemanticRouter (2025-11)

- **SemanticRouter**: SONA WASM integration with verified benchmarks
- Fixed phantom Claude popups on Windows
- Fixed statusline safe multi-line output for Claude Desktop
- Fixed MCP tool naming (`/` → `_`) for Claude Desktop compatibility
- Memory namespace support in delete command

### v3.0.0-alpha.100 — @claude-flow/guidance (2025-11)

- **@claude-flow/guidance Control Plane**: Governance, compliance, and policy enforcement
- Wave 1: Proof, gateway, memory-gate, coherence, hooks, persistence primitives
- Wave 2: Conformance kit, capability algebra, evolution pipeline, artifact ledger
- Wave 3: Civilization-grade primitives (trust, truth, uncertainty, time, authority)
- **Rust WASM Policy Kernel**: SIMD128-accelerated policy evaluation
- **ContinueGate**: Safety gate for agent continuation decisions
- 22-benchmark suite with before/after performance reporting
- CLAUDE.md generators, analyzer, and auto-optimizer
- Content-aware executor with statistical validation (Spearman ρ, Cohen's d)

### v3.0.0-alpha.50 — Core V3 Implementation (2025-10)

- Complete V3 implementation across all ADRs
- ADR-003: Coordinator consolidation + security tests
- Complete hooks system with AgentDB, HNSW, tests
- ReasoningBank guidance system with CLI
- V2→V3 migration documentation
- MCP memory tools upgraded to sql.js + HNSW backend
- Claims-based authorization (ADR-016)
- Node.js worker daemon system
- Auto-update system for @claude-flow packages (ADR-025)
- Replaced all mock implementations with real functionality

### v3.0.0-alpha.1 — Foundation (2025-10)

- Complete V3 monorepo structure (`@claude-flow/cli`, `shared`, `memory`, `hooks`, `security`)
- 26 CLI commands with 140+ subcommands
- 215 MCP tools via FastMCP 3.x
- RuVector intelligence system (SONA, MoE, HNSW, EWC++, Flash Attention)
- Hive-Mind consensus (Byzantine, Raft, Gossip, CRDT, Quorum)
- 17 hooks + 12 background workers
- 60+ specialized agent types
- Cross-platform helper system

---

## v2.7.x Series (2025-08 to 2025-10)

### v2.7.34 — PostgreSQL & Neural Persistence

- PostgreSQL Bridge with attention, GNN, hyperbolic embeddings
- Neural pattern persistence to disk
- Hive-mind `--claude` flag for spawn command
- Real statusline data, hive-mind shutdown fixes, daemon persistence
- Multi-platform builds (Linux, macOS, Windows) in CI/CD

### v2.7.0 — agentic-flow Integration

- Deep integration with agentic-flow coordination engine
- SDK architecture analysis and hooks & learning integration
- Modular installation strategy
- Optimized v3 migration plan

---

## v2.0.0-alpha Series (2025-05 to 2025-08)

### v2.0.0-alpha.128 — Maturity

- Comprehensive hive-mind optimization
- Database schema robustness (missing columns, optimization errors)
- Auto-rebuild better-sqlite3 on NODE_MODULE_VERSION mismatch
- InMemoryStore interval cleanup for clean process exit

### v2.0.0-alpha.53 — Hook Safety

- Critical hook safety system
- Hive-mind optimization command
- Safety & security features documentation
- Neural Link System with safety protocols

### v2.0.0-alpha.33 — Windows & WSL

- Windows/WSL compatibility fixes
- Module import error resolution
- README restructure for v2.0.0 features
- Comprehensive test suite

---

## v1.x Series (2025-01 to 2025-05)

### v1.0.71 — Final v1 Release

- npm publishing compatibility
- Full CLI command functionality
- SPARC integration with full prompt loading
- Cross-platform support

### v1.0.50 — Swarm & SPARC

- Parallel execution for swarm tasks
- Background task management
- Swarm command with improved error handling
- Claude Code slash commands integration

### v1.0.28 — Project Management

- CLI project management commands
- System monitoring and SPARC commands
- Orchestration templates (monitoring, optimization, security review)

### v1.0.1 — Initial Release (2025-01-01)

- Complete Claude-Flow AI Agent Orchestration System
- Configuration guide and comprehensive tests
- Initial commit

---

## Milestone Summary

| Milestone | Version | Date | Key Feature |
|-----------|---------|------|-------------|
| Initial Release | v1.0.1 | 2025-01 | AI agent orchestration system |
| SPARC Integration | v1.0.50 | 2025-03 | Swarm + SPARC methodology |
| Alpha Foundation | v2.0.0-alpha.33 | 2025-05 | V2 alpha with hook safety |
| agentic-flow | v2.7.0 | 2025-08 | agentic-flow coordination engine |
| V3 Foundation | v3.0.0-alpha.1 | 2025-10 | V3 monorepo, 215 MCP tools |
| Plugin Marketplace | v3.0.0-alpha.170 | 2025-12 | 8 plugins + IPFS registry |
| Guidance Control Plane | v3.0.0-alpha.100 | 2026-01 | WASM policy kernel, ContinueGate |
| AgentDB v3 | v3.1.0-alpha.55 | 2026-02 | 8 controllers, MutationGuard |
| **Ruflo v3.5** | **v3.5.0** | **2026-02-27** | **First stable release, rebranding** |
| **Ruflo v3.6** | **v3.6.10** | **2026-04-29** | **Agent federation, comms-first coordination** |
| **Ruflo v3.7-alpha.73** | **v3.7.0-alpha.73** | **2026-05-25** | **Version alignment, CLAUDE.md fix** |
| **Ruflo v3.7-alpha.74** | **v3.7.0-alpha.74** | **2026-06-03** | **Dep sync, CI fix, lockfile update** |
| **Ruflo v3.7-alpha.83** | **v3.7.0-alpha.83** | **2026-06-25** | **Daily maintenance update** |
| **Ruflo v3.7-alpha.84** | **v3.7.0-alpha.84** | **2026-06-26** | **Daily maintenance update** |
| **Ruflo v3.7-alpha.85** | **v3.7.0-alpha.85** | **2026-06-27** | **Daily maintenance update** |
| **Ruflo v3.7-alpha.86** | **v3.7.0-alpha.86** | **2026-06-28** | **Daily maintenance update** |
| **Ruflo v3.7-alpha.87** | **v3.7.0-alpha.87** | **2026-06-29** | **Daily maintenance update** |
| **Ruflo v3.7-alpha.88** | **v3.7.0-alpha.88** | **2026-06-30** | **Daily maintenance update** |
| **Ruflo v3.7-alpha.89** | **v3.7.0-alpha.89** | **2026-07-01** | **Daily maintenance update** |
| **Ruflo v3.7-alpha.90** | **v3.7.0-alpha.90** | **2026-07-02** | **Daily maintenance update** |
| **Ruflo v3.7-alpha.91** | **v3.7.0-alpha.91** | **2026-07-05** | **Daily maintenance update** |
