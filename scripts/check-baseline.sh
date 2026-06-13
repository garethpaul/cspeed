#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PACKAGE_JSON="$ROOT_DIR/package.json"
PACKAGE_LOCK="$ROOT_DIR/package-lock.json"
SOURCE="$ROOT_DIR/src/extension.ts"
OUTPUT="$ROOT_DIR/out/extension.js"
ALERT_SOURCE="$ROOT_DIR/src/alertMessage.ts"
ALERT_OUTPUT="$ROOT_DIR/out/alertMessage.js"
ALERT_TEST="$ROOT_DIR/test/alertMessage.test.js"
ALERT_HANDLER_SOURCE="$ROOT_DIR/src/alertMessageHandler.ts"
ALERT_HANDLER_OUTPUT="$ROOT_DIR/out/alertMessageHandler.js"
ALERT_HANDLER_TEST="$ROOT_DIR/test/alertMessageHandler.test.js"
MEDIA_SCRIPT="$ROOT_DIR/media/main.js"
README="$ROOT_DIR/README.md"
PLAN="$ROOT_DIR/docs/plans/2026-06-08-cspeed-webview-baseline.md"
VERIFY_PLAN="$ROOT_DIR/docs/plans/2026-06-08-cspeed-verify-gate.md"
MEDIA_SCRIPT_PLAN="$ROOT_DIR/docs/plans/2026-06-09-cspeed-media-script-baseline.md"
MESSAGE_OWN_PROPERTY_PLAN="$ROOT_DIR/docs/plans/2026-06-09-cspeed-alert-own-properties.md"
EDITOR_METADATA_PLAN="$ROOT_DIR/docs/plans/2026-06-09-cspeed-editor-metadata-ignore.md"
ALERT_PLAIN_OBJECT_PLAN="$ROOT_DIR/docs/plans/2026-06-09-cspeed-alert-plain-object-validation.md"
CSP_NAVIGATION_PLAN="$ROOT_DIR/docs/plans/2026-06-09-cspeed-webview-csp-navigation.md"
ALERT_PROTOTYPE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-cspeed-alert-object-prototype.md"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-ci-baseline.md"
PARSER_TEST_PLAN="$ROOT_DIR/docs/plans/2026-06-10-cspeed-alert-parser-tests.md"
DISPATCH_TEST_PLAN="$ROOT_DIR/docs/plans/2026-06-12-cspeed-alert-dispatch-tests.md"
CHECKOUT_CREDENTIAL_PLAN="$ROOT_DIR/docs/plans/2026-06-12-checkout-credential-boundary.md"
CONTROL_CHARACTER_PLAN="$ROOT_DIR/docs/plans/2026-06-13-cspeed-alert-control-characters.md"
ACCESSOR_GUARD_PLAN="$ROOT_DIR/docs/plans/2026-06-13-cspeed-alert-accessor-guards.md"
BIDI_CONTROL_PLAN="$ROOT_DIR/docs/plans/2026-06-13-cspeed-alert-bidi-controls.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
MAKEFILE="$ROOT_DIR/Makefile"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file is missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".nvmrc" \
  ".gitignore" \
  ".github/workflows/check.yml" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "package.json" \
  "package-lock.json" \
  "media/main.js" \
  "src/alertMessage.ts" \
  "src/alertMessageHandler.ts" \
  "src/extension.ts" \
  "test/alertMessage.test.js" \
  "test/alertMessageHandler.test.js" \
  "out/alertMessage.js" \
  "out/alertMessageHandler.js" \
  "out/extension.js" \
  "scripts/check-baseline.sh" \
  "docs/plans/2026-06-08-cspeed-check-wrapper.md" \
  "docs/plans/2026-06-08-cspeed-webview-baseline.md" \
  "docs/plans/2026-06-08-cspeed-verify-gate.md" \
  "docs/plans/2026-06-09-cspeed-make-build-gate.md" \
  "docs/plans/2026-06-09-cspeed-media-script-baseline.md" \
  "docs/plans/2026-06-09-cspeed-alert-plain-object-validation.md" \
  "docs/plans/2026-06-09-cspeed-alert-object-prototype.md" \
  "docs/plans/2026-06-09-cspeed-alert-own-properties.md" \
  "docs/plans/2026-06-09-cspeed-editor-metadata-ignore.md" \
  "docs/plans/2026-06-09-cspeed-webview-csp-navigation.md" \
  "docs/plans/2026-06-10-ci-baseline.md" \
  "docs/plans/2026-06-10-cspeed-alert-parser-tests.md" \
  "docs/plans/2026-06-12-cspeed-alert-dispatch-tests.md" \
  "docs/plans/2026-06-12-checkout-credential-boundary.md" \
  "docs/plans/2026-06-13-cspeed-alert-control-characters.md" \
  "docs/plans/2026-06-13-cspeed-alert-accessor-guards.md" \
  "docs/plans/2026-06-13-cspeed-alert-bidi-controls.md" \
  "docs/plans/2026-06-09-cspeed-normalized-webview-alerts.md"; do
  require_file "$path"
done

workflow_count=$(find "$ROOT_DIR/.github/workflows" -type f \( -name '*.yml' -o -name '*.yaml' \) | wc -l | tr -d ' ')
checkout_count=$(grep -Ec '^[[:space:]]*uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10' "$CI_WORKFLOW" || true)
credential_boundary_count=$(grep -Ec '^[[:space:]]*persist-credentials:[[:space:]]*false([[:space:]]|$)' "$CI_WORKFLOW" || true)

if [ "$workflow_count" -ne 1 ] || [ "$checkout_count" -ne 1 ] || [ "$credential_boundary_count" -ne 1 ]; then
  printf '%s\n' "GitHub Actions must keep one workflow with one pinned, credential-free checkout." >&2
  exit 1
fi

if ! grep -Fq "runs-on: ubuntu-24.04" "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must use the stable Ubuntu 24.04 runner." >&2
  exit 1
fi

for fragment in \
  "actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10" \
  "actions/setup-node@48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e" \
  "node-version: [22, 24]" \
  "permissions:" \
  "contents: read" \
  "timeout-minutes: 10" \
  "npm ci" \
  "make check"; do
  if ! grep -Fq "$fragment" "$CI_WORKFLOW"; then
    printf '%s\n' "GitHub Actions workflow must include $fragment." >&2
    exit 1
  fi
done

if ! grep -Fxq "22" "$ROOT_DIR/.nvmrc"; then
  printf '%s\n' ".nvmrc must pin the Node 22 development baseline." >&2
  exit 1
fi

if ! grep -Fq '"name": "cspeed"' "$PACKAGE_JSON"; then
  printf '%s\n' "package metadata must use the cspeed package name." >&2
  exit 1
fi

if ! grep -Fq '"test": "npm run compile && node --test && npm run check"' "$PACKAGE_JSON"; then
	printf '%s\n' "package.json must expose compiled Node tests and the baseline gate." >&2
  exit 1
fi

if ! grep -Fq '"lint": "eslint src --ext ts --max-warnings=0"' "$PACKAGE_JSON"; then
  printf '%s\n' "package.json must keep lint as a zero-warning TypeScript gate." >&2
  exit 1
fi

if ! grep -Fq '"check:generated": "npm run compile && git diff --exit-code -- out"' "$PACKAGE_JSON"; then
  printf '%s\n' "package.json must fail when checked-in compiled output drifts from TypeScript source." >&2
  exit 1
fi

if ! grep -Fq '"verify": "npm run lint && npm test && npm run check:generated && npm audit --audit-level=moderate"' "$PACKAGE_JSON"; then
  printf '%s\n' "package.json must expose the combined verify gate." >&2
  exit 1
fi

if ! grep -Fq "check: verify" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose make check as the repository verification wrapper." >&2
  exit 1
fi

if ! grep -Fq "build:" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose a build gate." >&2
  exit 1
fi

if ! grep -Fq 'run check:generated' "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile build must verify checked-in compiled output after TypeScript compilation." >&2
  exit 1
fi

if ! grep -Fq "verify: lint test build audit" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile verify must run lint, test, build, and audit gates." >&2
  exit 1
fi

if ! grep -Fq 'ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))' "$MAKEFILE" ||
  [ "$(grep -c '\$(NPM) --prefix \$(ROOT)' "$MAKEFILE")" -ne 4 ]; then
  printf '%s\n' "Make targets must run npm from the repository root." >&2
  exit 1
fi

for package_contract in \
  '"node": ">=22.13.0 <25"' \
  '"vscode": "^1.120.0"' \
  '"@eslint/js": "10.0.1"' \
  '"@stylistic/eslint-plugin": "5.10.0"' \
  '"@types/node": "22.19.20"' \
  '"@types/vscode": "1.120.0"' \
  '"@types/vscode-webview": "1.57.5"' \
  '"eslint": "10.4.1"' \
  '"typescript": "5.9.3"' \
  '"typescript-eslint": "8.61.0"'; do
  if ! grep -Fq "$package_contract" "$PACKAGE_JSON"; then
    printf '%s\n' "package.json must keep dependency contract: $package_contract" >&2
    exit 1
  fi
done

if ! grep -Fq '"name": "cspeed"' "$PACKAGE_LOCK"; then
  printf '%s\n' "package-lock.json must align with package.json metadata." >&2
  exit 1
fi

for lock_contract in \
  '"@eslint/js": "10.0.1"' \
  '"@stylistic/eslint-plugin": "5.10.0"' \
  '"eslint": "10.4.1"' \
  '"typescript": "5.9.3"' \
  '"typescript-eslint": "8.61.0"'; do
  if ! grep -Fq "$lock_contract" "$PACKAGE_LOCK"; then
    printf '%s\n' "package-lock.json must keep dependency contract: $lock_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "Content-Security-Policy" "$SOURCE"; then
  printf '%s\n' "Webview HTML must include a content security policy." >&2
  exit 1
fi

if ! grep -Fq "script-src 'nonce-" "$SOURCE"; then
  printf '%s\n' "Webview scripts must be constrained by a nonce." >&2
  exit 1
fi

if ! grep -Fq "base-uri 'none'" "$SOURCE" ||
   ! grep -Fq "form-action 'none'" "$SOURCE"; then
  printf '%s\n' "Webview CSP must disable base URI and form submissions explicitly." >&2
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

if ! grep -Fq "webview.asWebviewUri(vscode.Uri.joinPath(this._extensionUri, 'media', 'main.js'))" "$SOURCE"; then
  printf '%s\n' "Webview HTML must load its script through a scoped media URI." >&2
  exit 1
fi

if ! grep -Fq '<script nonce="${nonce}" src="${scriptUri}"></script>' "$SOURCE"; then
  printf '%s\n' "Webview script tags must keep the nonce on the external media script." >&2
  exit 1
fi

if ! grep -Fq "localResourceRoots: [vscode.Uri.joinPath(this._extensionUri, 'media')]" "$SOURCE"; then
  printf '%s\n' "Webview local resource roots must be limited to media/." >&2
  exit 1
fi

if grep -Fq "lines-of-code-counter" "$MEDIA_SCRIPT" || grep -Fq "setInterval(" "$MEDIA_SCRIPT" ||
  grep -Fq "Math.random()" "$MEDIA_SCRIPT"; then
  printf '%s\n' "Webview media script must not keep stale Cat Coding timer behavior." >&2
  exit 1
fi

if ! grep -Fq "document.getElementById('send-message')" "$MEDIA_SCRIPT" ||
  ! grep -Fq "vscode.postMessage({" "$MEDIA_SCRIPT" ||
  ! grep -Fq "text: 'Hello from the webview!'" "$MEDIA_SCRIPT"; then
  printf '%s\n' "Webview media script must own the sidebar button message handler." >&2
  exit 1
fi

if ! grep -Fq "function parseAlertMessage(message: unknown)" "$ALERT_SOURCE"; then
	printf '%s\n' "Extension host must validate webview messages before handling them." >&2
	exit 1
fi

if ! grep -Fq "Array.isArray(message)" "$ALERT_SOURCE"; then
	printf '%s\n' "Webview alert messages must reject array payloads before field validation." >&2
	exit 1
fi

if ! grep -Fq "Object.getPrototypeOf(message)" "$ALERT_SOURCE" ||
   ! grep -Fq "prototype !== Object.prototype && prototype !== null" "$ALERT_SOURCE"; then
	printf '%s\n' "Webview alert messages must reject non-record object prototypes." >&2
	exit 1
fi

if ! grep -Fq "Object.getOwnPropertyDescriptor(message, 'command')" "$ALERT_SOURCE" ||
   ! grep -Fq "Object.getOwnPropertyDescriptor(message, 'text')" "$ALERT_SOURCE" ||
   ! grep -Fq "hasOwnProperty.call(commandDescriptor, 'value')" "$ALERT_SOURCE" ||
   ! grep -Fq "hasOwnProperty.call(textDescriptor, 'value')" "$ALERT_SOURCE"; then
	printf '%s\n' "Webview alert messages must require own command and text data properties." >&2
	exit 1
fi

if ! grep -Fq "const text = candidateText.trim()" "$ALERT_SOURCE"; then
	printf '%s\n' "Webview alert messages must be trimmed before display." >&2
	exit 1
fi

if ! grep -Fq "text.length === 0 || text.length > 200" "$ALERT_SOURCE"; then
	printf '%s\n' "Webview alert messages must have a bounded normalized text length." >&2
	exit 1
fi

if ! grep -Fq 'function containsDisplayControlCharacter(text: string): boolean' "$ALERT_SOURCE" ||
  ! grep -Fq 'codePoint <= 0x1f' "$ALERT_SOURCE" ||
  ! grep -Fq 'codePoint >= 0x7f && codePoint <= 0x9f' "$ALERT_SOURCE" ||
  ! grep -Fq 'codePoint === 0x2028' "$ALERT_SOURCE" ||
  ! grep -Fq 'codePoint === 0x2029' "$ALERT_SOURCE" ||
  ! grep -Fq 'containsDisplayControlCharacter(candidateText)' "$ALERT_SOURCE"; then
	printf '%s\n' "Webview alert messages must reject display controls and Unicode line separators before normalization." >&2
	exit 1
fi

for bidi_contract in \
  'codePoint === 0x061c' \
  'codePoint >= 0x200e && codePoint <= 0x200f' \
  'codePoint >= 0x202a && codePoint <= 0x202e' \
  'codePoint >= 0x2066 && codePoint <= 0x2069'; do
  if ! grep -Fq "$bidi_contract" "$ALERT_SOURCE" ||
    ! grep -Fq "$bidi_contract" "$ALERT_OUTPUT"; then
    printf '%s\n' "Alert parser source and output must reject bidi controls: $bidi_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "return { command: 'alert', text }" "$ALERT_SOURCE"; then
	printf '%s\n' "Webview alert messages must return normalized text for display." >&2
	exit 1
fi

if ! grep -Fq "text.length === 0" "$ALERT_SOURCE"; then
	printf '%s\n' "Webview alert messages must not be empty after trimming." >&2
	exit 1
fi

if ! grep -Fq "Content-Security-Policy" "$OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with the CSP source." >&2
  exit 1
fi

if ! grep -Fq "base-uri 'none'" "$OUTPUT" ||
   ! grep -Fq "form-action 'none'" "$OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with CSP navigation restrictions." >&2
  exit 1
fi

if ! grep -Fq "webview.asWebviewUri(vscode.Uri.joinPath(this._extensionUri, 'media', 'main.js'))" "$OUTPUT" ||
   ! grep -Fq '<script nonce="${nonce}" src="${scriptUri}"></script>' "$OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with the external media script source." >&2
  exit 1
fi

if ! grep -Fq "function parseAlertMessage(message)" "$ALERT_OUTPUT" ||
   ! grep -Fq "Array.isArray(message)" "$ALERT_OUTPUT" ||
   ! grep -Fq "Object.getPrototypeOf(message)" "$ALERT_OUTPUT" ||
   ! grep -Fq "prototype !== Object.prototype && prototype !== null" "$ALERT_OUTPUT" ||
   ! grep -Fq "Object.getOwnPropertyDescriptor(message, 'command')" "$ALERT_OUTPUT" ||
   ! grep -Fq "Object.getOwnPropertyDescriptor(message, 'text')" "$ALERT_OUTPUT" ||
   ! grep -Fq "hasOwnProperty.call(commandDescriptor, 'value')" "$ALERT_OUTPUT" ||
   ! grep -Fq "const text = candidateText.trim()" "$ALERT_OUTPUT" ||
   ! grep -Fq 'containsDisplayControlCharacter(candidateText)' "$ALERT_OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with normalized alert parsing." >&2
  exit 1
fi

if ! grep -Fq "import { dispatchAlertMessage } from './alertMessageHandler'" "$SOURCE" ||
  ! grep -Fq "dispatchAlertMessage(message, text => vscode.window.showInformationMessage(text))" "$SOURCE" ||
  ! grep -Fq 'require("./alertMessageHandler")' "$OUTPUT"; then
  printf '%s\n' "Extension source and output must use the tested alert dispatch module." >&2
  exit 1
fi

if ! grep -Fq "import { parseAlertMessage } from './alertMessage'" "$ALERT_HANDLER_SOURCE" ||
  ! grep -Fq "function dispatchAlertMessage(message, showAlert)" "$ALERT_HANDLER_OUTPUT" ||
  ! grep -Fq "showAlert(alert.text)" "$ALERT_HANDLER_SOURCE" ||
  ! grep -Fq "return true" "$ALERT_HANDLER_SOURCE" ||
  ! grep -Fq 'require("./alertMessage")' "$ALERT_HANDLER_OUTPUT"; then
  printf '%s\n' "Alert dispatch must preserve validated, observable notification handling." >&2
  exit 1
fi

for test_contract in \
  "accepts and normalizes a valid alert" \
  "accepts ordinary Unicode alert text" \
  "accepts an own-property message with a null prototype" \
  "rejects non-record values and custom prototypes" \
  "rejects throwing reflection traps without escaping" \
  "rejects accessors without invoking them" \
  "accepts right-to-left script text without ordering controls" \
  "rejects inherited, missing, or wrong-typed fields" \
  "rejects empty, multiline, and oversized text" \
  "rejects display control characters and Unicode line separators"; do
  if ! grep -Fq "$test_contract" "$ALERT_TEST"; then
    printf '%s\n' "Alert parser tests must cover: $test_contract" >&2
    exit 1
  fi
done

for bidi_fixture in \
  "'\\u061c'" \
  "'\\u200e'" \
  "'\\u200f'" \
  "'\\u202a'" \
  "'\\u202b'" \
  "'\\u202c'" \
  "'\\u202d'" \
  "'\\u202e'" \
  "'\\u2066'" \
  "'\\u2067'" \
  "'\\u2068'" \
  "'\\u2069'"; do
  if ! grep -Fq "$bidi_fixture" "$ALERT_TEST"; then
    printf '%s\n' "Alert parser tests must retain bidi fixture: $bidi_fixture" >&2
    exit 1
  fi
done

if ! grep -Fq "rejects Unicode bidirectional ordering controls" "$ALERT_TEST" ||
  ! grep -Fq "Invoice \\u202etxt.exe" "$ALERT_TEST" ||
  ! grep -Fq "Invoice \\u202etxt.exe" "$ALERT_HANDLER_TEST"; then
  printf '%s\n' "Parser and dispatch tests must cover the complete bidi-control boundary." >&2
  exit 1
fi

for test_contract in \
  "dispatches one normalized notification for a valid alert" \
  "does not dispatch notifications for rejected alerts"; do
  if ! grep -Fq "$test_contract" "$ALERT_HANDLER_TEST"; then
    printf '%s\n' "Alert dispatch tests must cover: $test_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "Ready\\tNow" "$ALERT_HANDLER_TEST" ||
  ! grep -Fq "Ready\\u2028Now" "$ALERT_HANDLER_TEST" ||
  ! grep -Fq "assert.deepEqual(notifications, [])" "$ALERT_HANDLER_TEST"; then
  printf '%s\n' "Alert dispatch tests must reject display-control payloads without notifications." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$DISPATCH_TEST_PLAN"; then
  printf '%s\n' "Alert dispatch test plan must remain completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CONTROL_CHARACTER_PLAN" ||
  ! grep -Fq "Node 22.22.1 and Node 24.16.0" "$CONTROL_CHARACTER_PLAN" ||
  ! grep -Fq "Ten hostile mutations were rejected" "$CONTROL_CHARACTER_PLAN" ||
  ! grep -Fq "A VS Code extension host was not launched" "$CONTROL_CHARACTER_PLAN"; then
  printf '%s\n' "Alert control-character plan must record completed verification and its extension-host limit." >&2
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

if ! grep -Fq ".vscode/" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' ".gitignore must exclude local VS Code workspace metadata." >&2
  exit 1
fi

tracked_editor_files=$(git -C "$ROOT_DIR" ls-files -- .vscode)
if [ -n "$tracked_editor_files" ]; then
  printf '%s\n' "VS Code workspace metadata must not be tracked: $tracked_editor_files" >&2
  exit 1
fi

if ! grep -Fq "npm test" "$README"; then
  printf '%s\n' "README must document the npm test gate." >&2
  exit 1
fi

if ! grep -Fq "GitHub Actions" "$README"; then
  printf '%s\n' "README must document the GitHub Actions check." >&2
  exit 1
fi

if ! grep -Fq "make check" "$README"; then
  printf '%s\n' "README must document the root make check gate." >&2
  exit 1
fi

if ! grep -Fq "make build" "$README"; then
  printf '%s\n' "README must document the root make build gate." >&2
  exit 1
fi

if ! grep -Fq "npm run verify" "$README"; then
  printf '%s\n' "README must document the combined verify gate." >&2
  exit 1
fi

if ! grep -Fq "Node.js 22" "$README" || ! grep -Fq "audit --audit-level=moderate" "$README"; then
  printf '%s\n' "README must document the Node 22 and moderate-audit baselines." >&2
  exit 1
fi

if ! grep -Fq "non-empty normalized alert text" "$README"; then
  printf '%s\n' "README must document non-empty webview alert validation." >&2
  exit 1
fi

if ! grep -Fq "own alert message properties" "$README"; then
  printf '%s\n' "README must document own-property webview message validation." >&2
  exit 1
fi

if ! grep -Fq "plain non-array objects" "$README"; then
  printf '%s\n' "README must document plain-object webview message validation." >&2
  exit 1
fi

if ! grep -Fq "plain object prototypes" "$README"; then
  printf '%s\n' "README must document webview alert prototype validation." >&2
  exit 1
fi

if ! grep -Fq "crypto-generated CSP nonce" "$README"; then
  printf '%s\n' "README must document the crypto-generated CSP nonce baseline." >&2
  exit 1
fi

if ! grep -Fq "base URI and form submissions disabled" "$README"; then
  printf '%s\n' "README must document CSP navigation restrictions." >&2
  exit 1
fi

if ! grep -Fq "C0/C1 controls, Unicode line" "$README" ||
  ! grep -Fq "Rejected display control characters and Unicode" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Reject display controls and Unicode line separators" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "Maintenance docs must record the alert display-control boundary." >&2
  exit 1
fi

if ! grep -Fq "own data properties without invoking accessors" "$README" || \
  ! grep -Fq "accessor-backed and trap-throwing" "$ROOT_DIR/CHANGES.md" || \
  ! grep -Fq "Reject accessor-backed and trap-throwing" "$ROOT_DIR/VISION.md" || \
  ! grep -Fq "accessor-backed or reflective trap" "$ROOT_DIR/SECURITY.md" || \
  ! grep -Fq "R5. Parser and dispatch tests" "$ACCESSOR_GUARD_PLAN" || \
  ! grep -Fq "status: completed" "$ACCESSOR_GUARD_PLAN" || \
  ! grep -Fq "Eight isolated hostile mutations" "$ACCESSOR_GUARD_PLAN"; then
  printf '%s\n' "Maintenance docs and plan must record the fail-closed reflection boundary." >&2
	exit 1
fi

if ! grep -Fq "Unicode bidirectional ordering controls" "$README" ||
  ! grep -Fq "bidirectional ordering controls" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Rejected Unicode bidirectional ordering controls" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Reject Unicode bidirectional ordering controls" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "bidirectional ordering controls before notification dispatch" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Maintenance docs must record the bidi-control alert boundary." >&2
  exit 1
fi

for plan_contract in \
  'status: completed' \
  '## Status: Completed' \
  '## Work Completed' \
  '## Verification Completed' \
  'Node `22.22.2` and Node `24.16.0`' \
  'Ten isolated hostile mutations were rejected'; do
  if ! grep -Fq "$plan_contract" "$BIDI_CONTROL_PLAN"; then
    printf '%s\n' "Alert bidi-control plan must keep completed evidence: $plan_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "webview script is loaded from \`media/main.js\`" "$README"; then
  printf '%s\n' "README must document the external media script baseline." >&2
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

if ! grep -Fq "status: completed" "$ROOT_DIR/docs/plans/2026-06-09-cspeed-make-build-gate.md"; then
  printf '%s\n' "Make build gate plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/docs/plans/2026-06-09-cspeed-make-build-gate.md"; then
  printf '%s\n' "Make build gate plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$MEDIA_SCRIPT_PLAN"; then
  printf '%s\n' "Media script baseline plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$MEDIA_SCRIPT_PLAN"; then
  printf '%s\n' "Media script baseline plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MESSAGE_OWN_PROPERTY_PLAN"; then
  printf '%s\n' "Alert own-property plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$MESSAGE_OWN_PROPERTY_PLAN"; then
  printf '%s\n' "Alert own-property plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$EDITOR_METADATA_PLAN"; then
  printf '%s\n' "Editor metadata ignore plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$EDITOR_METADATA_PLAN"; then
  printf '%s\n' "Editor metadata ignore plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$ALERT_PLAIN_OBJECT_PLAN"; then
  printf '%s\n' "Alert plain-object plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ALERT_PLAIN_OBJECT_PLAN"; then
  printf '%s\n' "Alert plain-object plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$ALERT_PROTOTYPE_PLAN"; then
  printf '%s\n' "Alert object prototype plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ALERT_PROTOTYPE_PLAN"; then
  printf '%s\n' "Alert object prototype plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$CSP_NAVIGATION_PLAN"; then
  printf '%s\n' "CSP navigation restriction plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$CSP_NAVIGATION_PLAN"; then
  printf '%s\n' "CSP navigation restriction plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$CHECKOUT_CREDENTIAL_PLAN"; then
  printf '%s\n' "Checkout credential boundary plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$CHECKOUT_CREDENTIAL_PLAN"; then
  printf '%s\n' "Checkout credential boundary plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$PARSER_TEST_PLAN" ||
  ! grep -Fq "npm test" "$PARSER_TEST_PLAN"; then
  printf '%s\n' "Alert parser test plan must be completed and record npm test verification." >&2
  exit 1
fi

printf '%s\n' "CSpeed webview baseline checks passed."
