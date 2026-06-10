# CSpeed CI Baseline

## Status: Completed

## Context

`cspeed` has a local npm-backed `make check` gate for lint, compile, baseline,
and audit checks. The repository needs a lightweight GitHub Actions gate so the
VS Code webview CSP and message-validation baseline runs before review.

## Objectives

- Run the existing Node verification baseline in GitHub Actions.
- Install dependencies from the checked-in lockfile with `npm ci`.
- Refresh the supported Node, VS Code API, lint, and TypeScript baselines.
- Pin third-party actions and keep repository access read-only.
- Make the CI workflow presence part of the source baseline contract.

## Work Completed

- Added `.github/workflows/check.yml` to run `npm ci` and `make check` on
  pushes, pull requests, and manual dispatches.
- Set up Node 22 and 24 with npm caching in CI.
- Updated to exact current compatible dependency pins: ESLint 10.4.1,
  typescript-eslint 8.61.0, TypeScript 5.9.3, current VS Code/webview types,
  and Stylistic 5.10.0.
- Pinned checkout and Node setup actions to reviewed commits, limited
  repository access to read-only, and bounded execution with timeout and
  concurrency cancellation.
- Extended `scripts/check-baseline.sh` to require the CI workflow and this
  completed plan.
- Updated README, VISION, SECURITY, and CHANGES with the CI baseline.

## Verification

- `make check`
- `npm run verify`
- Node 22 and Node 24 clean installs
- `npm outdated --json` (only intentionally deferred TypeScript 6 and Node 25
  type majors remain)
- `git diff --check`

## Follow-Up Candidates

- Add VS Code extension-host tests after the webview behavior has a small
  harness.
