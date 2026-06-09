#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PACKAGE_JSON="$ROOT_DIR/package.json"
PACKAGE_LOCK="$ROOT_DIR/package-lock.json"
SOURCE="$ROOT_DIR/src/extension.ts"
OUTPUT="$ROOT_DIR/out/extension.js"
README="$ROOT_DIR/README.md"
PLAN="$ROOT_DIR/docs/plans/2026-06-08-cspeed-webview-baseline.md"
VERIFY_PLAN="$ROOT_DIR/docs/plans/2026-06-08-cspeed-verify-gate.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file is missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "package.json" \
  "package-lock.json" \
  "src/extension.ts" \
  "out/extension.js" \
  "scripts/check-baseline.sh" \
  "docs/plans/2026-06-08-cspeed-check-wrapper.md" \
  "docs/plans/2026-06-08-cspeed-webview-baseline.md" \
  "docs/plans/2026-06-08-cspeed-verify-gate.md" \
  "docs/plans/2026-06-09-cspeed-normalized-webview-alerts.md"; do
  require_file "$path"
done

if ! grep -Fq '"name": "cspeed"' "$PACKAGE_JSON"; then
  printf '%s\n' "package metadata must use the cspeed package name." >&2
  exit 1
fi

if ! grep -Fq '"test": "npm run compile && npm run check"' "$PACKAGE_JSON"; then
  printf '%s\n' "package.json must expose the compile and baseline test gate." >&2
  exit 1
fi

if ! grep -Fq '"lint": "eslint src --ext ts --max-warnings=0"' "$PACKAGE_JSON"; then
  printf '%s\n' "package.json must keep lint as a zero-warning TypeScript gate." >&2
  exit 1
fi

if ! grep -Fq '"verify": "npm run lint && npm test && npm audit --audit-level=high"' "$PACKAGE_JSON"; then
  printf '%s\n' "package.json must expose the combined verify gate." >&2
  exit 1
fi

if ! grep -Fq "check: verify" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose make check as the repository verification wrapper." >&2
  exit 1
fi

if ! grep -Fq '"eslint": "^9.13.0"' "$PACKAGE_JSON"; then
  printf '%s\n' "package.json must align with the checked-in ESLint lockfile baseline." >&2
  exit 1
fi

if ! grep -Fq '"typescript": "^5.7.2"' "$PACKAGE_JSON"; then
  printf '%s\n' "package.json must align with the checked-in TypeScript lockfile baseline." >&2
  exit 1
fi

if ! grep -Fq '"name": "cspeed"' "$PACKAGE_LOCK"; then
  printf '%s\n' "package-lock.json must align with package.json metadata." >&2
  exit 1
fi

if ! grep -Fq "Content-Security-Policy" "$SOURCE"; then
  printf '%s\n' "Webview HTML must include a content security policy." >&2
  exit 1
fi

if ! grep -Fq "script-src 'nonce-" "$SOURCE"; then
  printf '%s\n' "Webview scripts must be constrained by a nonce." >&2
  exit 1
fi

if ! grep -Fq "randomBytes(16).toString('base64')" "$SOURCE"; then
  printf '%s\n' "Webview CSP nonce must be generated with Node crypto." >&2
  exit 1
fi

if grep -Fq "Math.random()" "$SOURCE"; then
  printf '%s\n' "Webview CSP nonce must not use Math.random." >&2
  exit 1
fi

if grep -Fq "onclick=" "$SOURCE"; then
  printf '%s\n' "Webview HTML must not use inline event handlers." >&2
  exit 1
fi

if ! grep -Fq "localResourceRoots: [vscode.Uri.joinPath(this._extensionUri, 'media')]" "$SOURCE"; then
  printf '%s\n' "Webview local resource roots must be limited to media/." >&2
  exit 1
fi

if ! grep -Fq "function parseAlertMessage(message: unknown)" "$SOURCE"; then
	printf '%s\n' "Extension host must validate webview messages before handling them." >&2
	exit 1
fi

if ! grep -Fq "const text = candidate.text.trim()" "$SOURCE"; then
	printf '%s\n' "Webview alert messages must be trimmed before display." >&2
	exit 1
fi

if ! grep -Fq "text.length === 0 || text.length > 200" "$SOURCE"; then
	printf '%s\n' "Webview alert messages must have a bounded normalized text length." >&2
	exit 1
fi

if ! grep -Fq "/[\r\n]/.test(text)" "$SOURCE"; then
	printf '%s\n' "Webview alert messages must stay on one notification line." >&2
	exit 1
fi

if ! grep -Fq "return { command: 'alert', text }" "$SOURCE"; then
	printf '%s\n' "Webview alert messages must return normalized text for display." >&2
	exit 1
fi

if ! grep -Fq "text.length === 0" "$SOURCE"; then
	printf '%s\n' "Webview alert messages must not be empty after trimming." >&2
	exit 1
fi

if ! grep -Fq "Content-Security-Policy" "$OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with the CSP source." >&2
  exit 1
fi

if ! grep -Fq "function parseAlertMessage(message)" "$OUTPUT" ||
   ! grep -Fq "const text = candidate.text.trim()" "$OUTPUT" ||
   ! grep -Fq "/[\r\n]/.test(text)" "$OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with normalized alert parsing." >&2
  exit 1
fi

if ! grep -Fq 'require("crypto")' "$OUTPUT" || ! grep -Fq "crypto_1.randomBytes)(16).toString('base64')" "$OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with the crypto nonce source." >&2
  exit 1
fi

if ! grep -Fq "node_modules/" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' ".gitignore must exclude node_modules." >&2
  exit 1
fi

if ! grep -Fq "npm test" "$README"; then
  printf '%s\n' "README must document the npm test gate." >&2
  exit 1
fi

if ! grep -Fq "make check" "$README"; then
  printf '%s\n' "README must document the root make check gate." >&2
  exit 1
fi

if ! grep -Fq "npm run verify" "$README"; then
  printf '%s\n' "README must document the combined verify gate." >&2
  exit 1
fi

if ! grep -Fq "non-empty normalized alert text" "$README"; then
  printf '%s\n' "README must document non-empty webview alert validation." >&2
  exit 1
fi

if ! grep -Fq "crypto-generated CSP nonce" "$README"; then
  printf '%s\n' "README must document the crypto-generated CSP nonce baseline." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$VERIFY_PLAN"; then
  printf '%s\n' "Verify plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$ROOT_DIR/docs/plans/2026-06-08-cspeed-check-wrapper.md"; then
  printf '%s\n' "Check wrapper plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$ROOT_DIR/docs/plans/2026-06-09-cspeed-crypto-webview-nonce.md"; then
  printf '%s\n' "Crypto webview nonce plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/docs/plans/2026-06-09-cspeed-crypto-webview-nonce.md"; then
  printf '%s\n' "Crypto webview nonce plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$ROOT_DIR/docs/plans/2026-06-09-cspeed-normalized-webview-alerts.md"; then
  printf '%s\n' "Normalized webview alerts plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/docs/plans/2026-06-09-cspeed-normalized-webview-alerts.md"; then
  printf '%s\n' "Normalized webview alerts plan must record make check verification." >&2
  exit 1
fi

printf '%s\n' "CSpeed webview baseline checks passed."
