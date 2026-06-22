SHELL := /bin/sh

CSPEED_REPOSITORY_MAKEFILE := 1

.PHONY: lint test build audit verify check
.PHONY: __cspeed_lint __cspeed_test __cspeed_build __cspeed_audit __cspeed_verify __cspeed_check

ifneq ($(filter __cspeed_%,$(MAKECMDGOALS)),)
ifneq ($(origin CSPEED_LAUNCH_CONTEXT),environment)
$(error Private CSpeed targets require the validated Node launcher)
endif
ifneq ($(origin CSPEED_LAUNCH_TOKEN),environment)
$(error Private CSpeed targets require the validated Node launcher)
endif
override CSPEED_LAUNCH_CONTEXT := $(value CSPEED_LAUNCH_CONTEXT)
override CSPEED_LAUNCH_TOKEN := $(value CSPEED_LAUNCH_TOKEN)
export CSPEED_LAUNCH_CONTEXT
export CSPEED_LAUNCH_TOKEN
endif

lint:
	@node scripts/run-make.js . lint

test:
	@node scripts/run-make.js . test

build:
	@node scripts/run-make.js . build

audit:
	@node scripts/run-make.js . audit

verify:
	@node scripts/run-make.js . verify

check:
	@node scripts/run-make.js . check

__cspeed_lint:
	@node scripts/run-npm-gate.js run lint

__cspeed_test:
	@node scripts/run-npm-gate.js test

__cspeed_build:
	@node scripts/run-npm-gate.js run check:generated

__cspeed_audit:
	@node scripts/run-npm-gate.js audit --audit-level=moderate

__cspeed_verify: __cspeed_lint __cspeed_test __cspeed_build __cspeed_audit

__cspeed_check: __cspeed_verify
