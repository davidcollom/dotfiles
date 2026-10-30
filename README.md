# `dotfiles`

My personal dotfiles and machine setup, for macOS and Linux.

The repository is managed with a `Makefile`, so each piece of configuration can be installed into
your home directory with a single target.

## Layout

| Path | Description |
| ---- | ----------- |
| `bash/` | Bash configuration: `.bashrc`, `.bash_profile`, `.bash_aliases`, `.bash_exports`, `.bash_prompt`. |
| `git/` | `.gitconfig` plus the conditional work and DOD profile includes. |
| `ssh/` | SSH client configuration. |
| `iterm2/` | iTerm2 colour scheme (`Solarized Dark.itermcolors`). |
| `vscode/` | VS Code settings and the list of extensions to install. |
| `python/` | Python requirements. |
| `.devcontainer/` | Dev container definition, used by GitHub Codespaces and the Dev Containers extension. |
| `Brewfile` | Homebrew bundle definition (formulae, casks and taps). |
| `.zshrc` | Zsh configuration. |
| `Makefile` | Installation targets. |
| `setup.sh` | Bootstrap script for a fresh machine. |
| `setup-mac.sh` | macOS-specific system defaults. |
| `devcontainer-install.sh` | Installs the shell setup inside a devcontainer. |

## Bootstrapping a new machine

```bash
curl -fsSL https://raw.githubusercontent.com/davidcollom/dotfiles/main/setup.sh | bash
```

`setup.sh` installs Homebrew on macOS (or the basics with the system package manager on Linux),
clones the repository into `/tmp/dotfiles` and runs `make install`.

On macOS, the `mac` target runs `setup-mac.sh` first to apply system-level preferences — standby
delay, boot sound, print panel behaviour, the "Open With" menu and similar.

## GitHub Codespaces

The repository ships with a dev container definition in [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json),
so it can be opened as a Codespace straight from the GitHub UI ("Code" -> "Create codespace on
main") or from a local clone with the
[Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

When the container is created, `devcontainer-install.sh` runs as the `postCreateCommand`. It

- installs `zsh` when it is missing,
- installs [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) non-interactively,
- installs the `zsh-syntax-highlighting` and `zsh-autosuggestions` plugins,
- copies the zsh, bash, git, ssh and VS Code configuration into `$HOME` with `make devcontainer`,
- and sets `zsh` as the default shell.

Everything is idempotent, so rebuilding the container or running
`./devcontainer-install.sh` again is safe. The terminal is configured to use `zsh` by default.

## Installation targets

```bash
make install      # Full install (mac, brew, zsh, bash, git, ssh, iterm2, krew, vscode, gcloud, python)
make mac          # macOS system defaults only (no-op on other platforms)
make brew         # brew bundle (install everything in the Brewfile)
make zsh          # oh-my-zsh + copy .zshrc
make bash         # Copy the bash/ directory into $HOME
make git          # Copy the git/ directory into $HOME
make ssh          # Copy the ssh/ directory into ~/.ssh
make iterm2       # Open the iTerm2 colour scheme
make kubectl      # Install kubectl via kbenv and set up shell completion
make terraform    # Install terraform via tfenv and set up shell completion
make krew         # Install kubectl plus a set of krew plugins
make vscode       # Copy VS Code settings and install extensions
make gcloud       # Configure the gcloud CLI
make python       # Install python/requirements.txt
make devcontainer # Install the dotfiles inside a devcontainer or Codespace
make setup        # Run ./setup.sh
make help         # List the available targets
```

Targets that need a tool which is not installed (`brew`, `kbenv`, `tfenv`, `gcloud`, `pip3`, the
`code` CLI, ...) print a message and skip themselves instead of failing. This is what makes
`make install` work on Linux and inside a Codespace.

## How the file copying works

Most targets use `cp -nrv` (copy, never overwrite, verbose) into `$HOME`, so your own local changes
are preserved rather than clobbered. The `git` directory is copied into `$HOME`, and `includeIf`
blocks in the git configuration pick the right profile based on which directory you are working in —
for example, work repositories use a separate email address via `~/.gitconfig-work`.

The main `.gitconfig` also refers to `~/.gitconfig-personal` for repositories under
`~/repos/github/davidcollom/` and `~/repos/gitlab/davidcollom/`. That file is not shipped in this
repository, so it needs to be created locally.

The `krew` target adds the personal [krew index](https://github.com/davidcollom/krew-index) and
installs the `watch` plugin from it, which provides the `kubectl watch` command.

## Requirements

- macOS or Linux
- [Homebrew](https://brew.sh) (macOS only, the Linux targets do not need it)
- `bash`, `zsh` and `git`

## License

No licence file is included in this repository.
