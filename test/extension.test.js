'use strict';

const assert = require('node:assert/strict');
const Module = require('node:module');
const test = require('node:test');

test('activation registers and retains the contributed sidebar provider', () => {
	const extensionPath = require.resolve('../out/extension.js');
	delete require.cache[extensionPath];
	const originalLoad = Module._load;
	const registration = { disposed: false };
	let registered;
	Module._load = function(request, parent, isMain) {
		if (request === 'vscode') {
			return {
				Uri: {
					joinPath(base, ...segments) {
						return { base, segments };
					}
				},
				window: {
					registerWebviewViewProvider(viewId, provider) {
						registered = { viewId, provider };
						return registration;
					},
					showInformationMessage() {}
				}
			};
		}
		return originalLoad.call(this, request, parent, isMain);
	};

	try {
		const { activate } = require(extensionPath);
		const context = { extensionUri: { path: '/extension' }, subscriptions: [] };
		activate(context);

		assert.equal(registered.viewId, 'sidebarWebviewView');
		assert.equal(registered.provider.constructor.name, 'SidebarProvider');
		assert.deepEqual(context.subscriptions, [registration]);
	} finally {
		Module._load = originalLoad;
		delete require.cache[extensionPath];
	}
});
