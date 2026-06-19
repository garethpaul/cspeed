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

test('resolves a script-enabled media-scoped webview with a nonce CSP', () => {
	const harness = createHarness();

	assert.deepEqual(harness.webview.options, {
		enableScripts: true,
		localResourceRoots: [{ path: '/extension/media' }]
	});
	assert.deepEqual(harness.joinedPaths, [['media'], ['media', 'main.js']]);
	assert.match(harness.webview.html, /default-src 'none'; base-uri 'none'; form-action 'none'/);
	assert.match(harness.webview.html, /script-src 'nonce-[A-Za-z0-9+/]{22}=='/);
	assert.match(
		harness.webview.html,
		/<script nonce="[A-Za-z0-9+/]{22}==" src="webview:\/extension\/media\/main\.js"><\/script>/
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
