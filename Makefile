SHELL := /usr/bin/env sh
TESTS := $(wildcard tests/*.sh)

PREFIX ?= /usr/local
BASH_COMP_DIR := $(shell pkg-config --variable=completionsdir bash-completion 2>/dev/null)
ifeq ($(BASH_COMP_DIR),)
    BASH_COMP_DIR = /usr/share/bash-completion/completions
endif
ZSH_COMP_DIR ?= $(PREFIX)/share/zsh/site-functions

.PHONY: clean install test uninstall

clean:
ifneq ($(wildcard tests/*.log),)
	@printf "Cleaning up test logs.\n"
	@$(RM) tests/*.log
else
	@printf "Nothing to clean.\n"
endif

test:
	@FAILURE=0; \
	for test in $(TESTS); do \
	printf "[%s] Test %s: " "$$(date +'%H:%M:%S')" "$$test"; \
		if $$test; then \
			printf "\033[32mSUCCESS\033[0m"; \
		else \
			printf "\033[31mFAILURE\033[0m"; \
			FAILURE=1; \
		fi; \
		printf "\n"; \
	done; \
	[ "$$FAILURE" -eq 0 ] || exit 1

install:
	@printf "Installing inline-checksum to %s/bin...\n" $(DESTDIR)$(PREFIX)
	@install -Dm 755 inline-checksum $(DESTDIR)$(PREFIX)/bin/inline-checksum
	@install -Dm 644 inline-checksum-completion $(DESTDIR)$(BASH_COMP_DIR)/inline-checksum
	@install -Dm 644 inline-checksum-completion $(DESTDIR)$(ZSH_COMP_DIR)/_inline-checksum

uninstall:
	@printf "Uninstalling inline-checksum from %s/bin...\n" $(DESTDIR)$(PREFIX)
	@$(RM) $(DESTDIR)$(PREFIX)/bin/inline-checksum
	@$(RM) $(DESTDIR)$(BASH_COMP_DIR)/inline-checksum
	@$(RM) $(DESTDIR)$(ZSH_COMP_DIR)/_inline-checksum
