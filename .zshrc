# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/go/bin:/opt/homebrew/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path to your custom Oh My Zsh plugins. Set this before Oh My Zsh is sourced
# so that the plugin list below can be filtered against what is installed.
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 30

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"
setopt HIST_IGNORE_SPACE         # Don't store commands prefixed with a space
setopt HIST_REDUCE_BLANKS        # Collapse excess whitespace
setopt HIST_IGNORE_DUPS          # Ignore exact duplicates
setopt HIST_SAVE_NO_DUPS         # Remove duplicates when saving history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire oldest duplicates first when trimming
setopt EXTENDED_HISTORY          # Include timestamps in the history file
setopt INC_APPEND_HISTORY        # Write commands to history immediately
setopt BANG_HIST                 # Enable !! and !$ style history expansion
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

unsetopt sharehistory
setopt interactivecomments

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    argocd
    brew
    cp
    direnv
    dotenv
    fluxcd
    fzf
    gcloud
    gh
    git
    golang
    history-substring-search
    iterm2
    kind
    kube-ps1
    kubectl
    kubectx
    operator-sdk
    pip
    pre-commit
    ssh
    vscode
    terraform
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Only load the plugins that are actually installed. Without this a single
# missing plugin (for example on a minimal container) makes Oh My Zsh print a
# warning for every shell that is started.
plugins=($(for plugin in $plugins; do
    [[ -d "$ZSH/plugins/$plugin" || -d "$ZSH_CUSTOM/plugins/$plugin" ]] && echo "$plugin"
done))


if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
else
    echo "oh-my-zsh is not installed at $ZSH" >&2
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# Only use en_GB.UTF-8 when the locale is actually available, otherwise fall
# back to the locale of the system (containers often only ship C.UTF-8).
if locale -a 2>/dev/null | grep -qi '^en_GB\.utf-\?8$'; then
    export LANG=en_GB.UTF-8
elif [[ -z "${LANG:-}" ]]; then
    export LANG=C.UTF-8
fi
export EDITOR='vim'

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then

# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# zsh-syntax-highlighting and zsh-autosuggestions are loaded by the Oh My Zsh
# plugins listed above. The Homebrew copies are only used as a fallback, for
# example on a machine with an older Oh My Zsh installation.
if [[ -z "${ZSH_HIGHLIGHT_VERSION:-}" && -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -z "${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:-}" && -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

alias k="kubectl"
alias kns="kubens"
alias kctx="kubectx"
alias tf="terraform"
alias timestamp='date "+%Y-%m-%d %H:%M:%S"'

# `compdef` is provided by Oh My Zsh, so it is only available once it has been
# sourced. The completion is only registered when the command exists.
if command -v compdef >/dev/null 2>&1; then
    command -v kubectl >/dev/null 2>&1 && compdef k=kubectl
    command -v terraform >/dev/null 2>&1 && compdef tf=terraform
fi


# Tailscale is only installed on macOS.
[[ -x "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]] && alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Go Version Manager
[[ -s "${GVM_ROOT:-$HOME/.gvm}/scripts/gvm" ]] && source "${GVM_ROOT:-$HOME/.gvm}/scripts/gvm"

