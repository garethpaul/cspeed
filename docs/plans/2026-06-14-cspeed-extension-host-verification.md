# CSpeed Extension Host Verification Matrix

Status: In Progress

## Problem

Node tests cover alert parsing and dispatch, contributed-view registration,
media-only resource scoping, CSP-backed HTML, and view-owned listener disposal.
The repository does not define repeatable exact-head evidence for those
contracts inside a live VS Code Extension Host and rendered sidebar webview.

## Requirements

1. Add an exact-commit matrix for installation, activation, contributed view,
   CSP/resource loading, valid and rejected alerts, bidi controls, view
   disposal, reload, multiple windows, and workspace trust state.
2. Require synthetic alert text and sanitized VS Code, platform, profile,
   workspace, result, and evidence fields with explicit pass, fail, blocked,
   or not-run outcomes.
3. Keep Node, compiled-output, browser, Extension Host, and desktop evidence
   separate so portable checks cannot imply live VS Code execution.
4. Add mutation-sensitive contracts for the matrix, repository guidance, and
   completed plan evidence.

## Scope Boundaries

- Do not change TypeScript, compiled JavaScript, media assets, package metadata,
  commands, view contributions, CSP, dependencies, or runtime behavior.
- Do not add workspace contents, usernames, filesystem paths, extension profile
  data, telemetry, screenshots with unrelated UI, VSIX files, logs, or archives.
- Do not claim browser, VS Code desktop, Extension Host, notification, or
  rendered webview execution from Node or static checks.
- Do not merge or close stacked pull requests without explicit authorization.

## Verification

- Pending implementation and bounded repository validation.
