# CSpeed Alert Object Prototype Guard

Status: Completed
Date: 2026-06-09

## Goal

Keep webview alert payload validation limited to record-like objects before the
extension host reads message fields.

## Changes

- Rejected alert payload objects whose prototype is neither `Object.prototype`
  nor `null`.
- Extended the source baseline to require the prototype guard in TypeScript,
  compiled output, README notes, and the completed plan.
- Documented the prototype guard in the README, changelog, and vision.

## Verification

- `scripts/check-baseline.sh`
- `npm run compile`
- `npm run lint`
- `npm test`
- `npm audit --audit-level=high`
- `make check`
- `git diff --check`
