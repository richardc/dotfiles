.PHONY: help get set

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

get: ## records current set of installed packages to packages.list so you can commit it
	apm list --packages --bare --installed > packages.list

set: ## installs all packages from the packages.list
	apm install --packages-file packages.list
