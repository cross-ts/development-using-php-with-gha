.PHONY: image
image: .cache/dev
.cache/dev: composer.json composer.lock Dockerfile
	@mkdir -p .cache
	@docker build -t hoge .
	@touch ${@}


.PHONY: clean
clean:
	@-rm -r .cache
