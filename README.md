# dotfiles

Personal shell, git, SSH and editor configuration, plus a single Homebrew
`Brewfile` that provisions both macOS and Linux devcontainers.

## New Mac

1. Install git, then clone the repo:

   ```bash
   git clone https://github.com/davidcollom/dotfiles.git ~/repos/github/davidcollom/dotfiles
   cd ~/repos/github/davidcollom/dotfiles
   ```

2. Run the bootstrap:

   ```bash
   ./setup.sh
   ```

   This installs Homebrew, runs `brew bundle`, installs Oh My Zsh and copies the
   configuration into `$HOME`. Desktop-only setup (macOS defaults, iTerm2
   colours, VS Code extensions and gcloud components) runs automatically on
   macOS.

3. Restart your shell. Copy any private keys into `~/.ssh` and run `make git`
   if you need to refresh config files on an existing machine.

## GitHub Codespaces

Open the repo in a Codespace. The devcontainer definition in
`.devcontainer/devcontainer.json` runs `devcontainer-install.sh` after create,
which:

1. Installs Homebrew on Linux if needed.
2. Runs `brew bundle` against the shared `Brewfile` (casks are skipped on Linux).
3. Installs Oh My Zsh and copies the shell/git/SSH config into `$HOME`.

The Docker-in-Docker feature provides the Docker CLI in the container.

To test the Linux path locally with Docker:

```bash
docker run --rm -it -v "$PWD":/workspaces/dotfiles -w /workspaces/dotfiles \
  mcr.microsoft.com/devcontainers/base:ubuntu-24.04 \
  bash devcontainer-install.sh
```

## Layout

| Path | Purpose |
| --- | --- |
| `Brewfile` | Homebrew packages; Mac-only apps are guarded by `OS.mac?` |
| `.zshrc` | Primary shell config (Oh My Zsh, aliases, PATH) |
| `bash/` | Bash profile, aliases, exports and prompt |
| `git/` | Global git config, per-context includes and ignore rules |
| `ssh/config` | SSH client defaults |
| `vscode/settings.json` | VS Code settings (macOS) |
| `iterm2/` | iTerm2 colour scheme |
| `python/requirements.txt` | Python tooling installed by `make python` |
| `Makefile` | Bootstrap targets; `make help` lists them |

## Secrets

No credentials or private keys are stored here. `~/.gitconfig-extras` and
`~/.bash_secrets` are local-only includes; keep them out of the repo.
