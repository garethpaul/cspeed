---
title: CSpeed Lint Toolchain Patch Refresh
type: maintenance
date: 2026-06-17
status: completed
execution: code
---

# CSpeed Lint Toolchain Patch Refresh

## Context

The direct development toolchain is fully pinned and audit-clean, but registry
inspection shows three compatible patch releases beyond the lockfile:

- `eslint` 10.4.1 to 10.5.0
- `typescript-eslint` 8.61.0 to 8.61.1
- `@types/node` 22.19.20 to 22.19.21

The same inspection reports TypeScript 6.0.3 and Node 25 types as current
cross-major releases. Those changes affect compiler and runtime-type contracts
and do not belong in this patch-only maintenance unit.

## Priority

1. Keep the lint and Node 22 type surface on current compatible patches.
2. Preserve exact reproducibility, generated JavaScript identity, and the
   complete Node 22/24 verification matrix.
3. Defer TypeScript 6 and Node 25 type adoption to dedicated compatibility
   plans with explicit migration evidence.

## Requirements

- Update only `eslint`, `typescript-eslint`, and `@types/node` to the exact
  patch versions listed above.
- Refresh `package-lock.json` through npm without dependency overrides,
  lifecycle scripts, or unrelated direct-package changes.
- Structurally require the direct versions and reviewed registry integrities in
  `scripts/check-baseline.sh`, including the `typescript-eslint` package family
  resolved by the patch refresh.
- Preserve TypeScript 5.9.3, VS Code 1.120 type contracts, extension source,
  compiled `out/` behavior, package scripts, workflow actions, permissions,
  and Node 22/24 matrix.
- Keep `npm audit --audit-level=moderate` at zero findings.
- Record completed local and exact-head hosted evidence before marking this
  plan complete.

## Implementation Units

### 1. Exact compatible package refresh

Files:

- `package.json`
- `package-lock.json`

Use npm under Node 22 to update the three exact direct patches and their
lockfile-resolved transitive package family. Do not change TypeScript, VS Code
types, scripts, extension metadata, or runtime dependencies.

### 2. Lockfile regression contracts

Files:

- `scripts/check-baseline.sh`

Parse package metadata structurally and require exact versions plus reviewed
integrities. Reject restoration of any superseded patch, package-family skew,
or an unreviewed artifact while retaining the existing generated-output,
workflow, and source contracts.

### 3. Maintained guidance and evidence

Files:

- `AGENTS.md`
- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `docs/plans/2026-06-17-cspeed-lint-toolchain-patch-refresh.md`

Document the patch baseline and the deliberate TypeScript 6/Node 25 boundary
without implying that registry latest majors are already supported.

## Validation

- Run a lockfile-pinned install under Node 22 with lifecycle scripts disabled.
- Run lint, TypeScript compilation, all parser/dispatch/activation/provider
  tests, generated-output verification, source contracts, and dependency audit.
- Run the complete gate from the repository root and an external working
  directory under Node 22, then repeat the full gate under Node 24.
- Reject isolated mutations for each direct version, lockfile artifact and
  integrity, package-family alignment, maintained guidance, plan status, and
  verification evidence.
- Audit direct dependency, workflow, source, generated-output, artifact,
  whitespace, conflict-marker, and credential-shaped addition drift.
- Require both exact-head push and pull-request Node 22/24 matrices to pass.

## Scope Boundaries

- Do not adopt TypeScript 6, Node 25 types, a new ESLint configuration model,
  dependency overrides, runtime packages, or new build scripts.
- Do not change alert validation, sidebar lifecycle, extension activation,
  CSP, media assets, notification behavior, or compiled output semantics.
- Do not claim live VS Code Extension Host execution from Node tests or hosted
  package gates.
- Do not merge or close this stacked pull request or any predecessor without
  explicit authorization.

## Verification Results

Implementation is complete. A clean lockfile-pinned install with lifecycle
scripts disabled passed lint, TypeScript compilation, all 19 Node tests,
generated-output verification, and the moderate dependency audit with zero
findings under Node `22.22.2` and Node `24.16.0`. Nineteen isolated hostile mutations were rejected
across direct versions, reviewed lockfile artifacts, the complete
`@typescript-eslint` family, and maintained guidance.

The full `make check` gate then passed from both the repository root and an
external `/tmp` working directory under both supported Node versions. The
checked-in `out/` files remained identical to compiler output.

Both exact-head push and pull-request Node 22/24 matrices passed. The verified
commit was `fa5b13aa45d2e7f7a44111f1912cf1731af8955b`. Push run `27663023413`
and pull-request run `27663027246` each completed successfully for Node 22 and
Node 24. PR #10 remained open, clean, mergeable, and alert-free during the
bounded exact-head verification snapshot. The completed-plan contract pins the
verified implementation head and both canonical run identifiers.
