SHELL := /usr/bin/env sh
TESTS := $(wildcard tests/*.sh)

INSTALL ?= install
PREFIX ?= /usr/local
BASH_COMP_DIR := $(shell pkg-config --variable=completionsdir bash-completion 2>/dev/null)
ifeq ($(BASH_COMP_DIR),)
    BASH_COMP_DIR = /usr/share/bash-completion/completions
endif
ZSH_COMP_DIR ?= $(PREFIX)/share/zsh/site-functions
MANDIR ?= $(PREFIX)/share/man
MAN1DIR = $(MANDIR)/man1

.PHONY: all clean info install install-inline-checksum install-inline-checksum-docs test uninstall

default: all

all: info

clean:
ifneq ($(wildcard tests/*.log),)
	@printf "Cleaning up test logs.\n"
	@$(RM) tests/*.log
else
	@printf "No test logs to clean.\n"
endif
ifneq ($(wildcard docs/*.1),)
	@printf "Cleaning up man pages.\n"
	@$(RM) docs/*.1
else
	@printf "No man pages to clean.\n"
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

info:
	@help2man ./inline-checksum -o docs/inline-checksum.1

install: install-inline-checksum install-inline-checksum-info

install-inline-checksum:
	@printf "Installing inline-checksum to %s/bin...\n" $(DESTDIR)$(PREFIX)
	@$(INSTALL) -Dm 755 inline-checksum $(DESTDIR)$(PREFIX)/bin/inline-checksum

install-inline-checksum-info: info
	@printf "Installing inline-checksum bash completion to %s...\n" $(DESTDIR)$(BASH_COMP_DIR)
	@$(INSTALL) -Dm 644 docs/inline-checksum-completion $(DESTDIR)$(BASH_COMP_DIR)/inline-checksum
	@printf "Installing inline-checksum zsh completion to %s...\n" $(DESTDIR)$(ZSH_COMP_DIR)
	@$(INSTALL) -Dm 644 docs/inline-checksum-completion $(DESTDIR)$(ZSH_COMP_DIR)/_inline-checksum
	@printf "Installing inline-checksum man page to %s...\n" $(DESTDIR)$(MAN1DIR)
	@$(INSTALL) -Dm 644 docs/inline-checksum.1 $(DESTDIR)$(MAN1DIR)/inline-checksum.1
	@gzip $(DESTDIR)$(MAN1DIR)/inline-checksum.1
	-@mandb > /dev/null 2>&1

uninstall:
	@printf "Uninstalling inline-checksum from %s/bin...\n" $(DESTDIR)$(PREFIX)
	@printf "Uninstalling inline-checksum documentation from %s...\n" $(DESTDIR)$(PREFIX)
	@$(RM) $(DESTDIR)$(PREFIX)/bin/inline-checksum
	@$(RM) $(DESTDIR)$(BASH_COMP_DIR)/inline-checksum
	@$(RM) $(DESTDIR)$(ZSH_COMP_DIR)/_inline-checksum
	@$(RM) $(DESTDIR)$(MAN1DIR)/inline-checksum.1.gz
	-@mandb > /dev/null 2>&1
