.PHONY: build deps lint up test

DOCKER_IMAGE=ghcr.io/lehigh-university-libraries/ojs:main

deps:
	docker compose pull

build: deps
	docker compose build

lint:
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


up:
	docker compose up init
	docker compose up -d

test: up
	./scripts/test.sh
