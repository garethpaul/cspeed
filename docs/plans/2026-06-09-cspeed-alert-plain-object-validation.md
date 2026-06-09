# CSpeed Alert Plain Object Validation

status: completed
date: 2026-06-09

## Goal

Keep webview alert parsing limited to object-shaped message payloads instead of
accepting arrays with attached alert fields.

## Changes

- Rejected array payloads before alert field ownership and text validation.
- Kept normalized alert parsing synchronized between TypeScript source and the
  checked-in compiled output.
- Documented and enforced the plain-object alert message contract in the
  baseline checker, README, changelog, and vision.

## Verification

- `npm run compile`
- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
