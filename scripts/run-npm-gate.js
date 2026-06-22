#!/usr/bin/env node
'use strict';

const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

const allowedArguments = new Set([
	'run\0lint',
	'test',
	'run\0check:generated',
	'audit\0--audit-level=moderate'
]);
const npmArguments = process.argv.slice(2);

function fail() {
	console.error('Unable to verify the CSpeed launcher context.');
	process.exit(2);
}

if (!allowedArguments.has(npmArguments.join('\0'))) fail();

let context;
let root;
try {
	const contextPath = process.env.CSPEED_LAUNCH_CONTEXT;
	const token = process.env.CSPEED_LAUNCH_TOKEN;
	if (!contextPath || !token) fail();
	context = JSON.parse(fs.readFileSync(contextPath, 'utf8'));
	if (typeof context.root !== 'string' || typeof context.token !== 'string') fail();
	const actualToken = Buffer.from(token);
	const expectedToken = Buffer.from(context.token);
	if (actualToken.length !== expectedToken.length || !crypto.timingSafeEqual(actualToken, expectedToken)) fail();
	root = fs.realpathSync(process.cwd());
	if (root !== context.root) fail();
	const packageJson = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
	const makefile = fs.readFileSync(path.join(root, 'Makefile'), 'utf8');
	if (packageJson.name !== 'cspeed' || !/^CSPEED_REPOSITORY_MAKEFILE := 1$/m.test(makefile)) fail();
} catch {
	fail();
}

const result = spawnSync('npm', ['--prefix', root, ...npmArguments], {
	stdio: 'inherit',
	shell: false
});
if (result.error) {
	console.error(result.error.message);
	process.exit(127);
}
process.exit(result.status === null ? 1 : result.status);
