'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');
const { SidebarProvider } = require('../out/sidebarProvider.js');

function createHarness() {
	const notifications = [];
	const joinedPaths = [];
	let messageListener;
	let disposeListener;
	let messageDisposals = 0;
	const extensionUri = { path: '/extension' };
	const provider = new SidebarProvider(extensionUri, {
		joinPath(base, ...segments) {
			assert.equal(base, extensionUri);
			joinedPaths.push(segments);
			return { path: [base.path, ...segments].join('/') };
		},
		showInformationMessage(text) {
			notifications.push(text);
		}
	});
	const webview = {
		cspSource: 'vscode-webview-resource:',
		html: '',
		options: {},
		asWebviewUri(uri) {
			return `webview:${uri.path}`;
		},
		onDidReceiveMessage(listener) {
			messageListener = listener;
			return {
				dispose() {
					messageDisposals += 1;
				}
			};
		}
	};
	const webviewView = {
		webview,
		onDidDispose(listener) {
			disposeListener = listener;
			return { dispose() {} };
		}
	};

	provider.resolveWebviewView(webviewView, {}, {});
	return {
		dispose() {
			disposeListener();
		},
		getMessageDisposals() {
			return messageDisposals;
		},
		joinedPaths,
		notifications,
		sendMessage(message) {
			messageListener(message);
		},
		webview
	};
}

test('resolves a script-only media-scoped webview with a nonce CSP', () => {
	const harness = createHarness();

	assert.deepEqual(harness.webview.options, {
		enableScripts: true,
		localResourceRoots: [{ path: '/extension/media' }]
	});
	assert.deepEqual(harness.joinedPaths, [['media'], ['media', 'main.js']]);
	assert.match(harness.webview.html, /default-src 'none'; base-uri 'none'; form-action 'none'/);
	assert.doesNotMatch(harness.webview.html, /(?:img|style)-src vscode-webview-resource:/);
	assert.match(harness.webview.html, /script-src 'nonce-[A-Za-z0-9+/]{22}=='/);
	assert.match(
		harness.webview.html,
		/<script nonce="[A-Za-z0-9+/]{22}==" src="webview:\/extension\/media\/main\.js"><\/script>/
	);
});

// Shape alone does not make a nonce a nonce. A hardcoded value matches
// /nonce-[A-Za-z0-9+/]{22}==/ perfectly, and the baseline only greps that
// randomBytes(16) appears in the source -- which a decoy satisfies while
// returning a constant. A predictable nonce voids the CSP entirely, so assert
// that it actually varies between renders and that the CSP and the script tag
// carry the same value.
function nonceFrom(html) {
	const directive = html.match(/script-src 'nonce-([A-Za-z0-9+/]{22}==)'/);
	assert.ok(directive, 'CSP must carry a nonce-<value> script-src');
	const tag = html.match(/<script nonce="([A-Za-z0-9+/]{22}==)"/);
	assert.ok(tag, 'the script tag must carry a nonce');
	assert.equal(
		directive[1],
		tag[1],
		'the CSP nonce and the script tag nonce must be the same value'
	);
	return directive[1];
}

test('issues a fresh unpredictable nonce for every webview render', () => {
	const nonces = new Set();
	for (let index = 0; index < 8; index += 1) {
		nonces.add(nonceFrom(createHarness().webview.html));
	}
	assert.equal(
		nonces.size,
		8,
		`nonce must differ on every render; got ${nonces.size} distinct values across 8 renders`
	);
});

// Pin the whole policy, not a prefix. assert.match is a substring test, so
// `script-src 'nonce-X' 'unsafe-eval' https:` satisfied the existing
// /script-src 'nonce-...'/ assertion while widening the policy arbitrarily.
// 'unsafe-inline' would be ignored by the browser beside a nonce, but
// 'unsafe-eval' and a host source are not.
test('keeps the content security policy exactly script-only', () => {
	const harness = createHarness();
	const policy = harness.webview.html.match(
		/<meta http-equiv="Content-Security-Policy" content="([^"]+)">/
	);
	assert.ok(policy, 'the webview must declare a Content-Security-Policy meta');

	const nonce = nonceFrom(harness.webview.html);
	assert.equal(
		policy[1],
		[
			"default-src 'none'",
			"base-uri 'none'",
			"form-action 'none'",
			`script-src 'nonce-${nonce}'`
		].join('; '),
		'the CSP must remain exactly the reviewed script-only policy'
	);
});

test('dispatches only validated alerts to the notification dependency', () => {
	const harness = createHarness();

	harness.sendMessage({ command: 'alert', text: '  Ready  ' });
	harness.sendMessage({ command: 'alert', text: 'Invoice \u202etxt.exe' });
	harness.sendMessage({ command: 'other', text: 'Ignored' });

	assert.deepEqual(harness.notifications, ['Ready']);
});

test('disposes the message listener with its owning webview', () => {
	const harness = createHarness();

	assert.equal(harness.getMessageDisposals(), 0);
	harness.dispose();
	assert.equal(harness.getMessageDisposals(), 1);
});
