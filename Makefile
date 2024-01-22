default: install

install: mac brew bash git ssh iterm2 krew vscode gcloud python


UNAME_S := $(shell uname -s)

## Install/Setup the system/Clone repo out and
.PHONY: setup
setup:
	./setup.sh

.PHONY: mac
mac:
ifeq ($(UNAME_S),Darwin)
	./setup-mac.sh
endif

.PHONY: brew
brew:
	brew bundle

.PHONY: bash
bash:
	cp -nrv bash/ ${HOME}
	echo $(shell brew --prefix)/bin/bash | sudo tee -a /etc/shells
	sudo chsh -s $(shell brew --prefix)/bin/bash "${USER}"

.PHONY: git
git:
	cp -nrv git/ ${HOME}

.PHONY: ssh
ssh:
	mkdir -p ${HOME}/.ssh
	cp -nrv ssh/ ${HOME}/.ssh/

.PHONY: iterm2
iterm2:
	open iterm2/Solarized\ Dark.itermcolors

kubectl:
	kbenv install $(shell kbenv list remote| head -n1)
	kbenv use $(shell kbenv list local)

terraform:
	tfenv install
	tfenv use
	terraform -install-autocomplete


.PHONY: krew
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
vscode:
	mkdir -p "${HOME}/Library/Application Support/Code/User"
	-cp -nrv vscode/settings.json "${HOME}/Library/Application Support/Code/User/settings.json"
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
	code --install-extension adamhartford.vscode-base64
	code --install-extension bazelbuild.vscode-bazel

.PHONY: gcloud
gcloud:
	gcloud config set disable_usage_reporting false
	gcloud components install docker-credential-gcr
	gcloud components install gsutil
	gcloud components install gke-gcloud-auth-plugin
	gcloud components update

.PHONY: python
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
