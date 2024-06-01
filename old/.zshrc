# If you come from bash you might have to change your $PATH.
export PATH=~/dotfiles/bin:/opt/homebrew/bin:$PATH
export NOTES_DIR=~/vimwiki/
export XDG_CONFIG_HOME=~/.config

source ~/.ssh/keys.sh

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# NVR setup
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty. This makes repository
# status check for large repositories much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf kubectl minikube)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR="nvim"
 else
   export EDITOR="nvim"
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

alias c="clear"
alias vim="nvim"
alias view="nvim -R"
alias gqs="git-quick-stats"
alias ta="tmux attach -t"
alias tt="terraform"
alias v="nvim"
alias q="exit"
alias zshconfig="nvim ~/.zshrc"
alias catt="cat"
alias cat="bat"
alias gcam="git commit -a -S -m"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export GPG_TTY=$(tty)

autoload -U +X bashcompinit && bashcompinit
