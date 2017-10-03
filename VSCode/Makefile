.PHONY: help get set

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

link: ## symlinks the user settings into place
	ln -s settings.json "${HOME}/Library/Application Support/Code/User"

get: ## records current set of installed extensions to extensions.list so you can commit it
	code --list-extensions > extensions.list

set: ## installs all extensions from the extensions.list
	for extension in $$(cat extensions.list) ; do code --install-extension $$extension ; done
