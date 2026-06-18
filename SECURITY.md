# Security Policy

## Supported Versions

The supported security scope for `cspeed` is the current default branch, `main`. Older commits, tags, branches, forks, demos, and generated artifacts are not actively supported unless the repository explicitly marks them as maintained.

Project summary: Basic wrapper for VSCode

## Reporting a Vulnerability

Please report suspected vulnerabilities through GitHub's private vulnerability reporting or by opening a draft GitHub Security Advisory for `garethpaul/cspeed` when that option is available. If GitHub does not show a private reporting option for this repository, contact the repository owner through GitHub and avoid posting exploit details publicly until the issue can be assessed.

Do not open a public issue that includes exploit code, secrets, personal data, or detailed reproduction steps for an unpatched vulnerability.

## What to Include

Helpful reports include:

- the affected file, endpoint, permission, dependency, or workflow
- a concise impact statement explaining what an attacker could do
- reproduction steps using test data and accounts you control
- the branch, commit SHA, platform version, device, runtime, or dependency versions used
- logs, screenshots, or proof-of-concept snippets that demonstrate impact without exposing private data

## Project Security Posture

- This repository appears to be a Node.js or JavaScript project. The active security scope is the code and documentation on the default branch.
- Review found authentication, token, or session-related code paths; changes in those areas should receive security-focused review before merge.
- Review found network clients, sockets, web APIs, or service endpoints; changes in those areas should receive security-focused review before merge.
- Review found mobile permission or privacy-sensitive data handling; changes in those areas should receive security-focused review before merge.
- Review found file, document, data, or media parsing flows; changes in those areas should receive security-focused review before merge.
- Dependency manifests detected: package.json, package-lock.json. Dependency updates should preserve lockfiles when present and avoid introducing packages without a clear maintenance reason.
- GitHub Actions runs `npm ci` and the npm-backed `make check` baseline on Node
  22 and 24 with commit-pinned actions, read-only repository access, a
  credential-free checkout, and a moderate-severity audit gate; review
  workflow, package, and lockfile changes as part of the supply-chain surface.
- Local `.vscode/` workspace metadata should stay untracked so editor launch
  settings and recommendations remain machine-local.
- Webview alert parsing rejects accessor-backed or reflective trap objects
  without invoking getters or propagating exceptions into extension dispatch.
- Webview alert parsing rejects Unicode bidirectional ordering controls before
  notification dispatch while preserving ordinary right-to-left script text.
- Webview alert parsing rejects invisible Unicode format controls before notification
  dispatch so rendered and copied alert text remain unambiguous.
- Webview alert parsing rejects Unicode invisible operators before notification
  dispatch so arithmetic-looking alert text cannot hide semantic separators.
- Webview alert parsing rejects lone UTF-16 surrogates while preserving valid
  surrogate-pair characters such as emoji.
- Provider lifecycle tests keep webview resources scoped to checked-in media,
  retain the nonce CSP, and dispose message listeners when their owning view
  closes.

## Service and API Notes

For web services, APIs, sockets, or scraping workflows, prioritize reports involving authentication bypass, authorization errors, injection, server-side request forgery, unsafe deserialization, credential leakage, data exposure, or denial-of-service conditions. Use test accounts and minimal proof-of-concept traffic only.

Webview alert messages should require owned `command` and `text` fields before
the extension host displays notifications.
Executable parser tests should continue covering inherited fields, custom
prototypes, wrong types, multiline text, and size limits.

## Dependency and Supply Chain Security

Dependency updates should come from trusted package managers and should keep lockfiles in sync when lockfiles exist. Do not commit credentials, private keys, tokens, generated secrets, or machine-local configuration. If a vulnerability depends on a compromised package, typosquatting risk, insecure transitive dependency, or unsafe build step, include the package name, affected version, and the path through which it is used.

The reviewed development-toolchain baseline is TypeScript 6.0.3 and ESLint 10.5.0,
with typescript-eslint 8.61.1 and @types/node 22.19.21. The compiler
uses explicit Node and VS Code type roots; Node 25 still requires dedicated
compatibility review rather than an unreviewed lockfile update.

## Safe Research Guidelines

Good-faith research is welcome when it stays within these boundaries:

- use only accounts, devices, data, and infrastructure that you own or have explicit permission to test
- avoid destructive actions, persistence, spam, phishing, social engineering, or denial-of-service testing
- minimize access to personal data and stop testing immediately if private data is exposed
- do not exfiltrate secrets or third-party data; report the minimum evidence needed to verify impact
- keep vulnerability details confidential until the maintainer has assessed the report

## Maintainer Response

The maintainer will review complete reports as availability allows, prioritize issues by exploitability and impact, and coordinate a fix or mitigation when the affected code is still maintained. For sample, archived, or educational repositories, the likely remediation may be documentation, dependency updates, or clearly marking unsupported code rather than a production-style patch release.
