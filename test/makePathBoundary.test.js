'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const test = require('node:test');

const sourceRepository = path.resolve(__dirname, '..');
const excludedFixtureDirectories = new Set(['.explore', '.git', 'coverage', 'node_modules']);

function copyRepository(target) {
	fs.cpSync(sourceRepository, target, {
		recursive: true,
		filter: entry => !excludedFixtureDirectories.has(path.basename(entry))
	});
}

function createTools(tempRoot) {
	const bin = path.join(tempRoot, 'bin');
	fs.mkdirSync(bin, { recursive: true });
	const log = path.join(tempRoot, 'npm.log');
	const npm = path.join(bin, 'npm');
	fs.writeFileSync(npm, `#!/usr/bin/env node
const fs = require('node:fs');
fs.appendFileSync(process.env.CSPEED_NPM_LOG, JSON.stringify(process.argv.slice(2)) + '\\n');
if (process.env.CSPEED_FAIL_GATE && process.argv.at(-1) === process.env.CSPEED_FAIL_GATE) process.exit(37);
`);
	fs.chmodSync(npm, 0o755);
	return { bin, log };
}

function readInvocations(log) {
	if (!fs.existsSync(log)) return [];
	return fs.readFileSync(log, 'utf8').trim().split('\n').filter(Boolean).map(JSON.parse);
}

function expectedInvocations(root) {
	root = fs.realpathSync(root);
	return [
		['--prefix', root, 'run', 'lint'],
		['--prefix', root, 'test'],
		['--prefix', root, 'run', 'check:generated'],
		['--prefix', root, 'audit', '--audit-level=moderate']
	];
}

function runLauncher(repository, args, cwd, tools, environment = {}) {
	return spawnSync(process.execPath, [path.join(repository, 'scripts', 'run-make.js'), ...args], {
		cwd,
		env: {
			...process.env,
			PATH: `${tools.bin}${path.delimiter}${process.env.PATH}`,
			CSPEED_NPM_LOG: tools.log,
			...environment
		},
		encoding: 'utf8'
	});
}

function runMake(repository, args, cwd, tools, environment = {}) {
	return spawnSync('make', args, {
		cwd,
		env: {
			...process.env,
			PATH: `${tools.bin}${path.delimiter}${process.env.PATH}`,
			CSPEED_NPM_LOG: tools.log,
			...environment
		},
		encoding: 'utf8'
	});
}

function withFixture(name, callback) {
	const tempRoot = fs.mkdtempSync(path.join(os.tmpdir(), `cspeed-v3-${name}-`));
	try {
		return callback(tempRoot);
	} finally {
		fs.rmSync(tempRoot, { recursive: true, force: true });
	}
}

test('fixture copies exclude installed dependencies', () => {
	const dependencies = path.join(sourceRepository, 'node_modules');
	const createdDependencies = !fs.existsSync(dependencies);
	const marker = path.join(dependencies, '.cspeed-fixture-copy-marker');
	fs.mkdirSync(dependencies, { recursive: true });
	fs.writeFileSync(marker, 'fixture copy probe');
	try {
		withFixture('dependency-filter', tempRoot => {
			const repository = path.join(tempRoot, 'repository');
			copyRepository(repository);
			assert.equal(fs.existsSync(path.join(repository, 'node_modules')), false);
		});
	} finally {
		fs.rmSync(marker, { force: true });
		if (createdDependencies) fs.rmdirSync(dependencies);
	}
});

test('launcher preserves an arbitrary canonical repository path as one exact npm prefix', () => {
	withFixture('hostile-path', tempRoot => {
		const marker = path.join(tempRoot, 'path-marker');
		const repository = path.join(tempRoot, ` repo$(shell touch ${marker})\n$ quote'"\\;># `);
		copyRepository(repository);
		const link = path.join(tempRoot, 'repository-link');
		fs.symlinkSync(repository, link, 'dir');
		const tools = createTools(tempRoot);
		const result = runLauncher(repository, [link, 'check'], tempRoot, tools);
		assert.equal(result.status, 0, `${result.stdout}\n${result.stderr}`);
		assert.equal(fs.existsSync(marker), false);
		assert.deepEqual(readInvocations(tools.log), expectedInvocations(fs.realpathSync(repository)));
	});
});

test('launcher exposes only the six documented targets with exact npm argv', () => {
	withFixture('targets', tempRoot => {
		const repository = path.join(tempRoot, 'repository');
		copyRepository(repository);
		const expected = new Map([
			['lint', expectedInvocations(repository).slice(0, 1)],
			['test', expectedInvocations(repository).slice(1, 2)],
			['build', expectedInvocations(repository).slice(2, 3)],
			['audit', expectedInvocations(repository).slice(3, 4)],
			['verify', expectedInvocations(repository)],
			['check', expectedInvocations(repository)]
		]);
		for (const [target, invocations] of expected) {
			const tools = createTools(path.join(tempRoot, target));
			const result = runLauncher(repository, [repository, target], tempRoot, tools);
			assert.equal(result.status, 0, `${target}: ${result.stdout}\n${result.stderr}`);
			assert.deepEqual(readInvocations(tools.log), invocations, target);
		}
	});
});

test('launcher rejects compact directory options, Make flags, assignments, and extra arguments before Make', () => {
	withFixture('arguments', tempRoot => {
		const selected = path.join(tempRoot, 'selected');
		const caller = path.join(tempRoot, 'caller');
		copyRepository(selected);
		copyRepository(caller);
		const cases = [
			['compact-C', [`-C${caller}`]],
			['extra-target', ['lint']]
		];
		for (const [mode, flags] of [
			['normal', []],
			['dry-run', ['-n']],
			['database', ['-pRrq']]
		]) {
			cases.push([
				`eval-${mode}`,
				[...flags, '--eval', `$(shell touch ${path.join(tempRoot, `eval-${mode}-marker`)})`]
			]);
			cases.push([
				`assignment-${mode}`,
				[...flags, `NPM=$(shell touch ${path.join(tempRoot, `assignment-${mode}-marker`)})`]
			]);
		}
		for (const [name, additions] of cases) {
			const caseRoot = path.join(tempRoot, name);
			fs.mkdirSync(caseRoot);
			const tools = createTools(caseRoot);
			const result = runLauncher(selected, [selected, 'check', ...additions], caller, tools);
			assert.equal(result.status, 2, `${name}: ${result.stdout}\n${result.stderr}`);
			assert.match(result.stderr, /^Usage:/, name);
			assert.deepEqual(readInvocations(tools.log), [], name);
		}
		for (const mode of ['normal', 'dry-run', 'database']) {
			assert.equal(fs.existsSync(path.join(tempRoot, `eval-${mode}-marker`)), false);
			assert.equal(fs.existsSync(path.join(tempRoot, `assignment-${mode}-marker`)), false);
		}
	});
});

test('launcher clears Make control environment in normal, dry-run, and database forms', () => {
	withFixture('environment', tempRoot => {
		const repository = path.join(tempRoot, 'repository');
		copyRepository(repository);
		for (const mode of ['normal', 'dry-run', 'database']) {
			for (const channel of ['MAKEFLAGS', 'MAKEFILES']) {
				const caseRoot = path.join(tempRoot, `${channel}-${mode}`);
				fs.mkdirSync(caseRoot);
				const tools = createTools(caseRoot);
				const marker = path.join(caseRoot, 'marker');
				const injected = path.join(caseRoot, 'injected.mk');
				fs.writeFileSync(injected, `$(shell touch ${marker})\n`);
				const modeFlags = mode === 'dry-run' ? '-n' : mode === 'database' ? '-pRrq' : '';
				const environment = channel === 'MAKEFLAGS'
					? { MAKEFLAGS: `${modeFlags} --eval $(shell touch ${marker})`.trim() }
					: { MAKEFLAGS: modeFlags, MAKEFILES: injected };
				const result = runLauncher(repository, [repository, 'check'], tempRoot, tools, environment);
				assert.equal(result.status, 0, `${channel}/${mode}: ${result.stdout}\n${result.stderr}`);
				assert.equal(fs.existsSync(marker), false, `${channel}/${mode}`);
				assert.deepEqual(readInvocations(tools.log), expectedInvocations(repository), `${channel}/${mode}`);
			}
		}
	});
});

test('selected repository identity wins over caller checkout, overrides, and neighboring markers', () => {
	withFixture('identity', tempRoot => {
		const selected = path.join(tempRoot, 'selected');
		const caller = path.join(tempRoot, 'caller');
		copyRepository(selected);
		copyRepository(caller);
		const tools = createTools(tempRoot);
		const result = runLauncher(selected, [selected, 'check'], caller, tools, {
			ROOT: caller,
			MAKEFILE_LIST: path.join(caller, 'Makefile'),
			NPM: `$(shell touch ${path.join(tempRoot, 'override-marker')})`
		});
		assert.equal(result.status, 0, `${result.stdout}\n${result.stderr}`);
		assert.equal(fs.existsSync(path.join(tempRoot, 'override-marker')), false);
		assert.deepEqual(readInvocations(tools.log), expectedInvocations(selected));
	});
});

test('private Make targets fail closed without a launcher context while trusted make check remains compatible', () => {
	withFixture('internal', tempRoot => {
		const repository = path.join(tempRoot, 'repository');
		copyRepository(repository);
		let tools = createTools(path.join(tempRoot, 'private'));
		let result = runMake(repository, ['-C', repository, '__cspeed_check'], tempRoot, tools);
		assert.notEqual(result.status, 0);
		assert.deepEqual(readInvocations(tools.log), []);

		tools = createTools(path.join(tempRoot, 'trusted'));
		result = runMake(repository, ['-C', repository, 'check'], tempRoot, tools);
		assert.equal(result.status, 0, `${result.stdout}\n${result.stderr}`);
		assert.deepEqual(readInvocations(tools.log), expectedInvocations(repository));
	});
});

test('trusted Makefile invocation remains rooted outside the checkout', () => {
	withFixture('external-makefile', tempRoot => {
		const repository = path.join(tempRoot, 'repository');
		const caller = path.join(tempRoot, 'caller');
		copyRepository(repository);
		fs.mkdirSync(caller);
		const tools = createTools(tempRoot);
		const result = runMake(repository, ['-f', path.join(repository, 'Makefile'), 'check'], caller, tools);
		assert.equal(result.status, 0, `${result.stdout}\n${result.stderr}`);
		assert.deepEqual(readInvocations(tools.log), expectedInvocations(repository));
	});
});

test('launcher rejects invalid repository identity and propagates npm failure without later gates', () => {
	withFixture('closure', tempRoot => {
		const repository = path.join(tempRoot, 'repository');
		copyRepository(repository);
		const invalid = path.join(tempRoot, 'invalid');
		fs.mkdirSync(invalid);
		let tools = createTools(path.join(tempRoot, 'invalid-tools'));
		let result = runLauncher(repository, [invalid, 'check'], tempRoot, tools);
		assert.equal(result.status, 2);
		assert.deepEqual(readInvocations(tools.log), []);

		tools = createTools(path.join(tempRoot, 'failure-tools'));
		result = runLauncher(repository, [repository, 'check'], tempRoot, tools, {
			CSPEED_FAIL_GATE: 'test'
		});
		assert.equal(result.status, 2);
		assert.deepEqual(readInvocations(tools.log), expectedInvocations(repository).slice(0, 2));
	});
});

test('trusted launcher rejects a forged checkout before Make execution', () => {
	withFixture('forged-checkout', tempRoot => {
		const trustedRepository = path.join(tempRoot, 'trusted');
		const forgedRepository = path.join(tempRoot, 'forged');
		const marker = path.join(tempRoot, 'forged-marker');
		copyRepository(trustedRepository);
		fs.mkdirSync(forgedRepository);
		fs.writeFileSync(path.join(forgedRepository, 'package.json'), JSON.stringify({ name: 'cspeed' }));
		fs.writeFileSync(path.join(forgedRepository, 'Makefile'), `CSPEED_REPOSITORY_MAKEFILE := 1
__cspeed_check:
	@touch ${marker}
`);
		const tools = createTools(tempRoot);
		const result = runLauncher(trustedRepository, [forgedRepository, 'check'], tempRoot, tools);
		assert.equal(result.status, 2, `${result.stdout}\n${result.stderr}`);
		assert.equal(fs.existsSync(marker), false);
		assert.deepEqual(readInvocations(tools.log), []);
	});
});
