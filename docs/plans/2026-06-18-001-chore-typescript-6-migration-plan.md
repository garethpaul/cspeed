---
title: "chore: Migrate the extension build to TypeScript 6"
type: chore
date: 2026-06-18
execution: code
---

# chore: Migrate the extension build to TypeScript 6

## Summary

Upgrade the checked-in extension build from TypeScript 5.9.3 to 6.0.3 while
preserving the current Node 22/24 and VS Code 1.120 compatibility contracts.
Prove that source compilation, generated JavaScript, lint, tests, and package
audits remain deterministic across both supported Node majors.

---

## Problem Frame

The direct dependency freshness gate reports TypeScript 6.0.3 as the current
stable release while this branch remains pinned to 5.9.3. Repository guidance
already classifies TypeScript 6 as a compatibility migration rather than an
incidental lockfile refresh. The current `tsconfig.json` avoids the compiler
options removed by TypeScript 6, so the migration can remain narrow and
evidence-driven without changing extension behavior or runtime support.

---

## Requirements

**Compiler and package contract**

- R1. Pin the direct `typescript` development dependency and lockfile to
  6.0.3 without changing unrelated direct dependency versions.
- R2. Preserve the existing CommonJS, ES2020, strict-mode, source-map,
  `rootDir`, and checked-in `out/` compilation contract while declaring
  explicit Node and VS Code type roots.
- R3. Keep the declared Node range at `>=22.13.0 <25` and the VS Code engine at
  `^1.120.0`; reported Node 25 and newer VS Code type packages remain outside
  this migration.

**Verification and maintenance**

- R4. Compile and execute the complete repository and external-directory gate
  under Node 22.22.2 and Node 24.16.0.
- R5. Require zero-warning lint, all 20 tests, source-to-generated-output
  parity, baseline contracts, and zero moderate-or-higher audit findings.
- R6. Add a mutation-sensitive repository contract and maintained guidance so
  downgrading the compiler or recording unsupported runtime claims fails the
  canonical gate.
- R7. Keep the dependency install lifecycle-script-free and remove only the
  validation-created `node_modules` tree after final auditing.

---

## Assumptions

- TypeScript 6.0.3 is the migration target because it is the current stable
  JavaScript-based compiler; the TypeScript 7 native beta is not a production
  dependency candidate.
- No compiler-option migration is expected because the current configuration
  does not use removed TypeScript 6 options such as `outFile`,
  `moduleResolution: classic`, or implicit `baseUrl` lookup behavior.
- The pinned `typescript-eslint` 8.61.1 toolchain declares support for
  TypeScript versions `>=4.8.4 <6.1.0`, which includes 6.0.3.
- `@types/node` 25 and `@types/vscode` 1.125 are not freshness defects for this
  unit because adopting them would change the repository's supported Node or
  VS Code API contract.

---

## Key Technical Decisions

- **Upgrade only the compiler:** isolate TypeScript 6 compatibility from Node,
  VS Code API, ESLint, and extension-behavior changes so regressions are
  attributable to the compiler transition.
- **Retain checked-in output as a contract:** regenerate `out/` through the
  canonical compile command and require `check:generated` to prove source and
  committed JavaScript remain synchronized.
- **Verify both supported Node majors:** run identical package and external
  Makefile gates under Node 22 and Node 24 because compiler execution is part
  of the repository's declared cross-version support.

---

## Implementation Units

### U1. Upgrade the TypeScript compiler lock

- **Goal:** Move the direct compiler dependency to TypeScript 6.0.3 with a
  minimal lockfile update.
- **Files:** `package.json`, `package-lock.json`, `out/*.js`, `out/*.js.map`
- **Approach:** Update only the TypeScript package, run the existing compiler,
  and retain generated files only when TypeScript 6 produces a meaningful
  byte-level change.
- **Test scenarios:** clean lifecycle-script-free install, TypeScript compile,
  and source-to-generated-output parity under both supported Node majors.
- **Covers:** R1, R2, R3, R4, R5, R7.

### U2. Preserve the migration as a maintained repository contract

- **Goal:** Make compiler-version drift and unsupported compatibility claims
  visible in the baseline gate and contributor guidance.
- **Files:** `scripts/check-baseline.sh`, `AGENTS.md`, `README.md`, `CHANGES.md`,
  `VISION.md`, `docs/plans/2026-06-18-001-chore-typescript-6-migration-plan.md`
- **Approach:** Require the exact TypeScript 6.0.3 package and lockfile state,
  document the preserved Node/VS Code boundaries, and record only validation
  actually completed.
- **Test scenarios:** downgrade the package fixture, remove the compiler
  guidance, alter the Node/VS Code boundary, and remove final verification
  evidence; each mutation must fail the baseline gate.
- **Covers:** R3, R4, R5, R6, R7.

---

## Verification Strategy

- Run the focused compiler and generated-output checks before the complete
  package gate.
- Run repository-root and external-directory `make check` under Node 22.22.2
  and Node 24.16.0 with explicit timeouts.
- Confirm all 20 tests, zero-warning lint, TypeScript compilation, generated
  output parity, baseline contracts, and moderate dependency audits pass.
- Reject isolated mutations covering the compiler version, lockfile entry,
  generated-output contract, cross-version commands, maintained guidance, and
  verification evidence.
- Audit the exact diff, package-lock scope, generated artifacts, conflicts,
  file modes, large files, and credential-shaped additions before commit.
- Require exact-head push and pull-request checks for Node 22 and Node 24 before
  recording terminal tracker evidence.

---

## Scope Boundaries

- Do not adopt TypeScript 7 beta or change the extension's runtime compiler.
- Do not raise the supported Node range or VS Code engine requirement.
- Do not update `@types/node`, `@types/vscode`, ESLint, TypeScript ESLint, or
  stylistic lint dependencies in this unit.
- Do not change alert parsing, webview behavior, extension registration,
  provider lifecycle, CSP, commands, assets, workflows, or permissions.
- Do not claim live VS Code Extension Host execution from package-level tests.
- Do not merge or close this stacked pull request or its predecessors without
  explicit authorization.

---

## Risks

- TypeScript 6 can expose stricter diagnostics or emit differences even when
  the configuration avoids removed options; focused compilation and generated
  parity make those changes explicit.
- Checked-in source maps may change despite unchanged runtime semantics and
  must be reviewed as generated compiler output rather than hand-edited.
- A future TypeScript 7 migration will be a separate native-compiler decision
  and must not be inferred from this JavaScript-based compiler upgrade.

---

## Verification Results

- Repository-root and external-directory `make check` completed successfully
  under Node 22.22.2 and Node 24.16.0. Each run passed zero-warning lint, all
  20 tests, the baseline contract, generated-output parity, and the
  moderate-level dependency audit with zero vulnerabilities.
- TypeScript 6.0.3 compiled successfully after `tsconfig.json` declared the
  explicit Node and VS Code type roots required by TypeScript 6's empty
  default type environment.
- The checked-in TypeScript 6 CommonJS output and source map match a fresh
  compile under both supported Node majors.
- All six isolated hostile mutations were rejected for the intended reason:
  compiler pin, lockfile artifact, explicit type roots, maintained guidance,
  plan contract, and supported Node boundary.
- `npm outdated --json` no longer reports TypeScript. Only `@types/node` 25
  and `@types/vscode` 1.125 remain newer, as intentionally excluded API and
  runtime compatibility changes.

---

## Sources

- TypeScript 6.0 release notes:
  `https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html`
- TypeScript team announcement, March 23, 2026:
  `https://devblogs.microsoft.com/typescript/announcing-typescript-6-0/`
