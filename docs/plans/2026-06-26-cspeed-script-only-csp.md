# CSpeed Script-Only CSP

Status: Completed

## Problem

The sidebar HTML loads one checked-in script, but its content security policy
also allowed extension-local images and stylesheets that the rendered document
does not use. Those directives widened the webview resource surface without a
current feature requirement.

## Requirements

- Preserve `default-src 'none'`, `base-uri 'none'`, and `form-action 'none'`.
- Preserve the crypto-nonce-authorized `media/main.js` load.
- Remove unused `img-src` and `style-src` capabilities.
- Keep `localResourceRoots` scoped to the checked-in `media` directory.
- Add executable and source-baseline regressions for the script-only policy.
- Keep checked-in TypeScript output synchronized.

## Verification

- The provider regression failed first because the rendered CSP contained both
  unused resource directives.
- `node --test test/sidebarProvider.test.js`
- `make check`
- `make -f /absolute/path/to/Makefile check` from an external directory
- `git diff --check`
