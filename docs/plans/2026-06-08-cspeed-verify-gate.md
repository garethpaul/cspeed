---
title: CSpeed Verify Gate
type: chore
status: completed
date: 2026-06-08
---

# CSpeed Verify Gate

## Summary

Add a single `npm run verify` command that runs lint, compile-backed tests,
source baseline checks, and the high-severity dependency audit for the VS Code
webview sample.

## Requirements

- R1. `npm run lint` must fail on ESLint warnings.
- R2. `npm run verify` must run lint before the compile-backed `npm test`.
- R3. The verify command must include `npm audit --audit-level=high`.
- R4. README, CHANGES, and source baseline checks must document and preserve
  the verification gate.

## Verification

- `npm run verify`
- `npm test`
- `npm run lint`
- `npm audit --audit-level=high`
- `git diff --check`
