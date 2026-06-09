# Changes

## 2026-06-09

- Required webview alert messages to provide own `command` and `text`
  properties before the extension host reads them.
- Loaded the sidebar webview button handler from `media/main.js` through a
  nonce-scoped VS Code webview URI and removed stale timer script behavior.
- Added an explicit root `make build` gate for TypeScript compilation and wired
  `make verify` through lint, test, build, and audit targets.
- Normalized webview alert text before displaying VS Code notifications and
  rejected multiline alert payloads.
- Switched the webview CSP nonce from `Math.random` to Node `crypto.randomBytes`
  and guarded the compiled output sync.

## 2026-06-08

- Added a root `make check` wrapper for the existing npm verification gate.
- Rejected empty or whitespace-only webview alert messages before showing VS
  Code notifications.
- Added a compile-backed `npm test` gate and a source baseline check for the VS
  Code webview sample.
- Aligned `package.json` with the checked-in TypeScript and ESLint lockfile
  baseline.
- Hardened the sidebar webview with a content security policy, nonce-scoped
  script, narrower local resource roots, and validated extension-host messages.
- Added a combined `npm run verify` gate and made lint fail on warnings.
