# Dotfiles installation targets.
#
# Every target works on macOS and Linux. Targets that depend on a tool that is
# not installed (Homebrew, gcloud, kubectl, ...) skip themselves with a message
# instead of failing, so that `make install` also succeeds inside a GitHub
# Codespace or a devcontainer.

SHELL := /bin/bash

default: install

UNAME_S := $(shell uname -s)

# Tools that are optional, they depend on the platform and on what has been
# installed already.
HAVE_BREW := $(shell command -v brew 2>/dev/null)

# Location of the Oh My Zsh installation.
OH_MY_ZSH_DIR ?= $(HOME)/.oh-my-zsh

# Where VS Code keeps the user settings. This differs between macOS, a local
# VS Code and the VS Code server used by Codespaces.
VSCODE_USER_DIR ?= $(shell \
	if [ "$(UNAME_S)" = "Darwin" ]; then \
		echo "$(HOME)/Library/Application Support/Code/User"; \
	elif [ -d "$(HOME)/.vscode-server/data/Machine" ]; then \
		echo "$(HOME)/.vscode-server/data/Machine"; \
	else \
		echo "$(HOME)/.config/Code/User"; \
	fi)

.PHONY: install
## Install everything (mac, brew, zsh, bash, git, ssh, iterm2, krew, vscode, gcloud, python)
install: mac brew zsh bash git ssh iterm2 krew vscode gcloud python

.PHONY: devcontainer
## Install the dotfiles inside a devcontainer or GitHub Codespace
devcontainer: zsh bash git ssh vscode

.PHONY: setup
## Install/Setup the system/Clone repo out and
setup:
	./setup.sh

.PHONY: mac
## Apply the macOS system defaults (no-op on other platforms)
mac:
ifeq ($(UNAME_S),Darwin)
	./setup-mac.sh
else
	@echo "macOS specific setup skipped on $(UNAME_S)"
endif

.PHONY: brew
## Install the Homebrew bundle from the Brewfile
brew:
ifneq ($(HAVE_BREW),)
	brew bundle
else
	@echo "brew is not installed - skipping the Brewfile"
endif

.PHONY: zsh
## Install oh-my-zsh and the zsh configuration
zsh:
	@if ! command -v zsh >/dev/null 2>&1; then \
		echo "zsh is not installed - skipping the oh-my-zsh install" >&2; \
	elif [ ! -f "$(OH_MY_ZSH_DIR)/oh-my-zsh.sh" ]; then \
		echo "Installing oh-my-zsh"; \
		RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
	fi
	cp -v .zshrc "$(HOME)/.zshrc"

.PHONY: bash
## Copy the bash configuration into the home directory
bash:
	@shopt -s nullglob; \
	for file in bash/.bashrc bash/.bash_*; do \
		cp -nrv "$$file" "$(HOME)/"; \
	done

.PHONY: git
## Copy the git configuration into the home directory
git:
	cp -nrv git/.gitconfig git/.gitconfig-work git/.gitconfig-dod git/.gitconfig-extras git/.gitignore "$(HOME)/"

.PHONY: ssh
## Copy the ssh configuration into the home directory
ssh:
	mkdir -p "$(HOME)/.ssh"
	cp -nrv ssh/config "$(HOME)/.ssh/"

.PHONY: iterm2
## Open the iTerm2 colour scheme (macOS only)
iterm2:
ifeq ($(UNAME_S),Darwin)
	open iterm2/Solarized\ Dark.itermcolors
else
	@echo "iTerm2 is macOS only - skipping"
endif

.PHONY: kubectl
## Install kubectl via kbenv
kubectl:
ifneq ($(shell command -v kbenv 2>/dev/null),)
	kbenv install $$(kbenv list remote | head -n1)
	kbenv use $$(kbenv list local)
ifneq ($(HAVE_BREW),)
	kubectl completion bash > $(shell brew --prefix)/etc/bash_completion.d/kubectl
endif
else
	@echo "kbenv is not installed - skipping kubectl"
endif

.PHONY: terraform
## Install terraform via tfenv
terraform:
ifneq ($(shell command -v tfenv 2>/dev/null),)
	tfenv install
	tfenv use
	terraform -install-autocomplete
else
	@echo "tfenv is not installed - skipping terraform"
endif

.PHONY: krew
## Install kubectl and a set of krew plugins
krew: kubectl
ifneq ($(shell command -v kubectl 2>/dev/null),)
	kubectl krew install access-matrix
	# kubectl krew install advise-psp
	kubectl krew install cert-manager
	# kubectl krew install doctor
	kubectl krew install edit-status
	kubectl krew install evict-pod
	kubectl krew install get-all
	# kubectl krew install ingress-nginx
	kubectl krew install neat
	kubectl krew install np-viewer
	kubectl krew install outdated
	kubectl krew install prune-unused
	# kubectl krew install rbac-view
	# kubectl krew install service-tree
	kubectl krew install sniff
	kubectl krew install tree
	# kubectl krew install unused-volumes
	kubectl krew install view-cert
	kubectl krew install view-secret
	kubectl krew install view-utilization
	# kubectl krew install view-webhook
	kubectl krew install who-can
	kubectl krew install whoami
	kubectl krew index add davidcollom https://github.com/davidcollom/krew-index
	kubectl krew install davidcollom/watch
else
	@echo "kubectl is not installed - skipping krew"
endif

.PHONY: vscode
## Copy the VS Code settings and install the extensions
vscode:
	mkdir -p "$(VSCODE_USER_DIR)"
	-cp -nrv vscode/settings.json "$(VSCODE_USER_DIR)/settings.json"
ifneq ($(shell command -v code 2>/dev/null),)
	@while read -r extension; do \
		case "$$extension" in ''|\#*) continue ;; esac; \
		code --install-extension "$$extension" || true; \
	done < vscode/extensions.txt
else
	@echo "the 'code' CLI is not available - skipping the extension install"
endif

.PHONY: gcloud
## Configure the gcloud CLI
gcloud:
ifneq ($(shell command -v gcloud 2>/dev/null),)
	gcloud config set disable_usage_reporting false
	gcloud components install docker-credential-gcr
	gcloud components install gsutil
	gcloud components install gke-gcloud-auth-plugin
	gcloud components update
else
	@echo "gcloud is not installed - skipping"
endif

.PHONY: python
## Install the python requirements
python:
ifneq ($(shell command -v pip3 2>/dev/null),)
	pip3 install -r python/requirements.txt
else
	@echo "pip3 is not installed - skipping the python requirements"
endif




## This help screen
help:
	@printf "Available targets:\n\n"
	@awk '/^[a-zA-Z\-\_0-9%:\\]+/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
	gsub("\\\\", "", helpCommand); \
	gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"
