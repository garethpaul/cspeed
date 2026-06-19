# AGENTS.md

## Repository purpose

`garethpaul/cspeed` is a minimal VS Code sidebar webview extension sample.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `src` - primary source code
- `package.json` - Node package metadata and scripts

## Development commands

- Install dependencies: `npm ci`
- Keep TypeScript 6.0.3, ESLint 10.5.0, typescript-eslint 8.61.1, and
  @types/node 22.19.21 exact unless a focused dependency plan updates the
  lockfile and verification gate.
- Keep the explicit Node and VS Code type roots required by TypeScript 6;
  treat Node 25 as a separate compatibility migration.
- Full baseline: `make check`
- Combined verification: `make verify`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- package script `compile`: `npm run compile`
- package script `lint`: `npm run lint`
- package script `test`: `npm test`
- package script `verify`: `npm run verify`
- package script `check`: `npm run check`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: JavaScript (2), TypeScript (1).

## Testing guidance

- Node tests cover alert parsing and dispatch plus extension registration and
  sidebar provider lifecycle behavior; treat `make check` as the minimum
  baseline.
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- Webview alert messages must use own data properties; parser validation must not invoke accessors and must reject reflection traps without throwing.

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.
- The webview uses a crypto-generated CSP nonce and keeps checked-in compiled output synchronized with the TypeScript source.
- The webview CSP keeps base URI and form submissions disabled in addition to denying default resource loads.
- The sidebar webview script is loaded from `media/main.js` under the same nonce-scoped content security policy.
- Webview alert text is trimmed, bounded, and kept on one notification line before the extension host displays it.
- Webview alert parsing rejects bidirectional ordering controls before notification dispatch while preserving ordinary right-to-left text.
- Webview alert parsing rejects invisible Unicode format controls before notification dispatch, including high-plane tag format characters.
- Webview alert parsing rejects Unicode invisible operators before notification dispatch.
- Webview alert parsing rejects lone UTF-16 surrogates while preserving valid surrogate pairs.
- Alert messages must provide own `command` and `text` properties before the extension host reads or displays them.
- Each provider message subscription must be disposed with its owning webview;
  keep registration and lifecycle tests synchronized with provider changes.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
