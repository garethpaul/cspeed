# CSpeed Webview CSP Navigation Restrictions

Status: Completed
Date: 2026-06-09

## Goal

Keep the sidebar webview CSP explicit about navigation-adjacent behavior that is
not covered by `default-src 'none'`.

## Changes

- Added `base-uri 'none'` to prevent injected base URL changes.
- Added `form-action 'none'` to prevent form submissions from the webview.
- Extended the static baseline to require the directives in TypeScript source,
  compiled output, README notes, and this plan.

## Verification

- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
