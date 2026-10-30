#!/usr/bin/env bash

# Bootstrap a fresh machine with these dotfiles.
#
#   curl -fsSL https://raw.githubusercontent.com/davidcollom/dotfiles/main/setup.sh | bash
#
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-/tmp/dotfiles}"
DOTFILES_URL="${DOTFILES_URL:-https://github.com/davidcollom/dotfiles.git}"

case "$(uname -s)" in
	Darwin)
		# Install homebrew
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

		# Sudo password first..
		sudo -v

		# install git
		brew install git || true
		;;
	Linux)
		# Homebrew is not needed on Linux, the basics are installed with the
		# package manager of the distribution instead.
		if command -v apt-get >/dev/null 2>&1; then
			sudo -v
			sudo apt-get update
			sudo apt-get install -y git curl zsh
		elif command -v dnf >/dev/null 2>&1; then
			sudo -v
			sudo dnf install -y git curl zsh
		elif command -v apk >/dev/null 2>&1; then
			sudo -v
			sudo apk add --no-cache git curl zsh
		else
			echo "No supported package manager found, install git, curl and zsh manually" >&2
		fi
		;;
	*)
		echo "Unsupported platform: $(uname -s)" >&2
		exit 1
		;;
esac

# clone dotfiles repo
if [[ ! -d "$DOTFILES_DIR" ]]; then
	git clone "$DOTFILES_URL" "$DOTFILES_DIR"
fi

# install packages
cd "$DOTFILES_DIR"

make install
