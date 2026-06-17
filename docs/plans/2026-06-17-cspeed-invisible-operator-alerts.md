---
title: CSpeed Invisible Operator Alert Guard
type: security
date: 2026-06-17
status: in_progress
execution: code
---

# CSpeed Invisible Operator Alert Guard

## Context

The webview alert parser rejects control characters, bidirectional controls,
common invisible format controls, and lone UTF-16 surrogates. Unicode invisible
operators `U+2061` through `U+2064` remain accepted, however, even though these
format characters render without a visible glyph and can make extension
notifications visually ambiguous.

## Priority

1. Reject all four Unicode invisible operators before alert dispatch.
2. Preserve ordinary Unicode, valid surrogate pairs, trimming, and the existing
   200-code-unit limit.
3. Keep source, checked-in compiled output, tests, guidance, and repository
   contracts synchronized.

## Requirements

- Reject `U+2061` FUNCTION APPLICATION, `U+2062` INVISIBLE TIMES, `U+2063`
  INVISIBLE SEPARATOR, and `U+2064` INVISIBLE PLUS in alert text.
- Add parser tests covering every code point and dispatch tests proving no
  notification is emitted.
- Add a static contract that fails if the contiguous range or test fixtures are
  removed or narrowed.
- Recompile the checked-in `out/` files through the existing build command.
- Update maintained security, vision, changelog, contributor, and README text.
- Run the complete Node 22 and Node 24 repository and external-directory gates,
  dependency audit, focused tests, and isolated hostile mutations.
- Require exact-head push and pull-request checks before recording completion.

## Scope Boundaries

- Do not introduce Unicode normalization, confusable-character detection, or a
  general text policy beyond these four invisible operators.
- Do not change the accepted command schema, notification API, alert length,
  whitespace trimming, ordinary Unicode support, or extension lifecycle.
- Do not change package versions, workflows, permissions, or media assets.
- Do not merge or close the stacked pull request without explicit authorization.

## Verification Results

Implementation and verification are pending.
