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
| `vscode/` | VS Code settings. |
| `python/` | Python requirements. |
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

`setup.sh` installs Homebrew, clones the repository into `/tmp/dotfiles` and runs `make install`.

On macOS, the `mac` target runs `setup-mac.sh` first to apply system-level preferences — standby
delay, boot sound, print panel behaviour, the "Open With" menu and similar.

## Installation targets

```bash
make install    # Full install (mac, brew, zsh, git, ssh, iterm2, krew, vscode, gcloud, python)
make mac        # macOS system defaults only (no-op on other platforms)
make brew       # brew bundle (install everything in the Brewfile)
make zsh        # oh-my-zsh + copy .zshrc
make git        # Copy the git/ directory into $HOME
make ssh        # Copy the ssh/ directory into ~/.ssh
make iterm2     # Open the iTerm2 colour scheme
make kubectl    # Install kubectl via kbenv and set up shell completion
make terraform  # Install terraform via tfenv and set up shell completion
make krew       # Install kubectl plus a set of krew plugins
make vscode     # Copy VS Code settings and install extensions
make gcloud     # Configure the gcloud CLI
make python     # Install python/requirements.txt
make setup      # Run ./setup.sh
make help       # List the available targets
```

> **Note:** the `install` target lists a `bash` prerequisite, but the `Makefile` does not define a
> `bash` target — so `make install` (and therefore `setup.sh`) currently fails with
> `No rule to make target 'bash'`. The `bash/` directory is copied by hand, or the `bash`
> prerequisite can be dropped from the `install` line.

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
- [Homebrew](https://brew.sh)
- `bash`, `zsh` and `git`

## License

No licence file is included in this repository.
