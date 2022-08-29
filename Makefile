IMAGE_NAME := hoge
IMAGE_WORKDIR := /app

.PHONY: image
image: .cache/dev
.cache/dev: composer.json composer.lock Dockerfile .dockerignore
	@mkdir -p .cache
	@docker build -t ${IMAGE_NAME} .
	@touch ${@}

.PHONY: composer-run-%
composer-run-%: image
	@docker run --rm --tty \
		-v $(PWD)/src:$(IMAGE_WORKDIR)/src \
		-v $(PWD)/tests:$(IMAGE_WORKDIR)/tests \
		-v $(PWD)/composer.json:$(IMAGE_WORKDIR)/composer.json \
		-v $(PWD)/composer.lock:$(IMAGE_WORKDIR)/composer.lock \
		-v $(PWD)/phpcs.xml:$(IMAGE_WORKDIR)/phpcs.xml \
		${IMAGE_NAME} \
		composer run ${@:composer-run-%=%}

.PHONY: lint
lint:
	@-$(MAKE) composer-run-lint

.PHONY: format
format:
	@-$(MAKE) composer-run-format

.PHONY: bash
bash: image
	@docker run --rm -i --tty \
		-v $(PWD)/src:$(IMAGE_WORKDIR)/src \
		-v $(PWD)/tests:$(IMAGE_WORKDIR)/tests \
		-v $(PWD)/composer.json:$(IMAGE_WORKDIR)/composer.json \
		-v $(PWD)/composer.lock:$(IMAGE_WORKDIR)/composer.lock \
		-v $(PWD)/phpcs.xml:$(IMAGE_WORKDIR)/phpcs.xml \
		${IMAGE_NAME} \
		bash

.PHONY: clean
clean:
	@-rm -r .cache
