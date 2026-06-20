.PHONY: lint test build audit verify check

override ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
NPM ?= npm

lint:
	$(NPM) --prefix $(ROOT) run lint

test:
	$(NPM) --prefix $(ROOT) test

build:
	$(NPM) --prefix $(ROOT) run check:generated

audit:
	$(NPM) --prefix $(ROOT) audit --audit-level=moderate

verify: lint test build audit

check: verify
