PACKAGES := hypr tmux foot readline
TARGET ?= $(HOME)

.PHONY: rice
rice:
	./scripts/install-stow.sh
	./scripts/backup-conflicts.sh "$(TARGET)" $(PACKAGES)
	stow --restow --no-folding --target="$(TARGET)" $(PACKAGES)
	./scripts/reload.sh
