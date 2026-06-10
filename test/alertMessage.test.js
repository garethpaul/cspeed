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
