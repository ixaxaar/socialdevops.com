### FORMAT
# ██████████████████████████████████████████████████████████████████████
format: format.isort format.code

format.isort: ## Sort imports
	@isort src/ test/

format.code: ## Format code
	@yapf -rip src/ test/

format.check: ## Check code formatting
	@isort --check-only src/ test/ && \
		yapf --diff -rp src/ test/
