#!/usr/bin/env bash
#
# Install these dotfiles inside a devcontainer or a GitHub Codespace.
#
# The script is idempotent: it can be re-run at any time and only installs
# what is missing. It is called by `.devcontainer/devcontainer.json` through
# the `postCreateCommand` hook, and it can also be run by hand:
#
#   ./devcontainer-install.sh
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

ZSH_DIR="${ZSH_DIR:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM_DIR:-$ZSH_DIR/custom}"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m %s\n' "$*" >&2; }

# Run a command with root privileges, when they are needed and available.
as_root() {
	if [ "$(id -u)" -eq 0 ]; then
		"$@"
	elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
		sudo "$@"
	else
		warn "root privileges are required for: $*"
		return 1
	fi
}

# ---------------------------------------------------------------------------
# 1. zsh
# ---------------------------------------------------------------------------
install_zsh() {
	if command -v zsh >/dev/null 2>&1; then
		return 0
	fi

	log "zsh is not installed - installing it"
	if command -v apt-get >/dev/null 2>&1; then
		as_root env DEBIAN_FRONTEND=noninteractive apt-get update
		as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y zsh
	elif command -v dnf >/dev/null 2>&1; then
		as_root dnf install -y zsh
	elif command -v yum >/dev/null 2>&1; then
		as_root yum install -y zsh
	elif command -v apk >/dev/null 2>&1; then
		as_root apk add --no-cache zsh
	else
		warn "no supported package manager found - install zsh manually"
		return 1
	fi
}

# ---------------------------------------------------------------------------
# 2. oh-my-zsh
# ---------------------------------------------------------------------------
install_oh_my_zsh() {
	if [ -f "$ZSH_DIR/oh-my-zsh.sh" ]; then
		return 0
	fi

	log "Installing oh-my-zsh"
	# CHSH=no / RUNZSH=no keep the installer non-interactive, KEEP_ZSHRC=yes
	# stops it from replacing an existing ~/.zshrc (we install our own below).
	RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
		"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# ---------------------------------------------------------------------------
# 3. oh-my-zsh plugins
#
# Most of the plugins used by .zshrc ship with oh-my-zsh. The two below are
# vendored by oh-my-zsh as well, but they are cloned from their upstream
# repositories when they are missing, so that the shell works on a machine
# with an older oh-my-zsh installation.
# ---------------------------------------------------------------------------
install_plugin() {
	local name="$1" url="$2"

	if [ -d "$ZSH_DIR/plugins/$name" ] || [ -d "$ZSH_CUSTOM_DIR/plugins/$name" ]; then
		return 0
	fi

	log "Installing the $name plugin"
	mkdir -p "$ZSH_CUSTOM_DIR/plugins"
	git clone --depth 1 "$url" "$ZSH_CUSTOM_DIR/plugins/$name"
}

# ---------------------------------------------------------------------------
# 4. dotfiles
# ---------------------------------------------------------------------------
install_dotfiles() {
	log "Installing the dotfiles from $DOTFILES_DIR"
	make -C "$DOTFILES_DIR" devcontainer
}

# ---------------------------------------------------------------------------
# 5. default shell
# ---------------------------------------------------------------------------
set_default_shell() {
	local zsh_path
	zsh_path="$(command -v zsh 2>/dev/null || true)"
	if [ -z "$zsh_path" ]; then
		return 0
	fi

	if [ "$(basename "${SHELL:-}")" = "zsh" ]; then
		return 0
	fi

	log "Setting zsh as the default shell"
	as_root chsh -s "$zsh_path" "$(id -un)" || \
		warn "could not change the default shell - run 'chsh' manually"
}

install_zsh || warn "zsh could not be installed - the zsh configuration will not work"
install_oh_my_zsh || warn "oh-my-zsh could not be installed"
install_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting ||
	warn "the zsh-syntax-highlighting plugin could not be installed"
install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions ||
	warn "the zsh-autosuggestions plugin could not be installed"
install_dotfiles
set_default_shell

log "Done - open a new terminal to start using zsh"
