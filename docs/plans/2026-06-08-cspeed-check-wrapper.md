---
title: CSpeed Check Wrapper
type: chore
status: completed
date: 2026-06-08
---

# CSpeed Check Wrapper

## Summary

Add a repository-standard `make check` entry point that delegates to the
existing npm verification gate for the VS Code webview sample.

## Requirements

- R1. `make check` must run the same lint, compile-backed test, baseline, and
  high-severity audit checks as `npm run verify`.
- R2. The Makefile must expose focused `lint`, `test`, `audit`, and `verify`
  targets for local maintenance.
- R3. README, CHANGES, and baseline checks must document and preserve the root
  check wrapper.

## Verification

- `make check`
- `npm run verify`
- `git diff --check`
