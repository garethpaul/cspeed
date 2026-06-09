---
title: CSpeed Editor Metadata Ignore
type: maintenance
status: completed
date: 2026-06-09
---

# CSpeed Editor Metadata Ignore

## Problem Frame

The repository tracked `.vscode` workspace metadata for launch, tasks,
recommendations, and editor settings. Those files are local editor scaffolding
and can drift independently of the TypeScript extension source and compiled
output.

## Scope Boundaries

- Preserve the extension source, media script, package metadata, and compiled
  output.
- Keep local VS Code workspace settings out of source control.
- Do not change extension activation, webview message handling, or package
  scripts.

## Implementation Units

### U1: Ignore Local Workspace Metadata

Files:

- Modify `.gitignore`
- Remove tracked `.vscode` files

Approach:

- Add `.vscode/` to the local ignore list.
- Remove checked-in `.vscode` launch, task, extension recommendation, and
  editor setting files.

### U2: Guard Source, Docs, And Plans

Files:

- Modify `scripts/check-baseline.sh`
- Modify `README.md`
- Modify `VISION.md`
- Modify `SECURITY.md`
- Modify `CHANGES.md`

Approach:

- Extend the source baseline to require the `.vscode/` ignore rule and fail if
  `.vscode` files are tracked again.
- Document that launch configuration and editor recommendations are local
  workspace state.

## Verification

- `scripts/check-baseline.sh`
- `npm run compile`
- `npm test`
- `npm run lint`
- `make check`
- `git diff --check`
