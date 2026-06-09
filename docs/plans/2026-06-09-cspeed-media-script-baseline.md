# CSpeed Media Script Baseline

Status: Completed
Date: 2026-06-09

## Goal

Keep the sidebar webview button handler in the checked media script and remove
stale Cat Coding timer behavior from the active webview asset path.

## Changes

- Loaded `media/main.js` through `webview.asWebviewUri(...)` from the sidebar
  HTML while keeping the nonce-scoped script policy.
- Replaced the stale timer/counter media script with the current sidebar button
  message handler.
- Extended the source baseline to require the external media script, compiled
  output sync, and stale-script rejection.
- Documented the media script contract in the README, changelog, and vision.

## Verification

- `scripts/check-baseline.sh`
- `npm run lint`
- `npm test`
- `npm run compile`
- `npm audit --audit-level=high`
- `npm run verify`
- `make lint`
- `make test`
- `make build`
- `make audit`
- `make check`
- `git diff --check`
