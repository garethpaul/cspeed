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
- Verification gate: `make check`

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
- `npm run lint` - `eslint src --ext ts --max-warnings=0`
- `npm run test` - `npm run compile && npm run check`
- `npm run verify` - `npm run lint && npm test && npm audit --audit-level=high`
- `npm run vscode:prepublish` - `npm run compile`
- `npm run watch` - `tsc -watch -p ./`

## Testing and Verification

Run the local gate before changing extension or webview behavior:

```bash
make check
make build
npm run verify
npm run lint
npm test
npm audit --audit-level=high
```

`make check` runs the root lint, test, build, and audit gates. `make build`
runs `npm run compile` so the checked-in `out/` extension output stays
reproducible from the TypeScript source.
`npm test` compiles TypeScript and runs `scripts/check-baseline.sh`. The source
baseline checks that the webview has a content security policy, nonce-scoped
script execution, bounded message handling with non-empty normalized alert text,
single-line alert notifications, and synchronized compiled output. The script
nonce is generated with Node crypto instead of `Math.random`, and the webview
script is loaded from `media/main.js` through a scoped VS Code webview URI.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.

## Security and Privacy Notes

- Review changes touching network requests, sockets, or service endpoints; examples from the scan include .vscode/extensions.json, .vscode/launch.json, .vscode/tasks.json.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include .vscode/tasks.json, media/main.js.

## Maintenance Notes

- The webview uses a crypto-generated CSP nonce and keeps checked-in compiled
  output synchronized with the TypeScript source.
- The sidebar webview script is loaded from `media/main.js` under the same
  nonce-scoped content security policy.
- Webview alert text is trimmed, bounded, and kept on one notification line
  before the extension host displays it.
- Root `make build` runs the TypeScript compiler directly before audit-backed
  verification.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.
- See `CHANGES.md` for maintenance history.
- See `docs/plans/2026-06-09-cspeed-make-build-gate.md` for the root build gate
  baseline.
- See `docs/plans/2026-06-09-cspeed-media-script-baseline.md` for the external
  webview script baseline.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
