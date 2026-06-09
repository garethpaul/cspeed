---
title: CSpeed Alert Own Properties
type: security
status: completed
date: 2026-06-09
---

# CSpeed Alert Own Properties

## Problem Frame

The extension host validates webview alert messages before showing VS Code
notifications. The parser checked `command` and `text` values, but it accepted
those fields through inherited properties as well as fields owned by the
message object.

## Scope Boundaries

- Preserve the existing `alert` command.
- Preserve normalized, bounded, single-line alert text.
- Do not add new commands or extension-host behavior.
- Keep checked-in compiled output synchronized with TypeScript source.

## Implementation Units

### U1: Require Owned Alert Fields

Files:

- Modify `src/extension.ts`

Approach:

- Keep the existing object-shape check.
- Require `command` and `text` to be own properties before reading values.

### U2: Guard Source, Output, And Docs

Files:

- Modify `scripts/check-baseline.sh`
- Regenerate `out/extension.js`
- Modify `README.md`
- Modify `VISION.md`
- Modify `SECURITY.md`
- Modify `CHANGES.md`

Approach:

- Extend the source baseline to require own-property checks in TypeScript and
  compiled JavaScript.
- Document the message-validation contract for future webview changes.

## Verification

- `npm run compile`
- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
