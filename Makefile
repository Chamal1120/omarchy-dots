PACKAGES := hypr tmux foot readline bash nvim local-scripts claude
TARGET ?= $(HOME)

.PHONY: rice
rice:
	./scripts/install-stow.sh
	./scripts/remove-conflicts.sh "$(TARGET)" $(PACKAGES)
	stow --restow --no-folding --target="$(TARGET)" $(PACKAGES)
	./scripts/reload.sh
	omarchy-theme-install https://github.com/chrisviegas/omarchy-vague-theme
