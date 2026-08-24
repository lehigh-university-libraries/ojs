.PHONY: help init up clean lint test build deps

SHELL := /bin/bash

DOCKER_IMAGE=ghcr.io/lehigh-university-libraries/ojs:main

help: ## Show this help message
	echo 'Usage: make [target]'
	echo ''
	echo 'Available targets:'
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %s\t%s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort | column -t -s $$'\t'

deps: ## Pull image dependencies
	docker compose pull

build: deps ## Build the ojs image
	docker compose build

init: ## Generate or repair local secrets
	docker compose run --rm init
	docker compose run --rm --entrypoint /usr/local/bin/validate-ojs-secret-key.sh init

up: init ## Start the complete site and wait for health
	docker compose up --remove-orphans --wait --wait-timeout 1200

clean: ## Tear down containers and volumes
	docker compose down --remove-orphans --volumes

lint: ## Lint template files
	@docker compose config --format json| jq -e .services.ojs.image | grep lehigh
	@if command -v hadolint > /dev/null 2>&1; then \
		echo "Running hadolint on Dockerfiles..."; \
		find . -name "Dockerfile" | xargs hadolint; \
	else \
		echo "hadolint not found, skipping Dockerfile validation"; \
	fi
	@if command -v json5 > /dev/null 2>&1; then \
		echo "Running json5 validation on renovate.json5"; \
		json5 --validate renovate.json5 > /dev/null; \
	else \
		echo "json5 not found, skipping renovate validation"; \
	fi

test: up ## Boot the stack and verify OJS is serving
	./scripts/test.sh
