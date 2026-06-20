#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PACKAGE_JSON="$ROOT_DIR/package.json"
PACKAGE_LOCK="$ROOT_DIR/package-lock.json"
TSCONFIG="$ROOT_DIR/tsconfig.json"
SOURCE="$ROOT_DIR/src/extension.ts"
OUTPUT="$ROOT_DIR/out/extension.js"
PROVIDER_SOURCE="$ROOT_DIR/src/sidebarProvider.ts"
PROVIDER_OUTPUT="$ROOT_DIR/out/sidebarProvider.js"
PROVIDER_TEST="$ROOT_DIR/test/sidebarProvider.test.js"
EXTENSION_TEST="$ROOT_DIR/test/extension.test.js"
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
FORMAT_CONTROL_PLAN="$ROOT_DIR/docs/plans/2026-06-15-cspeed-invisible-format-controls.md"
INVISIBLE_OPERATOR_PLAN="$ROOT_DIR/docs/plans/2026-06-17-cspeed-invisible-operator-alerts.md"
LONE_SURROGATE_PLAN="$ROOT_DIR/docs/plans/2026-06-15-cspeed-alert-lone-surrogates.md"
TOOLCHAIN_PATCH_PLAN="$ROOT_DIR/docs/plans/2026-06-17-cspeed-lint-toolchain-patch-refresh.md"
TYPESCRIPT_6_PLAN="$ROOT_DIR/docs/plans/2026-06-18-001-chore-typescript-6-migration-plan.md"
PROVIDER_LIFECYCLE_PLAN="$ROOT_DIR/docs/plans/2026-06-14-cspeed-provider-lifecycle-tests.md"
EXTENSION_HOST_PLAN="$ROOT_DIR/docs/plans/2026-06-14-cspeed-extension-host-verification.md"
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
  "tsconfig.json" \
  "media/main.js" \
  "src/alertMessage.ts" \
  "src/alertMessageHandler.ts" \
  "src/extension.ts" \
  "src/sidebarProvider.ts" \
  "test/alertMessage.test.js" \
  "test/alertMessageHandler.test.js" \
  "test/extension.test.js" \
  "test/sidebarProvider.test.js" \
  "out/alertMessage.js" \
  "out/alertMessageHandler.js" \
  "out/extension.js" \
  "out/sidebarProvider.js" \
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
  "docs/plans/2026-06-14-cspeed-provider-lifecycle-tests.md" \
  "docs/plans/2026-06-15-cspeed-invisible-format-controls.md" \
  "docs/plans/2026-06-17-cspeed-invisible-operator-alerts.md" \
  "docs/plans/2026-06-17-cspeed-lint-toolchain-patch-refresh.md" \
  "docs/plans/2026-06-18-001-chore-typescript-6-migration-plan.md" \
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

if ! grep -Fq 'override ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))' "$MAKEFILE" ||
  [ "$(grep -c '\$(NPM) --prefix \$(ROOT)' "$MAKEFILE")" -ne 4 ]; then
  printf '%s\n' "Make targets must run npm from the repository root." >&2
  exit 1
fi

for package_contract in \
  '"node": ">=22.13.0 <25"' \
  '"vscode": "^1.120.0"' \
  '"@eslint/js": "10.0.1"' \
  '"@stylistic/eslint-plugin": "5.10.0"' \
  '"@types/node": "22.19.21"' \
  '"@types/vscode": "1.120.0"' \
  '"@types/vscode-webview": "1.57.5"' \
  '"eslint": "10.5.0"' \
  '"typescript": "6.0.3"' \
  '"typescript-eslint": "8.61.1"'; do
  if ! grep -Fq "$package_contract" "$PACKAGE_JSON"; then
    printf '%s\n' "package.json must keep dependency contract: $package_contract" >&2
    exit 1
  fi
done

if ! grep -Fq '"name": "cspeed"' "$PACKAGE_LOCK"; then
  printf '%s\n' "package-lock.json must align with package.json metadata." >&2
  exit 1
fi

node - "$PACKAGE_JSON" "$PACKAGE_LOCK" <<'NODE'
const fs = require('node:fs');
const { isDeepStrictEqual } = require('node:util');

const packageJson = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const lock = JSON.parse(fs.readFileSync(process.argv[3], 'utf8'));
const root = lock.packages?.[''];
const expectedDevDependencies = {
  '@eslint/js': '10.0.1',
  '@stylistic/eslint-plugin': '5.10.0',
  '@types/node': '22.19.21',
  '@types/vscode': '1.120.0',
  '@types/vscode-webview': '1.57.5',
  eslint: '10.5.0',
  typescript: '6.0.3',
  'typescript-eslint': '8.61.1',
};

if (!isDeepStrictEqual(packageJson.devDependencies, expectedDevDependencies)) {
  throw new Error('package.json devDependencies must match the reviewed toolchain baseline');
}

if (!root || !isDeepStrictEqual(root.devDependencies, packageJson.devDependencies)) {
  throw new Error('package-lock root devDependencies must exactly match package.json');
}

const artifacts = {
  'node_modules/@types/node': ['22.19.21', 'https://registry.npmjs.org/@types/node/-/node-22.19.21.tgz', 'sha512-VMeFBSCKQKmm2swI2kW51SFusDqekC6q9trBCvJ/JliDchFSuoYYKN7yVNjPthP1HKZcx3U1gI/wTcEBjEFKTA=='],
  'node_modules/@typescript-eslint/eslint-plugin': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-8.61.1.tgz', 'sha512-ZPlVl3PB3et/59Ne0fv/sci6ZXz4T4Hp4nTJ56i/Y0gR89ARb+KphojTq6j+56E5PIezmOIOOWyY+aWQFd+IkQ=='],
  'node_modules/@typescript-eslint/parser': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/parser/-/parser-8.61.1.tgz', 'sha512-PJ5vePq5/ognBbrIcoC5+SHO5dfpeLPzP9FpLkzWrguoYQEeeSjlJpVwOpo1JRSTEi7dRcwNy4h4dzV70PqHcg=='],
  'node_modules/@typescript-eslint/project-service': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/project-service/-/project-service-8.61.1.tgz', 'sha512-PrC4JYGmR241lYnfhmKGTXkFqv8+ymbTFgSAY0fVXpY82/QkMw5TZPl+vGzuDDU2QYJk9fIDOBTntF+yDv9LEA=='],
  'node_modules/@typescript-eslint/scope-manager': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-8.61.1.tgz', 'sha512-L2bdIeoQS8FlKAvONAr20w6OcLXeB+qiDKbAooS9A0Ben+iSIkBef0FxqwKWYqt5sa0i4KJtxVyVmhMylKzF5w=='],
  'node_modules/@typescript-eslint/tsconfig-utils': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/tsconfig-utils/-/tsconfig-utils-8.61.1.tgz', 'sha512-UN/H4di+OO7EWx2ovME+8t31YO+KVnK0RRKEHR3kOt21/Ay8BOq3M1OMvWs5vNiqcFCYGYoxK3MXPZzmMUE+yg=='],
  'node_modules/@typescript-eslint/type-utils': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-8.61.1.tgz', 'sha512-GYRicKmVK0C4fsKgaACaknOUAq9Oa2kwsjnpFhFcS/5p4Ht5IP9OVLbgIgcK4SRk92nVHFluurg1lumD9dBcLw=='],
  'node_modules/@typescript-eslint/types': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/types/-/types-8.61.1.tgz', 'sha512-G+CRlPqLv7Bz1IZVs03x5K59F1veqL0EJUROAdGhKsEq8qOiRiZbI+HUojPq5l0fEGOKModD9br6lObhB8zkoA=='],
  'node_modules/@typescript-eslint/typescript-estree': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-8.61.1.tgz', 'sha512-u+oQD3BqYWPc8YV9Zab4vaJElJuwOLPRc10Jm1o/qS+6Qwen14HCWwx0Seo4LnSn2wxea2Ik8DxPt2/FHmuhrg=='],
  'node_modules/@typescript-eslint/utils': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/utils/-/utils-8.61.1.tgz', 'sha512-1+P/3Dj6jvtybE1q0HQ6yBt/gq+oKJyLdEv4HdnqasaEXRSYCAsD59mXEVQnM/ULNdQxbX77tdG4jPRjIS6knA=='],
  'node_modules/@typescript-eslint/visitor-keys': ['8.61.1', 'https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-8.61.1.tgz', 'sha512-6fJ9MHWtK14C1DSkiMlHUSOmrVebL7150xZJBlJiL62jjhIA4JmOq6flwBgDxIdBKKdoiZRel+dfPD5MLfny3w=='],
  'node_modules/eslint': ['10.5.0', 'https://registry.npmjs.org/eslint/-/eslint-10.5.0.tgz', 'sha512-1y+7C+vi12bUK1IpZeaV3gsH9fHLBmPvYmPx42pvT/E9yG0IC8g3PUZZgp0+JLJl7ZDK0flc2gc+Aw9dpCvIsQ=='],
  'node_modules/typescript': ['6.0.3', 'https://registry.npmjs.org/typescript/-/typescript-6.0.3.tgz', 'sha512-y2TvuxSZPDyQakkFRPZHKFm+KKVqIisdg9/CZwm9ftvKXLP8NRWj38/ODjNbr43SsoXqNuAisEf1GdCxqWcdBw=='],
  'node_modules/typescript-eslint': ['8.61.1', 'https://registry.npmjs.org/typescript-eslint/-/typescript-eslint-8.61.1.tgz', 'sha512-V7PayAfJokV3pEHgN7/v03D1SpujhRfQtYLbLIiBfDDncdg4PAiRBfoS4cnCANK4jmAPncczi59QO3afiXUlNw=='],
};

for (const [path, [version, resolved, integrity]] of Object.entries(artifacts)) {
  const artifact = lock.packages?.[path];
  if (!artifact || artifact.version !== version || artifact.resolved !== resolved || artifact.integrity !== integrity) {
    throw new Error(`package-lock artifact drifted: ${path}`);
  }
}

const expectedFamily = Object.keys(artifacts)
  .filter((path) => path.startsWith('node_modules/@typescript-eslint/'))
  .sort();
const actualFamily = Object.keys(lock.packages || {})
  .filter((path) => /^node_modules\/@typescript-eslint\/[^/]+$/.test(path))
  .sort();
if (JSON.stringify(actualFamily) !== JSON.stringify(expectedFamily)) {
  throw new Error('package-lock @typescript-eslint family must remain complete and aligned');
}
NODE

if ! grep -Fq '"types": ["node", "vscode"]' "$TSCONFIG"; then
  printf '%s\n' "TypeScript 6 must use explicit Node and VS Code type roots." >&2
  exit 1
fi

if ! grep -Fq "Content-Security-Policy" "$PROVIDER_SOURCE"; then
  printf '%s\n' "Webview HTML must include a content security policy." >&2
  exit 1
fi

if ! grep -Fq "script-src 'nonce-" "$PROVIDER_SOURCE"; then
  printf '%s\n' "Webview scripts must be constrained by a nonce." >&2
  exit 1
fi

if ! grep -Fq "base-uri 'none'" "$PROVIDER_SOURCE" ||
   ! grep -Fq "form-action 'none'" "$PROVIDER_SOURCE"; then
  printf '%s\n' "Webview CSP must disable base URI and form submissions explicitly." >&2
  exit 1
fi

if ! grep -Fq "randomBytes(16).toString('base64')" "$PROVIDER_SOURCE"; then
  printf '%s\n' "Webview CSP nonce must be generated with Node crypto." >&2
  exit 1
fi

if grep -Fq "Math.random()" "$PROVIDER_SOURCE"; then
  printf '%s\n' "Webview CSP nonce must not use Math.random." >&2
  exit 1
fi

if grep -Fq "onclick=" "$PROVIDER_SOURCE"; then
  printf '%s\n' "Webview HTML must not use inline event handlers." >&2
  exit 1
fi

if ! grep -Fq "webview.asWebviewUri(" "$PROVIDER_SOURCE" ||
   ! grep -Fq "this.dependencies.joinPath(this.extensionUri, 'media', 'main.js')" "$PROVIDER_SOURCE"; then
  printf '%s\n' "Webview HTML must load its script through a scoped media URI." >&2
  exit 1
fi

if ! grep -Fq '<script nonce="${nonce}" src="${scriptUri}"></script>' "$PROVIDER_SOURCE"; then
  printf '%s\n' "Webview script tags must keep the nonce on the external media script." >&2
  exit 1
fi

if ! grep -Fq "localResourceRoots: [this.dependencies.joinPath(this.extensionUri, 'media')]" "$PROVIDER_SOURCE"; then
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

if ! grep -Fq "Content-Security-Policy" "$PROVIDER_OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with the CSP source." >&2
  exit 1
fi

if ! grep -Fq "base-uri 'none'" "$PROVIDER_OUTPUT" ||
   ! grep -Fq "form-action 'none'" "$PROVIDER_OUTPUT"; then
  printf '%s\n' "Compiled output must stay synchronized with CSP navigation restrictions." >&2
  exit 1
fi

if ! grep -Fq "webview.asWebviewUri(this.dependencies.joinPath(this.extensionUri, 'media', 'main.js'))" "$PROVIDER_OUTPUT" ||
   ! grep -Fq '<script nonce="${nonce}" src="${scriptUri}"></script>' "$PROVIDER_OUTPUT"; then
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

if ! grep -Fq "import { SidebarProvider } from './sidebarProvider'" "$SOURCE" ||
  ! grep -Fq "import { dispatchAlertMessage } from './alertMessageHandler'" "$PROVIDER_SOURCE" ||
  ! grep -Fq "dispatchAlertMessage(message, text => this.dependencies.showInformationMessage(text))" "$PROVIDER_SOURCE" ||
  ! grep -Fq 'require("./sidebarProvider")' "$OUTPUT" ||
  ! grep -Fq 'require("./alertMessageHandler")' "$PROVIDER_OUTPUT"; then
  printf '%s\n' "Extension source and output must use the tested alert dispatch module." >&2
  exit 1
fi

if ! grep -Fq "vscode.window.registerWebviewViewProvider('sidebarWebviewView', provider)" "$SOURCE" ||
  ! grep -Fq "joinPath: vscode.Uri.joinPath" "$SOURCE" ||
  ! grep -Fq "showInformationMessage: text => vscode.window.showInformationMessage(text)" "$SOURCE"; then
  printf '%s\n' "Extension activation must register the declared view with explicit provider dependencies." >&2
  exit 1
fi

if ! grep -Fq "const messageSubscription = webviewView.webview.onDidReceiveMessage" "$PROVIDER_SOURCE" ||
  ! grep -Fq "webviewView.onDidDispose(() => messageSubscription.dispose())" "$PROVIDER_SOURCE" ||
  ! grep -Fq "messageSubscription.dispose()" "$PROVIDER_OUTPUT"; then
  printf '%s\n' "Sidebar provider must dispose each message listener with its owning view." >&2
  exit 1
fi

for provider_test_contract in \
  "resolves a script-enabled media-scoped webview with a nonce CSP" \
  "dispatches only validated alerts to the notification dependency" \
  "disposes the message listener with its owning webview" \
  "assert.deepEqual(harness.notifications, ['Ready'])" \
  "assert.equal(harness.getMessageDisposals(), 1)"; do
  if ! grep -Fq "$provider_test_contract" "$PROVIDER_TEST"; then
    printf '%s\n' "Sidebar provider tests must preserve lifecycle contract: $provider_test_contract" >&2
    exit 1
  fi
done

for extension_test_contract in \
  "activation registers and retains the contributed sidebar provider" \
  "assert.equal(registered.viewId, 'sidebarWebviewView')" \
  "assert.deepEqual(context.subscriptions, [registration])"; do
  if ! grep -Fq "$extension_test_contract" "$EXTENSION_TEST"; then
    printf '%s\n' "Extension activation tests must preserve registration contract: $extension_test_contract" >&2
    exit 1
  fi
done

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

if ! grep -Fq 'require("crypto")' "$PROVIDER_OUTPUT" || ! grep -Fq "crypto_1.randomBytes)(16).toString('base64')" "$PROVIDER_OUTPUT"; then
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

for source_contract in \
  'codePoint === 0x00ad' \
  'codePoint >= 0x200b && codePoint <= 0x200d' \
  'codePoint === 0x2060' \
  'codePoint === 0xfeff'; do
  if ! grep -Fq "$source_contract" "$ALERT_SOURCE" ||
    ! grep -Fq "$source_contract" "$ALERT_OUTPUT"; then
    printf '%s\n' "Alert parser source and output must reject invisible format controls: $source_contract" >&2
    exit 1
  fi
done

for format_class_source in "$ALERT_SOURCE" "$ALERT_OUTPUT"; do
  if ! grep -Fq 'unicodeFormatCharacterPattern = /\p{Cf}/u' "$format_class_source"; then
    printf '%s\n' "Alert parser source and output must reject the Unicode format-character class." >&2
    exit 1
  fi
done

if ! grep -Fq "rejects invisible Unicode format controls" "$ALERT_TEST" ||
  ! grep -Fq "'\\u{e0061}'" "$ALERT_TEST" ||
  ! grep -Fq "Ready\\u200bNow" "$ALERT_HANDLER_TEST" ||
  ! grep -Fq "Ready\\u{e0061}Now" "$ALERT_HANDLER_TEST" ||
  ! grep -Fq "invisible Unicode format controls" "$README" ||
  ! grep -Fq "invisible Unicode format controls" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Rejected invisible Unicode format controls" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Reject invisible Unicode format controls" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "rejects invisible Unicode format controls before notification dispatch" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Tests and maintenance docs must record the invisible format-control boundary." >&2
  exit 1
fi

for plan_contract in \
  'status: completed' \
  '## Status: Completed' \
  '## Work Completed' \
  '## Verification Completed' \
  'hostile mutations were rejected' \
  'A VS Code Extension Host was not launched'; do
  if ! grep -Fq "$plan_contract" "$FORMAT_CONTROL_PLAN"; then
    printf '%s\n' "Invisible format-control plan must keep completed evidence: $plan_contract" >&2
    exit 1
  fi
done

for invisible_operator_source in "$ALERT_SOURCE" "$ALERT_OUTPUT"; do
  if ! grep -Fq 'codePoint >= 0x2061 && codePoint <= 0x2064' "$invisible_operator_source"; then
    printf '%s\n' "Alert parser source and output must reject Unicode invisible operators." >&2
    exit 1
  fi
done

if ! grep -Fq "const invisibleOperators = ['\\u2061', '\\u2062', '\\u2063', '\\u2064']" "$ALERT_TEST" ||
  ! grep -Fq "{ command: 'alert', text: 'Ready\\u2061Now' }" "$ALERT_HANDLER_TEST" ||
  ! grep -Fq "{ command: 'alert', text: 'Ready\\u2064Now' }" "$ALERT_HANDLER_TEST"; then
  printf '%s\n' "Parser and dispatch tests must cover all Unicode invisible operators." >&2
  exit 1
fi

for invisible_operator_doc in "$README" "$ROOT_DIR/AGENTS.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md"; do
  if ! grep -Fq 'Unicode invisible operators' "$invisible_operator_doc"; then
    printf '%s\n' "${invisible_operator_doc#"$ROOT_DIR/"} must document the Unicode invisible operators boundary." >&2
    exit 1
  fi
done

for invisible_operator_plan_contract in \
  'U+2061' \
  'U+2064' \
  'Node 22' \
  'Node 24' \
  'exact-head push and pull-request checks'; do
  if ! grep -Fq "$invisible_operator_plan_contract" "$INVISIBLE_OPERATOR_PLAN"; then
    printf '%s\n' "Invisible operator plan must preserve completed evidence: $invisible_operator_plan_contract" >&2
    exit 1
  fi
done

invisible_operator_plan_status=$(sed -n 's/^status: //p' "$INVISIBLE_OPERATOR_PLAN")
case "$invisible_operator_plan_status" in
  pending_hosted_verification)
    if ! grep -Fq 'Exact-head hosted checks remain pending.' "$INVISIBLE_OPERATOR_PLAN"; then
      printf '%s\n' "Pending invisible operator plan must record pending hosted checks." >&2
      exit 1
    fi
    ;;
  completed)
    if grep -Fq 'Exact-head hosted checks remain pending.' "$INVISIBLE_OPERATOR_PLAN"; then
      printf '%s\n' "Completed invisible operator plan must not claim pending hosted checks." >&2
      exit 1
    fi
    if ! grep -Fq 'hostile mutations were rejected' "$INVISIBLE_OPERATOR_PLAN"; then
      printf '%s\n' "Completed invisible operator plan must record mutation evidence." >&2
      exit 1
    fi
    ;;
  *)
    printf '%s\n' "Invisible operator plan status must be pending_hosted_verification or completed." >&2
    exit 1
    ;;
esac

for toolchain_doc_contract in \
  'ESLint 10.5.0' \
  'typescript-eslint 8.61.1' \
  '@types/node 22.19.21' \
  'TypeScript 6.0.3' \
  'Node 25'; do
  for maintained_doc in "$README" "$ROOT_DIR/AGENTS.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md"; do
    if ! grep -Fq "$toolchain_doc_contract" "$maintained_doc"; then
      printf '%s\n' "Maintained guidance must record toolchain contract '$toolchain_doc_contract' in ${maintained_doc#"$ROOT_DIR/"}." >&2
      exit 1
    fi
  done
done

for typescript_6_plan_contract in \
  'TypeScript 6.0.3' \
  'explicit Node and VS Code type roots' \
  'Node 22.22.2' \
  'Node 24.16.0' \
  'All six isolated hostile mutations were rejected' \
  'Do not raise the supported Node range or VS Code engine requirement'; do
  if ! grep -Fq "$typescript_6_plan_contract" "$TYPESCRIPT_6_PLAN"; then
    printf '%s\n' "TypeScript 6 migration plan must retain contract: $typescript_6_plan_contract" >&2
    exit 1
  fi
done

toolchain_plan_status=$(sed -n 's/^status: //p' "$TOOLCHAIN_PATCH_PLAN")
case "$toolchain_plan_status" in
  pending_hosted_verification)
    if ! grep -Fq 'Exact-head hosted checks remain pending.' "$TOOLCHAIN_PATCH_PLAN"; then
      printf '%s\n' "Pending toolchain plan must record pending exact-head hosted checks." >&2
      exit 1
    fi
    ;;
  completed)
    for plan_contract in \
      'Both exact-head push and pull-request Node 22/24 matrices passed.' \
      'isolated hostile mutations were rejected' \
      'fa5b13aa45d2e7f7a44111f1912cf1731af8955b' \
      '27663023413' \
      '27663027246'; do
      if ! grep -Fq "$plan_contract" "$TOOLCHAIN_PATCH_PLAN"; then
        printf '%s\n' "Completed toolchain plan must retain verification evidence: $plan_contract" >&2
        exit 1
      fi
    done
    ;;
  *)
    printf '%s\n' "Toolchain patch plan must be pending hosted verification or completed." >&2
    exit 1
    ;;
esac

for plan_contract in \
  'Node `22.22.2` and Node `24.16.0`' \
  'lockfile-pinned install' \
  'make check' \
  'isolated hostile mutations were rejected'; do
  if ! grep -Fq "$plan_contract" "$TOOLCHAIN_PATCH_PLAN"; then
    printf '%s\n' "Toolchain patch plan must retain local verification evidence: $plan_contract" >&2
    exit 1
  fi
done

if ! grep -Fq 'codePoint >= 0xd800 && codePoint <= 0xdfff' "$ALERT_SOURCE" || \
  ! grep -Fq 'codePoint >= 0xd800 && codePoint <= 0xdfff' "$ALERT_OUTPUT" || \
  ! grep -Fq "rejects lone UTF-16 surrogates while accepting valid pairs" "$ALERT_TEST" || \
  ! grep -Fq 'Ready\ud800Now' "$ALERT_TEST" || \
  ! grep -Fq 'Ready\udfffNow' "$ALERT_TEST" || \
  ! grep -Fq 'Ready \ud83d\ude80' "$ALERT_TEST" || \
  ! grep -Fq 'Ready\ud800Now' "$ALERT_HANDLER_TEST" || \
  ! grep -Fq 'Ready\udfffNow' "$ALERT_HANDLER_TEST"; then
  printf '%s\n' "Parser, output, and dispatch tests must preserve the lone-surrogate boundary." >&2
  exit 1
fi

if ! grep -Fq "lone UTF-16 surrogates" "$README" || \
  ! grep -Fq "lone UTF-16 surrogates" "$ROOT_DIR/SECURITY.md" || \
  ! grep -Fq "Rejected malformed lone UTF-16 surrogates" "$ROOT_DIR/CHANGES.md" || \
  ! grep -Fq "Reject lone UTF-16 surrogates" "$ROOT_DIR/VISION.md" || \
  ! grep -Fq "rejects lone UTF-16 surrogates" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Maintenance docs must record the lone-surrogate alert boundary." >&2
  exit 1
fi

for plan_contract in \
  'status: completed' \
  '## Status: Completed' \
  '## Work Completed' \
  '## Verification Completed' \
  'hostile mutations were rejected' \
  'A VS Code Extension Host was not launched'; do
  if ! grep -Fq "$plan_contract" "$LONE_SURROGATE_PLAN"; then
    printf '%s\n' "Lone-surrogate plan must keep completed evidence: $plan_contract" >&2
    exit 1
  fi
done

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

for provider_plan_contract in \
  "Status: Completed" \
  "Verification: Completed" \
  "Node 22.22.2 and Node 24.16.0" \
  "Ten focused hostile mutations" \
  "no actionable issues" \
  "This change claims no browser or live VS Code Extension Host execution"; do
  if ! grep -Fq "$provider_plan_contract" "$PROVIDER_LIFECYCLE_PLAN"; then
    printf '%s\n' "Provider lifecycle plan must record completed evidence: $provider_plan_contract" >&2
    exit 1
  fi
done

for required_host_path in "$ROOT_DIR/EXTENSION_HOST_VERIFICATION.md" "$EXTENSION_HOST_PLAN"; do
  if [ ! -f "$required_host_path" ]; then
    printf '%s\n' "Required Extension Host verification file is missing: ${required_host_path#"$ROOT_DIR/"}" >&2
    exit 1
  fi
done

for host_contract in \
  'commit SHA and pull request' \
  'synthetic empty workspace and synthetic alert text' \
  'Install exact-head extension' \
  'Activation by contributed view' \
  'Sidebar view render' \
  'CSP and media loading' \
  'Valid alert notification' \
  'Control-character alert' \
  'Bidirectional-control alert' \
  'Hostile object shape' \
  'View disposal' \
  'View reopen' \
  'Extension Host reload' \
  'Multiple windows' \
  'Restricted workspace' \
  'Do not convert `not run` into passing evidence.' \
  'usernames, filesystem paths, workspace contents' \
  'every VS Code, sidebar, webview, notification, disposal, and workspace row as unexecuted'; do
  if ! grep -Fq "$host_contract" "$ROOT_DIR/EXTENSION_HOST_VERIFICATION.md"; then
    printf '%s\n' "Extension Host checklist must keep contract: $host_contract" >&2
    exit 1
  fi
done

if ! grep -Fq 'EXTENSION_HOST_VERIFICATION.md' "$README" || \
   ! grep -Fq 'explicit unexecuted rows' "$README" || \
   ! grep -Fq 'CSpeed Extension Host verification matrix' "$ROOT_DIR/VISION.md" || \
   ! grep -Fq 'every integration row explicitly unexecuted' "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' 'Project guidance must document the unexecuted Extension Host matrix.' >&2
  exit 1
fi

for host_plan_contract in \
  'Status: Completed' \
  'make check' \
  'hostile mutations' \
  'No browser, VS Code desktop, Extension Host, rendered webview, notification, view disposal, multi-window, or workspace trust scenario was executed'; do
  if ! grep -Fq "$host_plan_contract" "$EXTENSION_HOST_PLAN"; then
    printf '%s\n' "Extension Host plan must keep completion evidence: $host_plan_contract" >&2
    exit 1
  fi
done

printf '%s\n' "CSpeed webview baseline checks passed."
