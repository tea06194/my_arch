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
# HISTCONTROL=ignorespace:erasedups # Не пишем в историю команды с пробелом в начале и дубликаты
# shopt -s histappend  # Добавление в историю, а не перезапись

# Настройка автодополнения по истории
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

vpn() {
  export all_proxy="socks5h://127.0.0.1:2080"
  command="$1"
  shift
  $command "$@"
}

