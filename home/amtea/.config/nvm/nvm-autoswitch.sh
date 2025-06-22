#!/bin/bash
# nvm-autoswitch.sh

# Opts (can switch in .bashrc)
export NVM_AUTO_SWITCH_QUIET=${NVM_AUTO_SWITCH_QUIET:-false} # true - silent mode
export NVM_AUTO_INSTALL=${NVM_AUTO_INSTALL:-true}

auto_switch_node() {
	# nvm is availible
	if ! command -v nvm &>/dev/null; then
		return 0
	fi

	local node_version="$(nvm version)"
	local nvm_path="$(nvm_find_up .nvmrc | command tr -d '\n')"

	if [ -n "$nvm_path" ]; then
		# .nvmrc exist
		local nvm_version=$(<"${nvm_path}/.nvmrc")

		if [ "$nvm_version" = "N/A" ]; then
			# Not installed
			if [ "$NVM_AUTO_INSTALL" = "true" ]; then
				[ "$NVM_AUTO_SWITCH_QUIET" != "true" ] && echo "📦 Installing Node.js version from .nvmrc..."
				nvm install
			else
				[ "$NVM_AUTO_SWITCH_QUIET" != "true" ] && echo "⚠️  Node.js version $(cat "${nvmrc_path}") not installed. Run 'nvm install' to install it."
			fi
		elif [ "$nvm_version" != "$node_version" ]; then
			[ "$NVM_AUTO_SWITCH_QUIET" != "true" ] && echo "🔄 Switching to Node.js $(cat "${nvmrc_path}")"
			nvm use "$nvm_version"
		fi
	else
		# .nvmrc not exist - use default
		local default_version="$(nvm version default)"

		if [ "$default_version" = "N/A" ]; then
			# No default version - install last LTS
			[ "$NVM_AUTO_SWITCH_QUIET" != "true" ] && echo "⚠️  No default Node.js version set. Setting latest LTS as default..."
			nvm alias default lts/*
			default_version="$(nvm version default)"
		fi

		if [ "$node_version" != "$default_version" ]; then
			[ "$NVM_AUTO_SWITCH_QUIET" != "true" ] && echo "🏠 Switching to default Node.js version"
			nvm use default
		fi
	fi
}

# cd alias
cd() {
	builtin cd "$@"
	auto_switch_node
}

# zoxide integration
if command -v zoxide &>/dev/null; then
	z() {
		__zoxide_z "$@"
		auto_switch_node
	}

	zi() {
		__zoxide_zi "$@"
		auto_switch_node
	}
fi
