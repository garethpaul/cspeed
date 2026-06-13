# Changes

## 2026-06-13

- Rejected display control characters and Unicode line separators before
  webview alert text reaches VS Code notifications.

## 2026-06-12

- Stopped GitHub Actions checkout from persisting its credential and added an
  exact static contract for the sole workflow and checkout step.
- Extracted alert notification dispatch into a pure extension-host boundary and
  added executable tests for emitted and suppressed notifications.
- Extended the source baseline to require dispatch wiring, compiled output,
  tests, documentation, and the completed implementation plan.
- Added a generated-output gate that recompiles TypeScript and rejects any
  checked-in `out/` drift.

## 2026-06-10

- Extracted webview alert validation into a pure module and added executable
  Node tests for accepted, normalized, inherited, malformed, multiline, and
  oversized messages.
- Rooted Make targets to the repository and pinned the CI runner to Ubuntu
  24.04.
- Added a lightweight GitHub Actions workflow that runs `npm ci` and
  `make check` for the VS Code webview baseline.
- Updated the supported runtime to Node 22/24, raised the VS Code API baseline
  to 1.120, and refreshed the lint, type, and TypeScript toolchain with exact
  pins.
- Pinned workflow actions, limited repository access to read-only, and raised
  dependency auditing from high to moderate severity.
- Extended the source baseline to require the CI workflow and completed CI
  plan.

## 2026-06-09

- Rejected webview alert payloads with non-record object prototypes before
  reading message fields.
- Added explicit webview CSP directives to disable base URI changes and form
  submissions.
- Required webview alert messages to be plain non-array objects before field
  validation.
- Removed tracked local VS Code workspace metadata and added a baseline guard
  for the `.vscode/` ignore rule.
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
