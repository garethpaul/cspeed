# cspeed

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/cspeed` is a minimal VS Code sidebar webview extension sample.

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `main` branch. The project language mix found during review was: JavaScript (2), TypeScript (1).

## Repository Contents

- `README.md` - project overview and local usage notes
- `package.json` - JavaScript dependency and script metadata
- `.vscode` - source or example code
- `media` - source or example code
- `out` - source or example code
- `package-lock.json` - JavaScript dependency and script metadata
- `SECURITY.md` - security reporting and disclosure guidance
- `src` - source or example code
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: .vscode, media, out, src
- Dependency and build manifests: package-lock.json, package.json
- Entry points or build surfaces: package.json
- Verification gate: `npm test`

## Getting Started

### Prerequisites

- Git
- Node.js 20 or newer
- npm

### Setup

```bash
git clone https://github.com/garethpaul/cspeed.git
cd cspeed
npm ci
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

Open this repository in VS Code and run the extension host launch
configuration to inspect the contributed sidebar webview.

Detected npm scripts:

- `npm run compile` - `tsc -p ./`
- `npm run check` - `scripts/check-baseline.sh`
- `npm run lint` - `eslint src --ext ts`
- `npm run test` - `npm run compile && npm run check`
- `npm run vscode:prepublish` - `npm run compile`
- `npm run watch` - `tsc -watch -p ./`

## Testing and Verification

Run the local gate before changing extension or webview behavior:

```bash
npm test
npm run lint
npm audit --audit-level=high
```

`npm test` compiles TypeScript and runs `scripts/check-baseline.sh`. The source
baseline checks that the webview has a content security policy, nonce-scoped
script execution, bounded message handling, and synchronized compiled output.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.

## Security and Privacy Notes

- Review changes touching network requests, sockets, or service endpoints; examples from the scan include .vscode/extensions.json, .vscode/launch.json, .vscode/tasks.json.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include .vscode/tasks.json, media/main.js.

## Maintenance Notes

- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.
- See `CHANGES.md` for maintenance history.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.

## Existing Project Notes

Prior README summary:

> Cat Coding — A Webview API Sample <!-- README-OVERVIEW-IMAGE --> Demonstrates VS Code's [webview API](https://code.visualstudio.com/api/extension-guides/webview). This includes: - Creating and showing a basic webview. - Dynamically updating a webview's content. - Loading local content in a webview. - Running scripts in a webview. - Sending message from an extension to a webview.
