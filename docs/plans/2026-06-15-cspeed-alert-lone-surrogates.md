---
title: CSpeed Alert Lone Surrogate Guard
type: security
status: completed
date: 2026-06-15
---

# CSpeed Alert Lone Surrogate Guard

## Status: Completed

## Problem Frame

Webview messages can contain malformed JavaScript strings with isolated UTF-16
high or low surrogate code units. The alert parser accepts those values even
though they do not represent Unicode scalar values and may render or copy as
replacement characters. Valid surrogate pairs such as emoji must remain valid.

## Scope Boundaries

- Reject isolated `U+D800-U+DFFF` code units in alert text.
- Preserve valid surrogate-pair emoji and all existing ordinary Unicode/RTL
  acceptance.
- Preserve own-property, accessor, prototype, trimming, control, bidi, format,
  length, dispatch, CSP, dependency, and workflow behavior.

## Requirements

- R1. Parsing and dispatch must reject lone high and low surrogates.
- R2. Valid non-BMP emoji must remain accepted and normalized.
- R3. Source and checked-in compiled output must stay synchronized.
- R4. Static contracts must reject parser, test, documentation, generated-output,
  plan-status, and verification-evidence drift.

## Verification

- Focused parser and dispatch tests
- `npm run verify`
- repository and external-directory `make check`
- isolated hostile mutations for both surrogate ranges, emoji preservation,
  dispatch coverage, documentation, generated output, and completed evidence
- exact diff, generated artifact, conflict marker, and credential audits

## Risks

- A VS Code Extension Host remains required for live notification verification.

## Work Completed

- Rejected isolated high and low UTF-16 surrogate code units before alert
  normalization or notification dispatch.
- Preserved valid surrogate-pair emoji and existing ordinary Unicode/RTL text.
- Added parser, dispatch, generated-output, documentation, and completed-plan
  contracts.

## Verification Completed

- Supported Node `22.22.2` passed all 19 tests and `npm run verify`, including
  lint, compilation, generated-output parity, the static baseline, and an audit
  with zero findings.
- Eight hostile mutations were rejected across source/output guards, high/low
  surrogate tests, emoji preservation, dispatch coverage, documentation, plan
  status, and verification evidence.
- Repository and external-directory `make check` passed with Node `22.22.2`.
- A VS Code Extension Host was not launched; live notification rendering
  remains covered by the existing verification matrix.
