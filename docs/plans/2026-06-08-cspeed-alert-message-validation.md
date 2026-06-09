---
title: CSpeed Alert Message Validation
type: fix
status: completed
date: 2026-06-08
---

# CSpeed Alert Message Validation

## Summary

Tighten extension-host webview message validation so alert messages must be
strings, non-empty after trimming, and length-bounded before VS Code shows a
notification.

## Requirements

- R1. Webview messages still require `command: "alert"`.
- R2. Alert text must be a string.
- R3. Alert text must not be empty after trimming.
- R4. Alert text remains capped at 200 characters.
- R5. README, changelog, source baseline, and compiled output stay synchronized.

## Verification

- `npm run lint`
- `npm test`
- `npm run verify`
- `git diff --check`
