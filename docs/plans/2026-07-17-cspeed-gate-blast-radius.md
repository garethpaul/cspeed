# CSpeed gate must run outside its own blast radius

Status: Completed

## Problem

`scripts/check-baseline.sh` is the repository's entire verification contract, and
every assertion in it is a text pin over checked-in files. It reached CI through
exactly one path:

```
node scripts/run-make.js . check   ->  __cspeed_check -> __cspeed_verify
                                       -> __cspeed_test -> npm test
                                       -> npm run compile && node --test && npm run check
                                                                            ^^^^^^^^^^^^^^
```

`__cspeed_test` was the only prerequisite that led to `node --test` *and* to
`check-baseline.sh`. Neither `__cspeed_lint`, `__cspeed_build`, nor
`__cspeed_audit` runs the baseline. So the gate was downstream of a single link
it was itself responsible for pinning, and any edit that removed that link also
removed the detector that would have complained. Two one-to-two line, verdict
inverting edits were confirmed against the previous gate:

| Mutation | Makefile pins byte-identical | Result |
| --- | --- | --- |
| append `__cspeed_test:` + `@:` | yes | exit 0, 30 tests and the baseline never ran |
| drop `&& npm run check` from `package.json` `test` | Makefile untouched | exit 0, baseline never ran |

Both left a planted security regression (a predictable `Math.random()` CSP nonce,
which the unmutated gate rejects with `Webview CSP nonce must be generated with
Node crypto.`) passing at exit 0. GNU Make honours the *last* recipe for a
single-colon target, printing `warning: overriding recipe` on stderr and exiting
0, which CI does not fail on.

Counting rule definitions is not a sufficient defence: a multi-target rule
`__cspeed_test decoy:` overrides the recipe while `grep -cE '^__cspeed_test[ \t]*:'`
still returns 1.

`test/makePathBoundary.test.js` already asserts the exact npm argv dispatch log
and does detect the override -- but it runs under `node --test`, inside
`npm test`, inside `__cspeed_test`, so it was inside the blast radius of the very
mutation it detects.

## Change

1. Every gate rule is now a double-colon (`::`) rule. Make accumulates `::`
   recipes, so an appended override no longer replaces the real recipe, and
   mixing `:` with `::` for one target is a hard parse error. This is enforced by
   Make itself at parse time and needs no cooperation from any checked-in script.
2. `__cspeed_baseline` runs `npm run check` as a direct prerequisite of
   `__cspeed_verify`, so the baseline no longer depends on the `npm test` chain
   surviving. `run-npm-gate.js` allows the corresponding fixed argv.
3. `run-make.js` validates the gate rule shape before Make parses anything. The
   launcher is the CI entry point and runs above Make, so it is outside every
   recipe's blast radius; it rejects a checkout whose gate rules are not each
   defined exactly once in `::` form.
4. `check-baseline.sh` pins the `::` shape and the new launcher contract, and
   `test/makePathBoundary.test.js` expects the added dispatch entry.

## Verification

`make check` (green: 30 tests pass, baseline runs). Hostile mutations, each
committed to a clean tree and run through `node scripts/run-make.js . check`:

| Mutation | Before | After |
| --- | --- | --- |
| append `__cspeed_test:` + `@:` | exit 0 | exit 2, launcher rejects single-colon gate rule |
| append `__cspeed_test::` + `@:` | n/a | exit 2, rule defined twice |
| append `__cspeed_test decoy:` + `@:` | exit 0 | exit 2, Make: has both `:` and `::` entries |
| append `__cspeed_baseline:` + `@:` | n/a | exit 2, launcher rejects single-colon gate rule |
| drop `&& npm run check` from `test` + defect | exit 0 | exit 2, baseline pin fires |
| rewrite all `::` to `:` + override both + defect | exit 0 | exit 2, launcher rejects shape |
| predictable nonce defect alone | exit 2 | exit 2 (unchanged) |

No browser, VS Code desktop, Extension Host, rendered webview, notification,
view disposal, multi-window, or workspace trust scenario was executed; this
change only affects the verification gate.
