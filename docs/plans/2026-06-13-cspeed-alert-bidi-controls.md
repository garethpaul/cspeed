---
title: CSpeed Alert Bidirectional Control Guard
type: security
status: planned
date: 2026-06-13
---

# CSpeed Alert Bidirectional Control Guard

## Status: Planned

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
