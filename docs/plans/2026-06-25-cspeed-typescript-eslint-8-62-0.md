# TypeScript ESLint 8.62.0 Patch Refresh

status: completed

## Context

The registry shows typescript-eslint 8.62.0 was released on June 22, 2026. Its declared
peer and engine ranges support the repository's TypeScript 6.0.3, ESLint
10.5.0, Node 22, and Node 24 baseline. The newer Node and VS Code type majors
remain separate compatibility changes.

## Requirements

- Pin typescript-eslint 8.62.0 exactly in `package.json` and the lockfile root.
- Require the complete reviewed `@typescript-eslint` 8.62.0 package family,
  including exact registry URLs and integrity values.
- Preserve TypeScript 6.0.3, ESLint 10.5.0, Node 22 and Node 24, VS Code 1.120,
  package scripts, workflows, source behavior, and generated output.
- Keep the moderate dependency audit at zero findings.

## Test-Driven Implementation

The baseline gate was changed first to require typescript-eslint 8.62.0. The
unchanged package manifest then failed with the expected dependency-contract
error before npm refreshed the exact package and lockfile artifacts.

## Validation

- Run a lockfile-pinned install with lifecycle scripts disabled.
- Run `npm run verify` and repository-root plus external-directory `make check`
  under Node 22 and Node 24.
- Reject isolated hostile mutations covering the manifest pin, lockfile root,
  package-family version and integrity, maintained guidance, plan status, and
  verification evidence.
- Confirm generated output remains identical and the dependency audit reports
  zero vulnerabilities.

## Scope Boundaries

- Do not update TypeScript, ESLint, Node types, VS Code types, workflows,
  runtime dependencies, extension behavior, or generated artifacts.
- Do not adopt Node 25 or a newer VS Code API baseline in this patch.
- Do not claim live VS Code Extension Host execution from package-level tests.

## Verification Results

A lockfile-pinned install with lifecycle scripts disabled passed under Node
22.16.0 and Node 24.17.0. On both versions, `npm run verify` passed zero-warning
lint, all 30 tests, the source baseline, generated-output parity, and the
moderate dependency audit with zero vulnerabilities.

Repository-root and external-directory `make check` also passed under Node 22
and Node 24. All ten isolated hostile mutations were rejected for the intended
reason across the manifest pin, lockfile root, reviewed package-family
versions and integrity, family completeness, maintained guidance, plan status,
release evidence, and compatibility evidence.

Exact-head hosted Node 22 and Node 24 checks passed for implementation commit
`f1fbb0d0e7350c37e9211a094dd78cec7db8156a`. Push workflow run
`28218298624`, pull-request workflow run `28218305764`, and CodeQL run
`28218304813` all completed successfully.

## Sources

- npm registry metadata for `typescript-eslint@8.62.0`, inspected June 25,
  2026: `https://registry.npmjs.org/typescript-eslint/8.62.0`
