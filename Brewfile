cask_args appdir: "/Applications"

# Third-party taps used by the formulas below.
tap "alextodicescu/tgenv"
tap "anomalyco/tap"
tap "datawire/blackbird"
tap "fluxcd/tap"
tap "goreleaser/tap"
tap "komodorio/komocli"
tap "little-angry-clouds/homebrew-my-brews"
tap "minamijoyo/tfupdate"
tap "norwoodj/tap"
tap "pulumi/tap"
tap "snyk/tap"
tap "thecasualcoder/stable"
tap "txn2/tap"
tap "upbound/tap"

# Brewfiles are Ruby, so a single file can serve macOS and Linux (Codespaces).
if OS.mac?
  tap "homebrew/cask"
  tap "homebrew/cask-fonts"
end

# General CLI
brew "ack"
brew "age"
brew "asciinema"
brew "bat"
brew "coreutils"
brew "direnv"
brew "fzf"
brew "gh"
brew "git"
brew "git-delta"
brew "git-extras"
brew "graphviz"
brew "htop"
brew "jq"
brew "mkcert"
brew "openssh"
brew "pipx"
brew "pre-commit"
brew "pv"
brew "pwgen"
brew "pyenv"
brew "redis"
brew "rsync"
brew "shellcheck"
brew "ssh-copy-id"
brew "stow"
brew "tldr"
brew "tmate"
brew "tree"
brew "uv"
brew "watch"
brew "wget"
brew "yq"
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# Languages and runtimes
brew "cookiecutter"
brew "go"
brew "node@24"

# AI and developer tooling
brew "anomalyco/tap/opencode"
brew "golangci-lint"
brew "go-critic"
brew "svu"

# Kubernetes
brew "argo"
brew "argocd"
brew "fluxcd/tap/flux", link: true
brew "helm", link: false
brew "helmfile"
brew "kind"
brew "kubeaudit"
brew "kubectx"
brew "krew"
brew "kustomize"
brew "minikube"
brew "norwoodj/tap/helm-docs"
brew "stern"
brew "kubernetes-cli", link: false

# Terraform / Pulumi
brew "minamijoyo/tfupdate/tfupdate"
brew "terraform-docs"
brew "terraformer"
brew "tfenv"
brew "tfsec"
brew "tflint"
brew "tgenv"
brew "pulumi/tap/pulumi"

# Cloud and platform CLIs
brew "actionlint"
brew "awscli"
brew "azure-cli"
brew "cosign"
brew "crane"
brew "crossplane"
brew "eksctl"
brew "ko"
brew "komodorio/komocli/komocli"
brew "oci-cli"
brew "snyk/tap/snyk"
brew "upbound/tap/up"

if OS.mac?
  brew "docker" # Docker CLI; in Codespaces this comes from the devcontainer feature
  brew "mas"

  # Applications (macOS only)
  cask "aerial"
  cask "chatgpt"
  cask "claude-code"
  cask "diffmerge"
  cask "docker-desktop"
  cask "firefox"
  cask "font-source-code-pro"
  cask "flux"
  cask "gcloud-cli"
  cask "goreleaser"
  cask "ibm-cloud-cli"
  cask "iterm2"
  cask "itsycal"
  cask "keepingyouawake"
  cask "localsend"
  cask "microsoft-teams"
  cask "notion"
  cask "rectangle"
  cask "slack"
  cask "spotify"
  cask "tailscale-app"
  cask "temurin@17"
  cask "the-unarchiver"
  cask "visual-studio-code"
  cask "vlc"
  cask "webex"
  cask "wizcli"
  cask "zoom"

  mas "Webcam Settings", id: 533696630
end
