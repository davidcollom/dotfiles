# `dotfiles`

My personal dotfiles and machine setup, for macOS and Linux.

The repository is managed with a `Makefile` and [GNU Stow](https://www.gnu.org/software/stow/), so
individual pieces of configuration can be installed into your home directory without copying the whole
tree around.

## Layout

| Path | Description |
| ---- | ----------- |
| `bash/` | Bash configuration: `.bashrc`, `.bash_profile`, `.bash_aliases`, `.bash_exports`, `.bash_prompt`. |
| `git/` | `.gitconfig` plus conditional includes for work/personal/DOD profiles. |
| `ssh/` | SSH client configuration. |
| `iterm2/` | iTerm2 colour scheme. |
| `vscode/` | VS Code settings. |
| `python/` | Python requirements. |
| `Brewfile` | Homebrew bundle definition (formulae, casks and taps). |
| `.zshrc` | Zsh configuration. |
| `Makefile` | Installation targets. |
| `setup.sh` | Bootstrap script for a fresh machine. |
| `setup-mac.sh` | macOS-specific system defaults. |
| `devcontainer-install.sh` | Installs the toolchain inside a devcontainer. |

## Bootstrapping a new machine

```bash
curl -fsSL https://raw.githubusercontent.com/davidcollom/dotfiles/main/setup.sh | bash
```

`setup.sh` installs Homebrew, clones the repository into `/tmp/dotfiles` and runs `make install`.

On macOS, `setup-mac.sh` is run first to apply system-level preferences (standby delay, smart quote
and dash substitution, print panel behaviour, and similar).

## Installation targets

```bash
make install    # Full install (mac, brew, zsh, bash, git, ssh, iterm2, krew, vscode, gcloud, python)
make mac        # macOS system defaults only
make brew       # brew bundle (install everything in the Brewfile)
make zsh        # oh-my-zsh + copy .zshrc
make bash       # Copy the bash/ directory into $HOME
make git        # Copy the git/ directory into $HOME
make ssh        # Copy the ssh/ directory into ~/.ssh
make iterm2     # Open the iTerm2 colour scheme
make setup      # Run ./setup.sh
```

## How the file copying works

Most targets use `cp -nrv` (copy, never overwrite, verbose) into `$HOME`, so your own local changes
are preserved rather than clobbered. The `git` directory is copied with `git/` contents merged into
`~/.gitconfig`, and `includeIf` blocks in the git configuration pick the right profile based on which
directory you are working in — for example, work repositories use a separate signing key and email
address.

## Requirements

- macOS or Linux
- [Homebrew](https://brew.sh) and [GNU Stow](https://www.gnu.org/software/stow/)
- `bash`, `zsh` and `git`

## License

See the repository for licensing details.
