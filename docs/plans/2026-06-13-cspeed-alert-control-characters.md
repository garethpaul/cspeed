---
title: CSpeed Alert Control Character Guard
type: security
status: completed
date: 2026-06-13
---

# CSpeed Alert Control Character Guard

## Summary

Reject display-control characters and Unicode line separators before webview
alert text reaches VS Code notifications.

## Priorities

1. Reject C0 controls, DEL/C1 controls, and Unicode line and paragraph
   separators after existing whitespace normalization.
2. Prove rejected payloads do not cross the notification dispatch boundary.
3. Preserve ordinary Unicode text, the 200-character limit, command schema,
   CSP, and generated-output contract.

## Requirements

- Keep validation in the pure `parseAlertMessage` boundary.
- Add focused parser cases for tabs, NUL, DEL, C1 controls, and `U+2028` /
  `U+2029` separators.
- Add dispatch coverage proving control-character payloads emit no
  notifications.
- Extend the static baseline and maintenance documentation.
- Pass supported Node 22 and 24 verification, external-working-directory
  checks, generated-output validation, audit, and hostile mutations.

## Non-Goals

- Launching a VS Code extension host.
- Changing the webview command schema or notification text length limit.
- Rejecting ordinary non-ASCII text.
- Refactoring webview HTML, CSP, or provider registration.

## Verification

Completed on 2026-06-13:

- `npm run verify` passed on Node 22.22.1 and Node 24.16.0 with zero-warning
  lint, nine Node tests, generated-output verification, and zero audit
  vulnerabilities.
- `make check` passed from the worktree and through the absolute Makefile path
  from `/tmp`.
- Ten hostile mutations were rejected across the parser behavior, C1 and
  Unicode-separator ranges, parser and dispatch tests, generated output,
  documentation, and completed-plan evidence.
- `sh -n scripts/check-baseline.sh`, `git diff --check`, focused diff review,
  and a staged secret-pattern scan passed.
- A VS Code extension host was not launched, so sidebar rendering and live
  notification behavior remain outside this local verification record.
