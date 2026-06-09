# CSpeed Make Build Gate

status: completed
date: 2026-06-09

## Goal

Expose a root `make build` target for TypeScript compilation so the checked-in
extension output can be regenerated through the same top-level wrapper as lint,
tests, and audit.

## Changes

- Added `make build` as a direct wrapper for `npm run compile`.
- Rewired `make verify` to depend on `lint`, `test`, `build`, and `audit`.
- Extended README, changelog, vision, and source-baseline checks for the root
  build gate contract.

## Verification

- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make audit`
- `make check`
- `git diff --check`
