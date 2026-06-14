# Exercise the Sidebar Provider Lifecycle

Status: In Progress

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

Verification: Pending

- Run TypeScript compilation, zero-warning lint, Node tests, generated-output
  comparison, source contracts, dependency audit, and full `make check`.
- Run focused hostile mutations against registration, resource scoping,
  dispatch, rejection, disposal, test wiring, and plan completion evidence.
- Inspect the exact diff, generated output, artifacts, and credential-shaped
  additions before committing.

## Scope Boundaries

- Do not change alert parsing rules, notification text, view identifiers, CSP,
  or media assets.
- Do not add an Extension Host download or graphical test dependency in this
  focused stage.
- Do not claim live VS Code rendering, sidebar interaction, or notification UI
  coverage from the deterministic Node suite.
