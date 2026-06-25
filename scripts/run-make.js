#!/usr/bin/env node
'use strict';

const crypto = require('node:crypto');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

const targets = new Map([
	['lint', '__cspeed_lint'],
	['test', '__cspeed_test'],
	['build', '__cspeed_build'],
	['audit', '__cspeed_audit'],
	['verify', '__cspeed_verify'],
	['check', '__cspeed_check']
]);

const args = process.argv.slice(2);
if (args.length !== 2 || !targets.has(args[1])) {
	console.error('Usage: node scripts/run-make.js <repository> <lint|test|build|audit|verify|check>');
	process.exit(2);
}

let root;
try {
	root = fs.realpathSync(args[0]);
	const launcherRoot = fs.realpathSync(path.resolve(__dirname, '..'));
	if (root !== launcherRoot) throw new Error('launcher checkout mismatch');
	const packageJson = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
	const makefile = fs.readFileSync(path.join(root, 'Makefile'), 'utf8');
	if (packageJson.name !== 'cspeed' || !/^CSPEED_REPOSITORY_MAKEFILE := 1$/m.test(makefile)) {
		throw new Error('identity mismatch');
	}
} catch {
	console.error('Repository path does not identify a CSpeed checkout.');
	process.exit(2);
}

const token = crypto.randomBytes(32).toString('hex');
const contextDirectory = fs.mkdtempSync(path.join(os.tmpdir(), 'cspeed-launch-'));
const contextPath = path.join(contextDirectory, 'context.json');
fs.writeFileSync(contextPath, JSON.stringify({ root, token }), { mode: 0o600 });

const environment = { ...process.env };
for (const name of [
	'MAKEFLAGS',
	'MFLAGS',
	'MAKEFILES',
	'GNUMAKEFLAGS',
	'MAKEOVERRIDES',
	'MAKE_RESTARTS',
	'MAKELEVEL',
	'MAKEFILE_LIST',
	'ROOT',
	'NPM',
	'CSPEED_LAUNCH_CONTEXT',
	'CSPEED_LAUNCH_TOKEN'
]) {
	delete environment[name];
}
environment.CSPEED_LAUNCH_CONTEXT = contextPath;
environment.CSPEED_LAUNCH_TOKEN = token;

let result;
try {
	result = spawnSync('make', [
		'--no-builtin-rules',
		'--no-builtin-variables',
		'-C',
		root,
		'-f',
		'Makefile',
		'--',
		targets.get(args[1])
	], {
		env: environment,
		stdio: 'inherit',
		shell: false
	});
} finally {
	fs.rmSync(contextDirectory, { recursive: true, force: true });
}

if (result.error) {
	console.error(result.error.message);
	process.exit(127);
}
process.exit(result.status === null ? 1 : result.status);
