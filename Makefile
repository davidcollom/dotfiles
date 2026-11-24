default: install

UNAME_S := $(shell uname -s)

# GUI/desktop targets are only meaningful on macOS. Codespaces uses the
# devcontainer feature list instead.
ifeq ($(UNAME_S),Darwin)
DESKTOP_TARGETS := mac iterm2 vscode gcloud
endif

install: brew zsh bash git ssh krew python $(DESKTOP_TARGETS)

## Install/Setup the system/Clone repo out and
.PHONY: setup
## Install/Setup the system/Clone repo out and
setup:
	./setup.sh

.PHONY: mac
## Apply macOS system defaults
mac:
	./setup-mac.sh

.PHONY: brew
## Install the Homebrew bundle from the Brewfile
brew:
	brew bundle

.PHONY: zsh
## Install Oh My Zsh and the zsh configuration
zsh:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	cp .zshrc ${HOME}/.zshrc

.PHONY: bash
## Copy the bash configuration into the home directory
bash:
	cp -nrv bash/. ${HOME}/

.PHONY: git
## Copy the git configuration into the home directory
git:
	cp -nrv git/. ${HOME}/

.PHONY: ssh
## Copy the SSH configuration into the home directory
ssh:
	mkdir -p ${HOME}/.ssh
	cp -nrv ssh/. ${HOME}/.ssh/

.PHONY: iterm2
## Open the iTerm2 colour scheme (macOS only)
iterm2:
ifeq ($(UNAME_S),Darwin)
	open iterm2/Solarized\ Dark.itermcolors
else
	@echo "iTerm2 is macOS-only; skipping"
endif

.PHONY: kubectl
## Install kubectl bash completion
kubectl:
	mkdir -p "$$(brew --prefix)/etc/bash_completion.d"
	kubectl completion bash > "$$(brew --prefix)/etc/bash_completion.d/kubectl"

.PHONY: terraform
## Install and select Terraform via tfenv
terraform:
	tfenv install
	tfenv use
	terraform -install-autocomplete

.PHONY: krew
## Install kubectl and a set of krew plugins
krew: kubectl
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

.PHONY: vscode
## Copy VS Code settings and install extensions (macOS only)
vscode:
ifeq ($(UNAME_S),Darwin)
	mkdir -p "${HOME}/Library/Application Support/Code/User"
	-cp -nrv vscode/settings.json "${HOME}/Library/Application Support/Code/User/settings.json"
	@while read -r extension; do \
		case "$$extension" in ''|\#*) continue ;; esac; \
		code --install-extension "$$extension" || true; \
	done < vscode/extensions.txt
else
	@echo "VS Code desktop setup is macOS-only; configure extensions in devcontainer.json"
endif

.PHONY: gcloud
## Configure the gcloud CLI (macOS only)
gcloud:
ifeq ($(UNAME_S),Darwin)
	gcloud config set disable_usage_reporting false
	gcloud components install docker-credential-gcr
	gcloud components install gsutil
	gcloud components install gke-gcloud-auth-plugin
	gcloud components update
else
	@echo "gcloud component setup is macOS-only; use the CLI from Brewfile"
endif

.PHONY: python
## Install the Python requirements
python:
	pip3 install -r python/requirements.txt

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
