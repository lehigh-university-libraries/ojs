.PHONY: help init up down logs status healthcheck clean lint test deps pull

SHELL := /bin/bash

help: ## Show this help message
	echo 'Usage: make [target]'
	echo ''
	echo 'Available targets:'
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_% -]+:.*?## / {printf "  %s\t%s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort | column -t -s $$'\t'

deps pull: ## Pull image dependencies
	docker compose pull

init: ## Generate or repair local secrets
	docker compose run --rm init
	docker compose run --rm --entrypoint /usr/local/bin/validate-ojs-secret-key.sh init

up: init ## Start the complete site and wait for health
	docker compose up --remove-orphans --wait --wait-timeout 1200

clean: ## Delete disposable containers and volumes (requires confirmation)
	@read -r -p 'Delete all Compose volumes? Type DELETE: ' answer; test "$$answer" = DELETE
	docker compose down --remove-orphans --volumes

lint: ## Lint template files
	@docker compose config --format json | jq -e '[.services[] | has("build")] | any | not'
	@docker compose config --format json | jq -e '.services.ojs.image | split("@")[0] == "ghcr.io/lehigh-university-libraries/ojs:php83"'
	@if command -v json5 > /dev/null 2>&1; then \
		echo "Running json5 validation on renovate.json5"; \
		json5 --validate renovate.json5 > /dev/null; \
	else \
		echo "json5 not found, skipping renovate validation"; \
	fi

test: up ## Boot the stack and verify OJS is serving
	./scripts/test.sh

down: ## Stop the stack, preserving data
	docker compose down

logs: ## Follow service logs
	docker compose logs --tail 100 -f

logs-%: ## Follow one service
	docker compose logs --tail 100 -f $*

status healthcheck: ## Show container health
	docker compose ps
