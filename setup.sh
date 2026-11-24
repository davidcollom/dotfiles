#!/usr/bin/env bash

# Sudo password first..
sudo -v

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install git
brew install git || true

# clone dotfiles repo
[[ ! -d /tmp/dotfiles ]] && git clone https://github.com/davidcollom/dotfiles.git /tmp/dotfiles

# install packages
cd /tmp/dotfiles || echo "Failed to clone repo to /tmp/dotfiles" && exit 1

make install
