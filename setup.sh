#!/usr/bin/env bash

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install git
brew install git

# clone dotfiles repo
git clone https://github.com/davidcollom/dotfiles.git /tmp/dotfiles

# install packages
cd /tmp/dotfiles
brew bundle

# Setup gitconfig
cp /tmp/dotfiles/gitconfig ~/.gitconfig
cp /tmp/dotfiles/gitignore ~/.gitignore

# Setup Bash
for f in $(ls /tmp/dotfiles/bash*); do
  echo cp /tmp/dotfiles/${f} ~/.$(basename $f)
done
echo /usr/local/bin/bash >> /etc/shells
chsh -s /usr/local/bin/bash ${USER}

# Install code extensions
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension wholroyd.HCL
code --install-extension vscode-icons-team.vscode-icons
code --install-extension rebornix.ruby
code --install-extension erd0s.terraform-autocomplete
code --install-extension James-Yu.latex-workshop
code --install-extension lextudio.restructuredtext
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-python.python
code --install-extension golang.go
code --install-extension redhat.vscode-yaml
code --install-extension searKing.preview-vscode
code --install-extension technosophos.vscode-helm
code --install-extension ms-azuretools.vscode-docker
code --install-extension hashicorp.terraform
code --install-extension ms-vscode.sublime-keybindings
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension haaaad.ansible
code --install-extension vscoss.vscode-ansible

# Setup settings of VS Code
cp /tmp/dotfiles/settings.json ~/Library/Application\ Support/Code/User/settings.json
