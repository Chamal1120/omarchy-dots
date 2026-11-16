PACKAGES := hypr tmux foot readline bash nvim local-scripts claude systemd omarchy cliamp
TARGET ?= $(HOME)

.PHONY: rice
rice:
	./scripts/install-stow.sh
	./scripts/remove-conflicts.sh "$(TARGET)" $(PACKAGES)
	stow --no-folding --target="$(TARGET)" $(PACKAGES)
	./scripts/reload.sh
	./scripts/install-theme.sh https://github.com/chrisviegas/omarchy-vague-theme vague themes/vague/shell.toml
