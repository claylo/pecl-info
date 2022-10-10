# Default target (by virtue of being the first non '.'-prefixed in the file).
.PHONY: _no-target-specified
_no-target-specified:
	$(error Please specify the target to make - `make list` shows targets.

# reminders of what make commands are set up
list:
	@echo useful targets:
	@echo
	@echo "  clean              clean up caches for rebuild"
	@echo "  pecl-cache			pull package and release data from PECL static API"
	@echo "  pecl-cache-extra	pull extra package data not included in PECL static API"
	@echo "  readme             generate a new GitHub README"
	@echo
.PHONY: list

clean:
	-rm -rf .etags/*
	-rm -rf rest/*
	-rm -rf data/packages/*
	-rm -f data/packages.json
.PHONY: clean

pecl-cache:
	bin/cache-all-package-info
	bin/expand-package-releases
.PHONY: pecl-cache

pecl-cache-extra:
	bin/cache-package-pages
	bin/expand-package-extra
.PHONY: pecl-cache-extra

readme:
	bin/generate-readme
.PHONY: readme
