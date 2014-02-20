BIN = ./node_modules/.bin
REPO = $(shell cat .git/config | grep url | xargs echo | sed -E 's/^url = //g')
REPONAME = $(shell echo $(REPO) | sed -E 's_.+:([a-zA-Z0-9_\-]+)/([a-zA-Z0-9_\-]+)\.git_\1/\2_')

install link:
	@npm $@

lint:
	@$(BIN)/jshint --verbose *.js

test::
	@$(BIN)/mocha -R spec specs/*.js

example::
	@$(BIN)/node-dev --no-deps example/server.js

release-patch: test lint
	@$(call release,patch)

release-minor: test lint
	@$(call release,minor)

release-major: test lint
	@$(call release,major)

publish:
	git push --tags origin HEAD:master
	npm publish

define release
	npm version $(1)
endef
