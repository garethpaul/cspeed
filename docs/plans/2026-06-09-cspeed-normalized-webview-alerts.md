---
title: CSpeed Normalized Webview Alerts
type: security
status: completed
date: 2026-06-09
---

# CSpeed Normalized Webview Alerts

## Problem Frame

The extension host already rejected unknown webview commands and empty alert
text, but it displayed the original payload. That left notification text with
leading whitespace, trailing whitespace, or embedded line breaks up to the
webview sender.

## Scope Boundaries

- Preserve the existing `alert` webview command.
- Keep the 200-character alert limit.
- Do not add new commands or extension-host behavior.
- Keep checked-in compiled output synchronized with TypeScript source.

## Implementation Units

### U1: Normalize Alert Payloads

Files:

- Modify `src/extension.ts`

Approach:

- Parse alert messages into a normalized object before handling them.
- Trim alert text before passing it to VS Code notifications.
- Reject empty, overlong, or multiline normalized alert text.

### U2: Guard The Contract

Files:

- Modify `scripts/check-baseline.sh`
- Regenerate `out/extension.js`

Approach:

- Fail the baseline check if alert parsing no longer trims text.
- Fail if the normalized text length bound or single-line check is removed.
- Fail if the compiled extension output drifts from source.

### U3: Document The Baseline

Files:

- Modify `README.md`
- Modify `VISION.md`
- Modify `CHANGES.md`

Approach:

- Record the normalized alert-text behavior in maintenance docs.
- Keep future webview message changes tied to explicit notification-safety
  rules.

## Verification

- `npm run compile`
- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
