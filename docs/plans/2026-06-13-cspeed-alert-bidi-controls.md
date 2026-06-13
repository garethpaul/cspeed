---
title: CSpeed Alert Bidirectional Control Guard
type: security
status: completed
date: 2026-06-13
---

# CSpeed Alert Bidirectional Control Guard

## Status: Completed

## Problem Frame

Webview alert text rejects C0/C1 controls and Unicode line separators but still
accepts invisible bidirectional ordering controls. Those code points can reorder
visible notification text and obscure the apparent source or meaning of an
extension-host alert.

Unicode Standard 17.0, section 23.2.5, defines the relevant ordering controls as
`U+061C`, `U+200E-U+200F`, `U+202A-U+202E`, and `U+2066-U+2069`:
<https://www.unicode.org/versions/Unicode17.0.0/core-spec/chapter-23/>

## Scope Boundaries

- Reject exactly the Unicode bidirectional ordering controls above anywhere in
  candidate alert text.
- Preserve ordinary Arabic, Hebrew, and other international text.
- Preserve the existing own-data-property, prototype, accessor, control,
  trimming, single-line, and 200-character contracts.
- Do not change webview CSP, notification APIs, dependencies, or workflows.

## Requirements

- R1. Parsing must reject every Unicode bidirectional ordering control before
  trimming or dispatch.
- R2. Tests must cover the isolated controls, range boundaries, a mixed spoofing
  payload, and valid right-to-left text without controls.
- R3. Dispatch tests must prove rejected bidi-control payloads produce no
  notification.
- R4. Generated output, maintenance documentation, and completed-plan evidence
  must remain synchronized through mutation-sensitive static contracts.

## Implementation

- Extend `containsDisplayControlCharacter` with the exact Unicode control set.
- Add parser and dispatch fixtures for bidi controls and valid right-to-left
  text.
- Update the baseline checker, README, SECURITY, CHANGES, VISION, AGENTS, and
  this plan.

## Verification

- `npm test`
- `npm run lint`
- `npm run check:generated`
- `npm run verify`
- `make check`
- Absolute-path Make invocation from `/tmp`
- Node 22 and Node 24 verification
- `npm audit --json`
- `git diff --check`
- Isolated hostile mutations for each code-point group, parser/dispatch test
  weakening, documentation drift, stale plan status, and missing evidence

## Risks

- Rejecting all right-to-left text would be an unacceptable regression; tests
  must distinguish script characters from ordering controls.
- The source and checked-in JavaScript output must stay identical after the
  TypeScript compile step.

## Work Completed

- Rejected all 12 Unicode bidirectional ordering controls from candidate alert
  text before normalization and notification dispatch.
- Added parser coverage for every control, a mixed RTL-override spoofing
  payload, and valid Arabic/Hebrew text without ordering controls.
- Added dispatch, source/output parity, documentation, and completed-plan
  contracts for the boundary.

## Verification Completed

- Node `22.22.2` and Node `24.16.0` each passed `npm run verify`.
- `make check` and the absolute-path Make invocation from `/tmp` passed.
- All 13 parser and dispatch tests passed on both supported Node majors.
- `npm run check:generated` confirmed the TypeScript source and checked-in
  JavaScript output are synchronized.
- `npm audit --json` reported zero vulnerabilities at every severity.
- `sh -n scripts/check-baseline.sh`, staged and unstaged `git diff --check`,
  secret-pattern, artifact, and untracked-file checks passed.
- Ten isolated hostile mutations were rejected across all four code-point
  groups, parser and dispatch fixtures, valid RTL acceptance, documentation,
  plan status, and verification evidence.
- A VS Code extension host was not launched; the pure parser and dispatch
  boundaries are fully exercised without invoking VS Code APIs.
