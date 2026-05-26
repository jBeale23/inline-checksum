SHELL := /usr/bin/env sh
TESTS := $(wildcard tests/*.sh)

.PHONY: clean test

clean:
ifneq ($(wildcard tests/*.log),)
	$(RM) tests/*.log
else
	@printf "Nothing to clean.\n"
endif

test:
	@FAILURE=0; \
	for test in $(TESTS); do \
	printf "[%s] Test %s: " "$$(date +'%H:%M:%S')" "$$test"; \
		if $$test; then \
			printf "SUCCESS"; \
		else \
			printf "FAILURE"; \
			FAILURE=1; \
		fi; \
		printf "\n"; \
	done; \
	[ "$$FAILURE" -eq 0 ] || exit 1
