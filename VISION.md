## CSpeed Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

CSpeed is a minimal VS Code extension sample that contributes a sidebar webview
and sends messages from the webview back to the extension host.

The repository currently combines a Cat Coding-style README with a simpler
sidebar implementation in `src/extension.ts`. The useful project surface is the
sidebar webview provider, package manifest, and TypeScript build.

The goal is to keep the extension a clear, safe starting point for VS Code
webview experiments.

The current focus is:

Priority:

- Preserve the minimal sidebar webview contribution
- Keep extension-to-webview messaging easy to inspect
- Maintain TypeScript compilation through `npm run compile`
- Keep root build verification tied to TypeScript compilation
- Keep webview script permissions and local-resource roots explicit
- Keep webview base URI and form submission behavior explicitly disabled
- Keep the webview button handler in the checked media script
- Generate webview CSP nonces with Node crypto rather than `Math.random`
- Normalize webview alert text before displaying VS Code notifications
- Require owned alert message fields before the extension host reads them
- Reject array alert payloads before field validation
- Reject non-record alert payload prototypes before field validation
- Keep the pure webview alert parser covered by executable acceptance and
  rejection tests
- Keep local VS Code workspace metadata out of the shared project baseline
- Keep the npm-backed `make check` baseline running in GitHub Actions

Next priorities:

- Align the README with the actual sidebar webview implementation
- Add a small test or compile gate for CI
- Strengthen webview content security policy before adding richer UI
- Keep package metadata and contributed commands/views accurate

Contribution rules:

- One PR = one focused extension, webview, or documentation change.
- Run `npm ci` and `npm run verify` before pushing TypeScript changes.
- Do not add webview capabilities without documenting security impact.
- Keep generated output in sync only if the repository continues to check it in.

## Security

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

VS Code webviews can run scripts. Changes should keep local resource roots
limited, avoid loading remote scripts, and use a content security policy before
the webview handles meaningful user data.

Messages from the webview should be validated before triggering extension-host
behavior. Notification text should be trimmed, bounded, and kept to a single
line before display. Alert payloads should provide owned fields rather than
inherited properties, and array or non-record object payloads should not pass
object validation. Executable tests should verify both sides of the dispatch
boundary: accepted messages emit one normalized notification and rejected
messages emit none.

## What We Will Not Merge (For Now)

- Remote script loading in the webview
- Broad extension features before README and package metadata are aligned
- Message handlers that execute arbitrary commands
- TypeScript changes that cannot compile locally

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
