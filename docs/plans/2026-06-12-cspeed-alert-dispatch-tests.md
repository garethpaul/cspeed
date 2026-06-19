---
title: CSpeed Alert Dispatch Tests
type: test
status: completed
date: 2026-06-12
---

# CSpeed Alert Dispatch Tests

## Summary

Add executable coverage for the extension-host boundary between validated
webview messages and VS Code notifications. Keep the VS Code-specific provider
wiring small while making its notification side effect testable with Node's
built-in test runner.

## Priorities

1. Verify that a valid alert produces exactly one notification with normalized
   text.
2. Verify that rejected webview payloads never produce notifications.
3. Preserve the existing parser contract and sidebar provider behavior.
4. Keep tests independent of a running VS Code extension host.

## Requirements

- R1. The extension must route received webview messages through one exported
  alert-dispatch function.
- R2. A valid alert must call the supplied notification function exactly once
  with trimmed text.
- R3. Invalid, empty, multiline, oversized, inherited, and wrong-command
  payloads must not call the notification function.
- R4. The dispatch function must report whether a notification was emitted so
  the outcome is directly assertable.
- R5. `npm test` and the static baseline must require the dispatch source,
  compiled output, tests, and provider wiring.
- R6. README, VISION, and CHANGES must record the executable boundary.

## Non-Goals

- Launching a VS Code extension host.
- Changing the alert payload schema or 200-character limit.
- Adding new webview commands or notification types.
- Refactoring webview HTML generation.

## Work Completed

- Added `src/alertMessageHandler.ts` as the pure boundary between parser output
  and notification display.
- Routed the sidebar provider's message callback through the dispatch function.
- Added Node tests for one normalized notification and zero notifications from
  rejected payloads.
- Extended the static baseline and maintenance documentation to preserve the
  executable dispatch contract.
- Added a generated-output gate that recompiles TypeScript and fails when the
  checked-in `out/` tree differs from the generated result.

## Verification

- `npm test`
- `npm run verify`
- `make check`
- Mutation check: bypassing the dispatch function in `extension.ts` must fail.
- Mutation check: removing dispatch test execution must fail.
- Mutation check: changing checked-in dispatch output without the matching
  TypeScript source must fail the generated-output gate.
- `sh -n scripts/check-baseline.sh`
- `git diff --check`
