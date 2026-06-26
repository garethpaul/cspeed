# Changes

## 2026-06-26

- Removed unused local image and stylesheet permissions from the sidebar
  webview CSP so the current HTML permits only its nonce-authorized media
  script while retaining the existing default, base URI, and form denials.
- Added executable and source-baseline contracts for the script-only policy.
- Repository and external-directory `make check` passed all 30 Node tests,
  lint, generated-output parity, and a zero-finding moderate audit; isolated
  source and test-contract mutations failed for the intended reason.

## 2026-06-25

- Refreshed typescript-eslint 8.62.0 with exact package-family artifacts
  while preserving TypeScript 6.0.3, ESLint 10.5.0, and the Node 22/24 gate;
  Node 25 remains a deferred compatibility change.
- Revalidated the Make launcher boundary and stopped hostile-path test fixtures
  from recursively copying installed dependencies and local generated state.
- Rejected forged neighboring checkouts before Make execution by binding the
  supplied repository path to the trusted launcher's own canonical root.
- Restored checkout-rooted public Make recipes so trusted absolute `make -f`
  invocations remain location-independent.

## 2026-06-22

- Added one validated Node launcher for repository verification paths and
  targets, with exact root identity, target allowlisting, and Make control
  environment removal before private targets run.
- Kept direct `make` commands as trusted developer conveniences only and
  documented that raw Make parsing is not a hostile-input boundary.
- Added regression coverage for compact directory redirection, Make function
  evaluation channels, hostile path bytes, checkout collisions, exact npm
  argv, and failure propagation.

## 2026-06-18

- Rejected the full Unicode format-character class in webview alert text,
  including high-plane tag format characters.
- Migrated the checked-in extension build to TypeScript 6.0.3 with explicit
  Node and VS Code type roots while preserving Node 22/24 and VS Code 1.120.

## 2026-06-17

- Rejected Unicode invisible operators in webview alert text before VS Code
  notification dispatch.
- Refreshed the exact development baseline to ESLint 10.5.0,
  typescript-eslint 8.61.1, and @types/node 22.19.21 with reviewed lockfile
  artifacts; Node 25 remains a deferred compatibility change.

## 2026-06-15

- Rejected malformed lone UTF-16 surrogates in webview alert text while
  preserving valid surrogate-pair emoji.
- Rejected invisible Unicode format controls in webview alert text before VS
  Code notification dispatch.

## 2026-06-14

- Added an exact-head VS Code Extension Host verification matrix with
  privacy-safe evidence fields and every integration row explicitly unexecuted.
- Extracted the sidebar provider behind typed VS Code dependencies and added
  deterministic activation, resource-scoping, HTML, dispatch, and lifecycle
  tests.
- Bound each webview message listener to its owning view's disposal lifecycle.

## 2026-06-13

- Rejected Unicode bidirectional ordering controls in webview alert text while
  preserving ordinary Arabic and Hebrew notifications.
- Rejected accessor-backed and trap-throwing alert objects without invoking
  getters or propagating reflection failures through notification dispatch.
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
