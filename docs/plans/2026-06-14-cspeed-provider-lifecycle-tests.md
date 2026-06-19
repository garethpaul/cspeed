# Exercise the Sidebar Provider Lifecycle

Status: Completed

## Context

The extension has strong alert parser and dispatch coverage, but its VS Code
integration remains embedded in `src/extension.ts`. The current Node tests do
not prove activation registers the contributed view, provider resolution scopes
local resources, installs CSP-backed HTML, connects validated alerts to VS Code
notifications, or releases the per-view message listener when the view closes.

This stage extracts the provider behind typed dependencies so its lifecycle can
be tested deterministically without weakening the existing parser boundary.

## Requirements

- R1. Keep extension activation registered to the contributed
  `sidebarWebviewView` identifier and retain the registration in
  `ExtensionContext.subscriptions`.
- R2. Preserve script enablement, the media-only local resource root, generated
  HTML, cryptographic nonce, CSP, and external media script behavior.
- R3. Route accepted webview alert messages through the existing validated
  dispatcher and suppress notifications for rejected messages.
- R4. Dispose each webview message subscription when its owning view is
  disposed.
- R5. Add deterministic Node tests and static contracts for registration,
  resolution, dispatch, rejection, and cleanup.

## Implementation Units

### 1. Provider module

Files:

- `src/sidebarProvider.ts`
- `src/extension.ts`

Move provider behavior into a module with typed VS Code dependencies, retain the
existing HTML security boundary, and bind message-listener disposal to the view
lifecycle.

### 2. Lifecycle regression suite

Files:

- `test/sidebarProvider.test.js`
- `test/extension.test.js`

Exercise the compiled provider and activation entry point with deterministic
VS Code fakes. Prove accepted and rejected alert behavior plus exact disposal
ownership.

### 3. Repository contracts and evidence

Files:

- `scripts/check-baseline.sh`
- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `AGENTS.md`

Keep generated output and documentation synchronized with the lifecycle test
boundary and completed verification.

## Verification

Verification: Completed

- Node 22.22.2 and Node 24.16.0 each pass clean lockfile installation,
  zero-warning lint, all 17 Node tests, source contracts, generated-output
  comparison, and a zero-vulnerability moderate-severity audit through full
  `make check`.
- Ten focused hostile mutations alter view registration, registration
  retention, resource scoping, validated dispatch, listener disposal,
  notification/disposal/activation assertions, or test wiring; every mutation
  is rejected.
- TypeScript, JavaScript, shell, whitespace, exact-diff, generated-output,
  artifact, and credential-shaped addition audits pass.
- Plan-aware correctness, testing, maintainability, project-standards,
  security, and reliability review found no actionable issues.
- `agent-browser` was unavailable and the project exposes no HTTP route; no
  browser or live VS Code Extension Host execution is claimed.

## Work Completed

- Extracted the sidebar provider behind the two VS Code dependencies needed by
  deterministic tests while keeping activation as the thin runtime adapter.
- Preserved CSP-backed HTML, cryptographic nonce generation, scoped media
  resources, the declared view identifier, and validated alert dispatch.
- Bound each webview message subscription to its owning view's disposal event.
- Added compiled-output tests for activation registration, provider resolution,
  accepted and rejected notifications, and listener cleanup.

## Scope Boundaries

- Do not change alert parsing rules, notification text, view identifiers, CSP,
  or media assets.
- Do not add an Extension Host download or graphical test dependency in this
  focused stage.
- Do not claim live VS Code rendering, sidebar interaction, or notification UI
  coverage from the deterministic Node suite.

This change claims no browser or live VS Code Extension Host execution.
