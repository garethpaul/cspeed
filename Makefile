.PHONY: lint test audit verify check

NPM ?= npm

lint:
	$(NPM) run lint

test:
	$(NPM) test

audit:
	$(NPM) audit --audit-level=high

verify:
	$(NPM) run verify

check: verify
