# Changes

## 2026-06-08

- Rejected empty or whitespace-only webview alert messages before showing VS
  Code notifications.
- Added a compile-backed `npm test` gate and a source baseline check for the VS
  Code webview sample.
- Aligned `package.json` with the checked-in TypeScript and ESLint lockfile
  baseline.
- Hardened the sidebar webview with a content security policy, nonce-scoped
  script, narrower local resource roots, and validated extension-host messages.
- Added a combined `npm run verify` gate and made lint fail on warnings.
