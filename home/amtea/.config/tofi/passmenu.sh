#!/usr/bin/env zsh
files=(${PASSWORD_STORE_DIR:-~/.password-store}/**/*.gpg(.N))
selected=$(printf '%s\n' ${${files#${PASSWORD_STORE_DIR:-~/.password-store}/}%.gpg} | tofi --prompt-text="🔑 pass: " --fuzzy-match=true)
[[ -n "$selected" ]] && pass show "$selected" | head -n1 | wtype -
