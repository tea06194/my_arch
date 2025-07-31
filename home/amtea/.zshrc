#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable colors
autoload -U colors && colors

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

## MY ##
export MANPAGER="nvim +Man!"
export PAGER=cat
export EDITOR=nvim
# export BROWSER=google-chrome

alias hyprc='nvim ~/.config/hypr/hyprland.conf'
alias graph='git log --all --decorate --oneline --graph'
# alias nvim='/home/amtea/.config/kitty_nvim.sh'

# History settings
HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# History search with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Enable completion system
autoload -Uz compinit
compinit

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

###
# nvm auto switch

# opts
export NVM_AUTO_SWITCH_QUIET=true # true silent
# export NVM_AUTO_INSTALL=true

if [[ -f "$HOME/.config/nvm/nvm-autoswitch.sh" ]]; then
	source "$HOME/.config/nvm/nvm-autoswitch.sh"
	auto_switch_node
else
	print "⚠️  nvm-autoswitch.sh not found. Please check the installation path."
fi

###

vpn() {
	export all_proxy="socks5h://127.0.0.1:2080"
	command="$1"
	shift
	$command "$@"
}

export ZK_NOTEBOOK_DIR="$HOME/Documents/zknotes"

eval "$(zoxide init zsh)"

export PATH="$HOME/.local/bin:$PATH"

# Modern zsh prompt with colors
HOST_COLOR='%F{12}'
BRANCH_COLOR='%F{208}'
GREEN='%F{2}'
RESET='%f'

parse_git_branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Use zsh prompt expansion with modern features
setopt PROMPT_SUBST
PROMPT="${HOST_COLOR}%n@%m${RESET}:${GREEN}%~${RESET}${BRANCH_COLOR}\$(parse_git_branch)${RESET}%# "

# Auto cd - just type directory name to cd into it
setopt AUTO_CD

# Extended globbing
setopt EXTENDED_GLOB

# No beep
unsetopt BEEP
