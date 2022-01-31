#!/usr/bin/env bash

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Sudo password first..
sudo -v

# install git
brew install git || true

# clone dotfiles repo
[[ ! -d /tmp/dotfiles ]] && git clone https://github.com/davidcollom/dotfiles.git /tmp/dotfiles

# install packages
cd /tmp/dotfiles || echo "Failed to clone repo to /tmp/dotfiles" && exit 1
brew bundle

# Setup gitconfig
cp /tmp/dotfiles/gitconfig ~/.gitconfig
cp /tmp/dotfiles/gitignore ~/.gitignore

# Setup Bash
for f in ./bash*; do
  cp "/tmp/dotfiles/${f}" "${HOME}/.$(basename "$f")"
done
echo /usr/local/bin/bash | sudo tee -a /etc/shells
sudo chsh -s /usr/local/bin/bash "${USER}"

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
code --install-extension adamhartford.vscode-base64
code --install-extension bazelbuild.vscode-bazel

# Kubernetes krew plugins
kubectl krew install access-matrix
kubectl krew install advise-psp
kubectl krew install cert-manager
kubectl krew install cost
kubectl krew install deprecations
kubectl krew install doctor
kubectl krew install evict-pod
kubectl krew install exec-cronjob
kubectl krew install get-all
kubectl krew install gke-credentials
kubectl krew install images
kubectl krew install ingress-nginx
kubectl krew install kubesec-scan
kubectl krew install neat
kubectl krew install np-viewer
kubectl krew install outdated
kubectl krew install pod-inspect
kubectl krew install pod-lens
kubectl krew install prune-unused
kubectl krew install rbac-view
kubectl krew install score
kubectl krew install service-tree
kubectl krew install sniff
kubectl krew install tree
kubectl krew install unused-volumes
kubectl krew install view-cert
kubectl krew install view-secret
kubectl krew install view-utilization
kubectl krew install view-webhook
kubectl krew install who-can
kubectl krew install whoami

kubectl krew index add edit-status https://github.com/ulucinar/kubectl-edit-status
kubectl krew install edit-status/edit-status

kubectl krew index add davidcollom https://github.com/davidcollom/krew-index
kubectl krew install davidcollom/watch

# Gcloud Components
gcloud config set disable_usage_reporting false
gcloud components install docker-credential-gcr
gcloud components install nomos
gcloud components install gsutil
gcloud components update

pip3 install -r requirements.txt



# Setup settings of VS Code
cp /tmp/dotfiles/settings.json ~/Library/Application\ Support/Code/User/settings.json
