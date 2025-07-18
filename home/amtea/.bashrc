#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

## MY ##
export MANPAGER="nvim +Man!"
export PAGER=cat
export EDITOR=nvim
# export BROWSER=google-chrome

alias hyprc='nvim ~/.config/hypr/hyprland.conf'
alias graph='git log --all --decorate --oneline --graph'
# alias nvim='/home/amtea/.config/kitty_nvim.sh'
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="history -a; history -c; history -r"
shopt -s histappend

# Настройка автодополнения по истории
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

###
# nvm auto switch

# opts
export NVM_AUTO_SWITCH_QUIET=true # true silent
# export NVM_AUTO_INSTALL=true

if [ -f "$HOME/.config/nvm/nvm-autoswitch.sh" ]; then
	source "$HOME/.config/nvm/nvm-autoswitch.sh"
	auto_switch_node
else
	echo "⚠️  nvm-autoswitch.sh not found. Please check the installation path."
fi

###

vpn() {
	export all_proxy="socks5h://127.0.0.1:2080"
	command="$1"
	shift
	$command "$@"
}

export ANDROID_HOME=/opt/android-sdk
export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export ANDROID_AVD_HOME="$HOME/.config/.android/avd"

export ZK_NOTEBOOK_DIR="$HOME/Documents/zknotes"

eval "$(zoxide init bash)"

export PATH="$HOME/.local/bin:$PATH"

HOST_COLOR='\[\e[38;5;12m\]'
BRANCH_COLOR='\[\e[38;5;208m\]'
GREEN='\[\e[38;5;2m\]'
RESET='\[\e[0m\]'

parse_git_branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="${HOST_COLOR}\u@\h${RESET}:${GREEN}\w${RESET}${BRANCH_COLOR}\$(parse_git_branch)${RESET}\$ "

if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
fi
