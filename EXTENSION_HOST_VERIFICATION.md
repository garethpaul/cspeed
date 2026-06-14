# CSpeed Extension Host Verification Matrix

Use this matrix only for an exact implementation commit. Record the commit SHA and pull request
before testing so sidebar, webview, notification, and disposal evidence cannot
be transferred to a different extension implementation.

## Evidence Rules

- Use a synthetic empty workspace and synthetic alert text with no user,
  employer, customer, repository, source-code, or account information.
- Record the VS Code version, platform, profile class, workspace trust state,
  result, and sanitized evidence identifier.
- Do not include usernames, filesystem paths, workspace contents, extension
  profile data, telemetry, unrelated editor UI, VSIX files, logs, or archives.
- Store durable evidence outside git. Link only a sanitized run, screenshot, or
  short log excerpt by stable identifier.
- Record each result as `pass`, `fail`, `blocked`, or `not run`, with an owner
  and follow-up for every result other than `pass`.
- Do not convert `not run` into passing evidence.

## Run Identity

| Field | Value |
| --- | --- |
| Commit SHA | `not run` |
| Pull request | `not run` |
| VS Code version | `not run` |
| Platform | `not run` |
| Isolated profile class | `not run` |
| Workspace trust state | `not run` |
| Synthetic workspace | `not run` |
| Evidence location | `not run` |

## Verification Matrix

| Scenario | Expected evidence | Result | Evidence |
| --- | --- | --- | --- |
| Install exact-head extension | The development extension loads without VSIX packaging or unrelated profile state. | `not run` | `not run` |
| Activation by contributed view | Opening `sidebarWebviewView` activates the extension and registers one provider. | `not run` | `not run` |
| Sidebar view render | The contributed Explorer view resolves and displays the expected hardened webview content. | `not run` | `not run` |
| CSP and media loading | Only the nonce-authorized script and media-root resource load; base URI, forms, and default loads remain disabled. | `not run` | `not run` |
| Valid alert notification | Synthetic normalized alert text produces exactly one VS Code information notification. | `not run` | `not run` |
| Oversized alert | Text beyond the configured limit is rejected without a notification or Extension Host error. | `not run` | `not run` |
| Control-character alert | Display controls and line separators are rejected before notification dispatch. | `not run` | `not run` |
| Bidirectional-control alert | Ordering controls are rejected while ordinary Arabic and Hebrew text remains accepted. | `not run` | `not run` |
| Hostile object shape | Accessor-backed, proxy-trapped, inherited, or non-record payloads do not invoke accessors or escape errors. | `not run` | `not run` |
| View disposal | Closing the view disposes its message listener and later messages cannot emit notifications. | `not run` | `not run` |
| View reopen | Reopening creates one fresh listener without duplicate notifications from the disposed view. | `not run` | `not run` |
| Extension Host reload | Reload restores one provider and one listener without retaining prior webview state. | `not run` | `not run` |
| Multiple windows | Separate isolated windows do not share message listeners, notifications, or workspace content. | `not run` | `not run` |
| Restricted workspace | Trusted and restricted synthetic workspaces preserve the same local-only sidebar behavior. | `not run` | `not run` |

## Current Status

No browser, VS Code desktop, Extension Host, rendered webview, notification,
view disposal, multi-window, or workspace trust scenario was executed for this checklist.
Treat every VS Code, sidebar, webview, notification, disposal, and workspace row as unexecuted
until evidence is attached to the exact commit.
