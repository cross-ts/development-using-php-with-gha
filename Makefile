#
# Constants
#
IMAGE_NAME := $(shell basename $(PWD))
IMAGE_WORKDIR := /app
CACHE_DIR := .cache
IMAGE_TAG = $(PHP_VERSION)-$(COMPOSER_VERSION)

#
# Variables
#
PHP_VERSION := 8.1
COMPOSER_VERSION := latest

.PHONY: image
image: $(CACHE_DIR)/$(IMAGE_TAG)
$(CACHE_DIR)/$(IMAGE_TAG): composer.json composer.lock Dockerfile .dockerignore
	@mkdir -p $(CACHE_DIR)
	@docker build \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg COMPOSER_VERSION=$(COMPOSER_VERSION) \
		.
	@touch ${@}

.PHONY: composer-run-%
composer-run-%: image
	@docker run --rm --tty \
		-v $(PWD)/src:$(IMAGE_WORKDIR)/src \
		-v $(PWD)/tests:$(IMAGE_WORKDIR)/tests \
		-v $(PWD)/composer.json:$(IMAGE_WORKDIR)/composer.json \
		-v $(PWD)/composer.lock:$(IMAGE_WORKDIR)/composer.lock \
		-v $(PWD)/phpcs.xml:$(IMAGE_WORKDIR)/phpcs.xml \
		-v $(PWD)/phpunit.xml:$(IMAGE_WORKDIR)/phpunit.xml \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		composer run ${@:composer-run-%=%}

.PHONY: lint
lint:
	@-$(MAKE) composer-run-lint

.PHONY: format
format:
	@-$(MAKE) composer-run-format

.PHONY: test
test:
	@-$(MAKE) composer-run-test

.PHONY: composer-update
composer-update: image
	@docker run --rm --tty \
		-v $(PWD)/composer.json:$(IMAGE_WORKDIR)/composer.json \
		-v $(PWD)/composer.lock:$(IMAGE_WORKDIR)/composer.lock \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		composer update

.PHONY: bash
bash: image
	@docker run --rm -i --tty \
		-v $(PWD)/src:$(IMAGE_WORKDIR)/src \
		-v $(PWD)/tests:$(IMAGE_WORKDIR)/tests \
		-v $(PWD)/composer.json:$(IMAGE_WORKDIR)/composer.json \
		-v $(PWD)/composer.lock:$(IMAGE_WORKDIR)/composer.lock \
		-v $(PWD)/phpcs.xml:$(IMAGE_WORKDIR)/phpcs.xml \
		-v $(PWD)/phpunit.xml:$(IMAGE_WORKDIR)/phpunit.xml \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		bash

.PHONY: clean
clean:
	@-rm -r $(CACHE_DIR)
