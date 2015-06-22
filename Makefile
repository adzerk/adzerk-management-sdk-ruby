.PHONY: help build install push

GEMNAME=adzerk
VERSION=$(shell cat lib/adzerk/version.rb |grep VERSION |sed 's/^.*"\([^"][^"]*\)".*/\1/')
GEMFILE=$(GEMNAME)-$(VERSION).gem
GEMSPEC=$(GEMNAME).gemspec

help:
	@echo "Usage: make {build|install|push|help}" 2>&1

build: $(GEMFILE)

install: $(GEMFILE)
	sudo gem install $(GEMFILE)

push: $(GEMFILE)
	gem push $(GEMFILE)

$(GEMFILE): $(shell find lib -type f) $(GEMSPEC)
	gem build $(GEMSPEC)

