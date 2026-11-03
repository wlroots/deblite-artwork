VERSION ?= $(shell tr -d '[:space:]' <VERSION)
ARCHIVE := out/deblite-artwork-$(VERSION).tar.gz

.PHONY: all dist check clean

all: dist

dist: $(ARCHIVE)

$(ARCHIVE):
	./scripts/build-artwork-archive.sh --version "$(VERSION)" --output "$(ARCHIVE)"

check:
	shellcheck scripts/*.sh

clean:
	rm -rf out
