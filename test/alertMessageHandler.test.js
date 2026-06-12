'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');
const { dispatchAlertMessage } = require('../out/alertMessageHandler.js');

test('dispatches one normalized notification for a valid alert', () => {
	const notifications = [];

	const handled = dispatchAlertMessage(
		{ command: 'alert', text: '  Ready  ' },
		text => notifications.push(text)
	);

	assert.equal(handled, true);
	assert.deepEqual(notifications, ['Ready']);
});

test('does not dispatch notifications for rejected alerts', () => {
	const inherited = Object.create({ command: 'alert', text: 'Ready' });
	const rejectedMessages = [
		undefined,
		{},
		inherited,
		{ command: 'other', text: 'Ready' },
		{ command: 'alert', text: '   ' },
		{ command: 'alert', text: 'line one\nline two' },
		{ command: 'alert', text: 'x'.repeat(201) }
	];
	const notifications = [];

	for (const message of rejectedMessages) {
		assert.equal(dispatchAlertMessage(message, text => notifications.push(text)), false);
	}

	assert.deepEqual(notifications, []);
});
