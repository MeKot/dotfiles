export SABER_HOME=/home/admin/Downloads/PerfEng/performanceprofiling_ik716
# If you come from bash you might have to change your $PATH.
export PATH=$SABER_HOME/clib:/home/admin/.local/bin:/usr/local/bin:~/go/bin:~/dotfiles/bin:/usr/local/java/jdk1.8.0_191/bin:/home/admin/IdeaProjects/bigpig/symbex/jpf-core/bin:$HOME/.node_modules/bin:/opt/cuda/bin:$PATH

#export ANDROID_HOME=/opt/android-sdk/

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
export npm_config_prefix=~/.node_modules

# Starting the ssh-agent if not running
eval $(keychain --eval --quiet)
eval $(keychain --quiet ~/.ssh/ik716)
eval $(keychain --quiet ~/.ssh/johnny)
eval $(keychain --quiet ~/.ssh/willswest)

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git mvn)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR="/usr/local/bin/vim"
 else
   export EDITOR="/usr/local/bin/vim"
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
 
alias antlr="java -jar /usr/local/Cellar/antlr/4.7/antlr-4.7-complete.jar"
alias grun="java -cp bin:lib/antlr-4.7-complete.jar org.antlr.v4.runtime.misc.TestRig antlr.WACC"
alias c="clear"
alias vim="nvim"
alias view="nvim -R"
alias gqs="git-quick-stats"
alias v="nvim"
alias q="exit"
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias cat="bat"
alias gcam="git commit -a -S -m"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export GPG_TTY=$(tty)
export JAVA_HOME=/usr/local/java/jdk1.8.0_191/
export PATH=$JAVA_HOME/bin:$PATH
