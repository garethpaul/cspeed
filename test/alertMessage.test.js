'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');
const { parseAlertMessage } = require('../out/alertMessage.js');

test('accepts and normalizes a valid alert', () => {
	assert.deepEqual(
		parseAlertMessage({ command: 'alert', text: '  Ready  ' }),
		{ command: 'alert', text: 'Ready' }
	);
});

test('accepts ordinary Unicode alert text', () => {
	assert.deepEqual(
		parseAlertMessage({ command: 'alert', text: '  Caf\u00e9 \u6771\u4eac \ud83d\ude80  ' }),
		{ command: 'alert', text: 'Caf\u00e9 \u6771\u4eac \ud83d\ude80' }
	);
});

test('rejects lone UTF-16 surrogates while accepting valid pairs', () => {
	assert.equal(parseAlertMessage({ command: 'alert', text: 'Ready\ud800Now' }), undefined);
	assert.equal(parseAlertMessage({ command: 'alert', text: 'Ready\udfffNow' }), undefined);
	assert.deepEqual(
		parseAlertMessage({ command: 'alert', text: '  Ready \ud83d\ude80  ' }),
		{ command: 'alert', text: 'Ready \ud83d\ude80' }
	);
});

test('accepts right-to-left script text without ordering controls', () => {
	assert.deepEqual(
		parseAlertMessage({ command: 'alert', text: '  \u0645\u0631\u062d\u0628\u0627 \u05e9\u05dc\u05d5\u05dd  ' }),
		{ command: 'alert', text: '\u0645\u0631\u062d\u0628\u0627 \u05e9\u05dc\u05d5\u05dd' }
	);
});

test('accepts an own-property message with a null prototype', () => {
	const message = Object.create(null);
	message.command = 'alert';
	message.text = 'Ready';
	assert.deepEqual(parseAlertMessage(message), { command: 'alert', text: 'Ready' });
});

test('rejects non-record values and custom prototypes', () => {
	assert.equal(parseAlertMessage(undefined), undefined);
	assert.equal(parseAlertMessage([]), undefined);
	assert.equal(parseAlertMessage(Object.create({ command: 'alert', text: 'Ready' })), undefined);
});

test('rejects throwing reflection traps without escaping', () => {
	const message = new Proxy({}, {
		getPrototypeOf() {
			throw new Error('prototype trap sentinel');
		}
	});
	assert.doesNotThrow(() => assert.equal(parseAlertMessage(message), undefined));

	const revocable = Proxy.revocable({}, {});
	revocable.revoke();
	assert.doesNotThrow(() => assert.equal(parseAlertMessage(revocable.proxy), undefined));
});

test('rejects accessors without invoking them', () => {
	let getterCalls = 0;
	const message = {};
	Object.defineProperties(message, {
		command: {
			get() {
				getterCalls += 1;
				throw new Error('command getter sentinel');
			}
		},
		text: { value: 'Ready', enumerable: true }
	});

	assert.equal(parseAlertMessage(message), undefined);
	assert.equal(getterCalls, 0);
});

test('rejects inherited, missing, or wrong-typed fields', () => {
	assert.equal(parseAlertMessage({ text: 'Ready' }), undefined);
	assert.equal(parseAlertMessage({ command: 'alert' }), undefined);
	assert.equal(parseAlertMessage({ command: 'other', text: 'Ready' }), undefined);
	assert.equal(parseAlertMessage({ command: 'alert', text: 1 }), undefined);
});

test('rejects empty, multiline, and oversized text', () => {
	assert.equal(parseAlertMessage({ command: 'alert', text: '   ' }), undefined);
	assert.equal(parseAlertMessage({ command: 'alert', text: 'line one\nline two' }), undefined);
	assert.equal(parseAlertMessage({ command: 'alert', text: 'x'.repeat(201) }), undefined);
});

test('rejects display control characters and Unicode line separators', () => {
	const rejectedText = [
		'\tReady',
		'Ready\u0000Now',
		'Ready\u001fNow',
		'Ready\u007fNow',
		'Ready\u0085Now',
		'Ready\u2028Now',
		'Ready\u2029Now'
	];

	for (const text of rejectedText) {
		assert.equal(parseAlertMessage({ command: 'alert', text }), undefined);
	}
});

test('rejects Unicode bidirectional ordering controls', () => {
	const bidiControls = [
		'\u061c',
		'\u200e',
		'\u200f',
		'\u202a',
		'\u202b',
		'\u202c',
		'\u202d',
		'\u202e',
		'\u2066',
		'\u2067',
		'\u2068',
		'\u2069'
	];

	for (const control of bidiControls) {
		assert.equal(parseAlertMessage({ command: 'alert', text: `Ready${control}Now` }), undefined);
	}
	assert.equal(
		parseAlertMessage({ command: 'alert', text: 'Invoice \u202etxt.exe' }),
		undefined
	);
});

test('rejects invisible Unicode format controls', () => {
	const formatControls = [
		'\u00ad',
		'\u200b',
		'\u200c',
		'\u200d',
		'\u2060',
		'\ufeff'
	];

	for (const control of formatControls) {
		assert.equal(parseAlertMessage({ command: 'alert', text: `Ready${control}Now` }), undefined);
	}
});
