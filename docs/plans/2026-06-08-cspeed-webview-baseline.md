---
title: CSpeed Webview Baseline
type: fix
status: completed
date: 2026-06-08
---

# CSpeed Webview Baseline

## Summary

Bring the VS Code sidebar webview sample to a safer and more reproducible
baseline by aligning package metadata with the lockfile, adding a real `npm
test` gate, and hardening webview HTML/message handling.

## Problem Frame

The repository has TypeScript source and checked-in compiled output, but no
`npm test` command. `package-lock.json` already references a newer TypeScript
and ESLint baseline than `package.json`, which makes reproducible installs
unclear. The webview also renders script-enabled HTML without a content security
policy and accepts webview messages without validating shape or text bounds.

## Requirements

- R1. `package.json` and `package-lock.json` must agree on package metadata and
  TypeScript/ESLint toolchain dependencies.
- R2. `npm test` must compile TypeScript and run a source baseline gate.
- R3. Webview HTML must include a content security policy with a script nonce.
- R4. Webview local resource roots must be limited to `media/`.
- R5. Extension-host message handling must validate command shape and bound
  alert text length before calling VS Code APIs.
- R6. README, changelog, and plan docs must describe the baseline.

## Implementation Units

### U1. Package And Verification Baseline

- **Goal:** Make installs and local verification reproducible.
- **Files:** `package.json`, `package-lock.json`, `.gitignore`,
  `scripts/check-baseline.sh`
- **Verification:** `npm test`, `npm run lint`, `npm audit --audit-level=high`

### U2. Webview Security Baseline

- **Goal:** Keep script-enabled webview behavior constrained and inspectable.
- **Files:** `src/extension.ts`, `out/extension.js`
- **Verification:** `npm run compile`, `scripts/check-baseline.sh`

### U3. Maintenance Docs

- **Goal:** Document setup, verification, and future work for the sample.
- **Files:** `README.md`, `CHANGES.md`,
  `docs/plans/2026-06-08-cspeed-webview-baseline.md`
- **Verification:** `scripts/check-baseline.sh`, `git diff --check`

## Risks & Dependencies

- This pass does not add VS Code Extension Host integration tests.
- The compiled `out/` directory remains checked in and must stay synchronized
  with `src/extension.ts`.
- Future UI expansion should move webview JavaScript into `media/` and keep the
  CSP strict.
