#!/bin/zsh
# Modern nvm-autoswitch.sh with enhanced zsh integration

# Configuration options (can be set in .zshrc)
export NVM_AUTO_SWITCH_QUIET=${NVM_AUTO_SWITCH_QUIET:-false}
export NVM_AUTO_INSTALL=${NVM_AUTO_INSTALL:-true}

# Enable extended globbing for better pattern matching
setopt EXTENDED_GLOB

# Logging function with emoji support
log() {
	[[ "$NVM_AUTO_SWITCH_QUIET" != "true" ]] && builtin print -r -- "$@"
}

# Load nvm if not already loaded
_load_nvm() {
	if ! typeset -f nvm &>/dev/null; then
		if [[ -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]]; then
			# shellcheck source=/dev/null
			. "${NVM_DIR:-$HOME/.nvm}/nvm.sh"
		fi
	fi
}

# Main function: detect .nvmrc and switch or install as needed
auto_switch_node() {
	_load_nvm
	local nvmrc_file version
	nvmrc_file=$(printf "%s/.nvmrc" "$PWD")
	if [[ -f $nvmrc_file ]]; then
		version=$(<"$nvmrc_file")
		if [[ $(nvm version) != "v$version" ]]; then
			if nvm ls "$version" &>/dev/null; then
				log "🔄 Switching to Node.js $version"
				nvm use "$version"
			elif [[ "$NVM_AUTO_INSTALL" == "true" ]]; then
				log "⬇️ Installing Node.js $version"
				nvm install "$version" && nvm use "$version"
			else
				log "⚠️ Node.js $version not installed"
			fi
		fi
	fi
}

# Hook into directory changes and prompt to auto-switch
autoload -U add-zsh-hook
add-zsh-hook chpwd auto_switch_node
add-zsh-hook precmd auto_switch_node

# Preserve fasd integration if present
if (( $+commands[fasd] )); then
	fasd_cd() {
		fasd "$@" && auto_switch_node
	}
	alias z=fasd_cd
fi

# Function to manually trigger nvm autoswitch
nvm-autoswitch() {
	auto_switch_node
}
