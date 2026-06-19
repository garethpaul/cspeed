---
title: Cspeed Alert Accessor Guards
type: fix
date: 2026-06-13
status: completed
---

# Cspeed Alert Accessor Guards

## Summary

Make webview alert parsing reject accessor-backed and trap-throwing objects
without invoking untrusted property behavior or propagating parser exceptions.

## Problem Frame

`parseAlertMessage` validates object shape but calls `Object.getPrototypeOf`
and then reads `candidate.command` and `candidate.text` directly. A proxy can
throw from the prototype trap, and a plain object can expose own getters that
throw or execute side effects. Those values should fail closed at the webview
message boundary rather than crashing notification dispatch or invoking
accessors during validation.

## Requirements

- R1. Prototype inspection failures must return `undefined` without escaping an
  exception from `parseAlertMessage` or `dispatchAlertMessage`.
- R2. `command` and `text` must be own data properties; accessor descriptors
  must be rejected without invoking getters.
- R3. Existing plain and null-prototype records with valid data properties must
  continue to normalize and dispatch exactly one notification.
- R4. Existing type, length, whitespace, display-control, and prototype rules
  must remain unchanged.
- R5. Parser and dispatch tests plus the static baseline must enforce throwing
  proxies, side-effecting accessors, accepted records, generated output, docs,
  and completed-plan evidence through `make check`.

## Key Technical Decisions

- **Use own property descriptors:** Read `value` from
  `Object.getOwnPropertyDescriptor` only after confirming each descriptor is a
  data property, avoiding accessor execution entirely.
- **Catch reflective failures:** Wrap prototype and descriptor inspection in a
  narrow `try/catch` and reject when proxies throw.
- **Keep parsing pure:** Return `undefined` for every rejected shape and leave
  notification dispatch unchanged.
- **Test both layers:** Parser tests prove no accessor invocation; dispatch tests
  prove malformed objects cannot escape or produce notifications.

## Implementation Units

### U1. Parse Data Properties Without Accessors

- **Files:** `src/alertMessage.ts`
- **Goal:** Safely inspect prototypes/descriptors and validate descriptor values
  without direct property reads.
- **Covers:** R1, R2, R3, R4

### U2. Add Hostile Object Regression Coverage

- **Files:** `test/alertMessage.test.js`, `test/alertMessageHandler.test.js`
- **Goal:** Exercise throwing prototype traps, throwing/side-effecting getters,
  and accepted data-property records at parser and dispatch boundaries.
- **Covers:** R1, R2, R3, R5

### U3. Preserve Generated And Documentation Contracts

- **Files:** `scripts/check-baseline.sh`, generated `out` files, `README.md`,
  `CHANGES.md`, `VISION.md`, `SECURITY.md`, `AGENTS.md`
- **Goal:** Keep source, tests, compiled output, completed plan, and boundary
  guidance synchronized with the existing build verification gate.
- **Covers:** R5

## Verification

- Run focused parser/dispatch tests, `npm run verify`, `make check`, and the
  absolute-path `make check` wrapper from `/tmp` under Node 22 and Node 24.
- Confirm generated output matches TypeScript source and `npm audit` reports no
  known vulnerabilities.
- Run shell syntax, whitespace, secret, and artifact checks.
- Apply isolated hostile mutations for removed reflection catches, direct
  property reads, accessor acceptance, omitted parser/dispatch fixtures,
  generated-output drift, documentation drift, and incomplete plan status;
  each mutation must fail.
- Do not claim VS Code extension-host validation unless an extension host is
  launched; the pure parser/dispatch boundary is the local executable scope.

## Verification Results

- Node 22.22.2 and Node 24.16.0 `npm run verify` passed zero-warning lint,
  eleven parser/dispatch tests, generated-output synchronization, and an audit
  with zero known vulnerabilities.
- Repository and absolute-path `make check` passed with the same source,
  generated-output, test, and audit gates.
- Plan-aware review found and fixed one revoked-proxy gap by moving
  `Array.isArray` inside the guarded reflection block and covering it at both
  parser and dispatch boundaries; no residual findings remain.
- Shell syntax, whitespace, unchanged lockfile, secret, and generated-artifact
  checks passed.
- Eight isolated hostile mutations covering reflection failure propagation,
  direct property reads, accessor acceptance, parser and dispatch fixture
  removal, generated-output drift, documentation drift, and completed-plan
  status were rejected.
- `agent-browser` is not installed and a VS Code extension host was not
  launched, so no rendered webview or extension-host claim is made. Webview
  schema, CSP, provider registration, and notification limits are unchanged.

## Prioritized Follow-Ups

1. Add explicit cancellation/disposal coverage for webview message listeners.
2. Keep future webview commands on a closed discriminated-union schema.

## Risks

- Descriptor inspection is slightly more verbose than direct reads but removes
  observable accessor execution and makes the trust boundary explicit.
- Real VS Code webview messages are normally structured-cloned plain objects;
  these guards also keep direct API/test callers fail-closed without changing
  valid production messages.
