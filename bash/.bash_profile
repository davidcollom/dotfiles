# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$HOME/go/bin:/opt/homebrew/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.bash_{path,prompt,exports,aliases,functions,extra,secrets}; do
	[ -r "$file" ] && [ -f "$file" ] && source "${file}";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
	source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;



# Source the Gcloud sdk.
if command -v brew >/dev/null 2>&1; then
	GCLLOUD_SDK="$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
	if [ -f "$GCLLOUD_SDK/path.bash.inc" ]; then
		source "$GCLLOUD_SDK/path.bash.inc"
	fi
	if [ -f "$GCLLOUD_SDK/completion.bash.inc" ]; then
		source "$GCLLOUD_SDK/completion.bash.inc"
	fi
elif [ -f /usr/lib/google-cloud-sdk/path.bash.inc ]; then
	source /usr/lib/google-cloud-sdk/path.bash.inc
fi


# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && command -v brew >/dev/null 2>&1 && [ -f "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]; then
	complete -o default -o nospace -F _git g;
fi;

# Terraform autocomplete
if [ -x /opt/homebrew/bin/terraform ]; then
	complete -C /opt/homebrew/bin/terraform terraform
	complete -C /opt/homebrew/bin/terraform tf
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;
