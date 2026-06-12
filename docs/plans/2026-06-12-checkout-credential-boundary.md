# Checkout Credential Boundary

## Status: Completed

## Context

The existing GitHub Actions workflow needs repository contents only long enough
to install dependencies and run the local verification gate. The checkout
credential is unnecessary after source retrieval and should not remain in the
job's Git configuration.

## Objectives

- Disable checkout credential persistence without changing CI coverage.
- Keep the action pin, read-only permissions, Node 22/24 matrix, and baseline
  command unchanged.
- Add an exact static contract that rejects duplicate workflows, checkout
  steps, or credential-boundary declarations.

## Work Completed

- Added `persist-credentials: false` to the pinned checkout step.
- Extended `scripts/check-baseline.sh` to require one workflow, one pinned
  checkout, and one credential-free checkout declaration.
- Updated the repository documentation to record the narrower CI credential
  boundary.

## Verification

- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
- Hostile mutations removing or duplicating the checkout boundary were
  rejected by the baseline checker.

## Remaining Risk

The extension was not launched in a VS Code extension host; this workflow-only
change does not alter extension runtime behavior.
