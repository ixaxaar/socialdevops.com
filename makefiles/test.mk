### TEST
# ██████████████████████████████████████████████████████████████████████
# include .envrc

COVERAGE_MIN = 70

.PHONY: test
test: ## Launch tests
	@py.test --disable-pytest-warnings test/

.PHONY: coverage
test.coverage: ## Generate test coverage
	@py.test --disable-pytest-warnings --cov-report term --cov-report html:coverage --cov-config setup.cfg --cov=src/ test/

test.lint: ## Lint python files with flake8
	@flake8 ./src ./test
