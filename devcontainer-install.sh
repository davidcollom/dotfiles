#!/usr/bin/env bash

# Bootstrap a Linux devcontainer (GitHub Codespaces) using the same Brewfile
# that provisions macOS. Mac-only entries are guarded inside the Brewfile.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

log() {
	printf '\n==> %s\n' "$1"
}

find_brew() {
	if command -v brew >/dev/null 2>&1; then
		return 0
	fi
	if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		return 0
	fi
	if [ -x "$HOME/.linuxbrew/bin/brew" ]; then
		eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
		return 0
	fi
	return 1
}

install_brew() {
	if find_brew; then
		log "Homebrew already available: $(command -v brew)"
		return
	fi

	log "Installing Homebrew"
	if [ "$(uname -s)" = "Linux" ]; then
		sudo apt-get update
		sudo apt-get install -y --no-install-recommends \
			build-essential curl file git procps ruby
	fi
	NONINTERACTIVE=1 /bin/bash -c \
		"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	find_brew || {
		echo "Homebrew installation completed but brew was not found on PATH" >&2
		exit 1
	}
}

install_brew

log "Installing packages from Brewfile"
brew bundle --file "$REPO_ROOT/Brewfile"

log "Installing Oh My Zsh"
RUNZSH=no CHSH=no sh -c \
	"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

log "Copying shell, git and SSH configuration"
cp -n .zshrc "$HOME/.zshrc"
for file in bash/.bash_*; do
	cp -n "$file" "$HOME/"
done
for file in git/.gitconfig* git/.gitignore; do
	cp -n "$file" "$HOME/"
done
mkdir -p "$HOME/.ssh"
cp -n ssh/config "$HOME/.ssh/config"

log "Done. Start a new shell to pick up the configuration."
