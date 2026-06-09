---
title: CSpeed Crypto Webview Nonce
type: security
status: completed
date: 2026-06-09
---

# CSpeed Crypto Webview Nonce

## Problem Frame

The webview CSP already required a per-render script nonce, but `getNonce`
generated that value with `Math.random`. The extension host runs in Node, so it
can use `crypto.randomBytes` for a stronger nonce without adding dependencies.

## Scope Boundaries

- Preserve the existing webview HTML, CSP shape, and message handling behavior.
- Keep scripts enabled only for the nonce-scoped inline script.
- Keep checked-in compiled output synchronized with TypeScript source.
- Do not introduce a bundler or broader webview UI changes.

## Implementation Units

### U1: Generate Nonce With Crypto

Files:

- Modify `src/extension.ts`

Approach:

- Import `randomBytes` from Node `crypto`.
- Return a base64 nonce from `randomBytes(16)`.
- Remove the manual character loop and `Math.random` dependency.

### U2: Guard Source And Output

Files:

- Modify `scripts/check-baseline.sh`
- Regenerate `out/extension.js`

Approach:

- Fail if source nonce generation no longer uses `randomBytes`.
- Fail if `Math.random()` returns in nonce generation.
- Fail if compiled output is not synchronized with the crypto nonce source.

### U3: Document The Security Contract

Files:

- Modify `README.md`
- Modify `VISION.md`
- Modify `CHANGES.md`

Approach:

- Record that the webview uses a crypto-generated CSP nonce.
- Keep future webview changes aligned with the existing CSP baseline.

## Verification

- `npm run compile`
- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
