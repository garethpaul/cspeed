SHELL := /bin/sh

CSPEED_REPOSITORY_MAKEFILE := 1
override ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

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
	@node "$(ROOT)scripts/run-make.js" "$(ROOT)" lint

test:
	@node "$(ROOT)scripts/run-make.js" "$(ROOT)" test

build:
	@node "$(ROOT)scripts/run-make.js" "$(ROOT)" build

audit:
	@node "$(ROOT)scripts/run-make.js" "$(ROOT)" audit

verify:
	@node "$(ROOT)scripts/run-make.js" "$(ROOT)" verify

check:
	@node "$(ROOT)scripts/run-make.js" "$(ROOT)" check

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
