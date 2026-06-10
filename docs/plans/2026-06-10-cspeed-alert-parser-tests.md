---
title: CSpeed Alert Parser Tests
type: test
status: completed
date: 2026-06-10
---

# CSpeed Alert Parser Tests

## Summary

Replace source-text-only confidence in the webview message boundary with
executable tests that run without a VS Code extension host.

## Work Completed

- Extracted alert parsing into the pure `src/alertMessage.ts` module.
- Kept `extension.ts` responsible only for wiring validated messages to VS Code.
- Added Node built-in tests for valid normalization, null-prototype records,
  arrays, custom prototypes, inherited or missing properties, wrong field
  types, whitespace-only text, multiline text, and the 200-character limit.
- Updated `npm test` to compile, run the executable tests, and then run the
  existing source baseline.
- Extended the baseline to require the parser source, tests, generated output,
  extension import, rooted Make targets, and Ubuntu 24.04 CI runner.
- Updated README, SECURITY, VISION, and CHANGES with the test boundary.

## Verification

- `npm ci`
- `npm test`
- `npm run verify`
- `make check`
- `make -f /absolute/path/to/Makefile check`
- Mutation checks for removed test cases, parser wiring, test execution, Make
  rooting, runner drift, and incomplete plan status
- `sh -n scripts/check-baseline.sh`
- `git diff --check`

No extension was published and no external service was contacted beyond npm's
dependency and audit endpoints.
