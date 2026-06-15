---
title: CSpeed Invisible Format Control Guard
type: security
status: completed
date: 2026-06-15
---

# CSpeed Invisible Format Control Guard

## Status: Completed

## Problem Frame

Alert parsing rejects line, display, and bidirectional ordering controls but
still accepts other invisible format controls. Soft hyphen, zero-width
space/joiners, word joiner, and BOM can make notification text render or copy
differently from the submitted value.

## Scope Boundaries

- Reject `U+00AD`, `U+200B-U+200D`, `U+2060`, and `U+FEFF` anywhere in alert text.
- Preserve ordinary Unicode and right-to-left script text without format controls.
- Preserve existing own-property, accessor, prototype, trimming, line, bidi,
  length, dispatch, CSP, dependency, and workflow behavior.

## Requirements

- R1. Parsing must reject each listed invisible format control before dispatch.
- R2. Parser and dispatch tests must cover every group and valid Unicode text.
- R3. Source and checked-in compiled output must stay synchronized.
- R4. Static contracts must reject parser, test, documentation, generated-output,
  plan-status, and verification-evidence drift.

## Verification

- Focused parser and dispatch tests
- `npm run verify`
- `make check` from repository and external directories
- `git diff --check`
- Isolated hostile mutations for every contract group

## Risks

- Zero-width joiners can be meaningful in natural-language shaping; this sample
  intentionally prioritizes unambiguous single-line notification text.
- A VS Code Extension Host remains required for live notification verification.

## Work Completed

- Rejected soft hyphen, zero-width space/joiners, word joiner, and BOM before
  alert normalization or dispatch.
- Added parser and dispatch coverage while preserving ordinary Unicode and RTL
  script acceptance.
- Added source/output, test, documentation, and completed-plan contracts.

## Verification Completed

- TypeScript compilation and all 14 focused parser/dispatch tests passed.
- Eight hostile mutations were rejected across all code-point groups, dispatch
  coverage, documentation, plan status, and verification evidence.
- Ephemeral Node `22` passed `npm run verify`, including lint, all 18 tests,
  generated-output parity, the static baseline, and an audit with zero findings.
- Repository-root and absolute-path `make check` passed with the same supported
  Node `22` npm invocation.
- A VS Code Extension Host was not launched; live sidebar notification rendering
  remains covered by the existing verification matrix.
