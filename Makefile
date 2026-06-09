.PHONY: lint test build audit verify check

NPM ?= npm

lint:
	$(NPM) run lint

test:
	$(NPM) test

build:
	$(NPM) run compile

audit:
	$(NPM) audit --audit-level=high

verify: lint test build audit

check: verify
