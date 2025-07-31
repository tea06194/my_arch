#!/usr/bin/env zsh
setopt ERR_EXIT PIPE_FAIL EXTENDED_GLOB

readonly USER=/home/amtea
readonly USER_BACKUP=/home/amtea/my_arch/home/amtea
readonly SYSTEM_SERVICES_BACKUP=/home/amtea/my_arch/etc/systemd/system

clean_and_create_dir() {
	local dir=$1
	local use_sudo=$2

	if [[ $use_sudo == "sudo" ]]; then
		[[ -d $dir ]] && sudo rm -rf "$dir"
		sudo mkdir -p "$dir"
	else
		[[ -d $dir ]] && rm -rf "$dir"
		mkdir -p "$dir"
	fi
}

copy_verbose() {
	local src=$1
	local dest=$2
	local flags=$3
	local use_sudo=$4

	local cmd_result
	if [[ $use_sudo == "sudo" ]]; then
		cmd_result=$(sudo cp $flags "$src" "$dest" 2>&1)
	else
		cmd_result=$(cp $flags "$src" "$dest" 2>&1)
	fi

	if (( $? == 0 )); then
		print "✅ Successfully copied: $src"
	else
		print "❗ Failed to copy: $src"
		return 1
	fi
}

# Создаём структуру директорий
clean_and_create_dir "$USER_BACKUP"
clean_and_create_dir "$SYSTEM_SERVICES_BACKUP" "sudo"
mkdir -p "$USER_BACKUP/packages/" "$USER_BACKUP/.config/" "$USER_BACKUP/.local/share/"

# Сохраняем списки пакетов
pacman -Qqe > "$USER_BACKUP/packages/packages.txt"
pacman -Qqm > "$USER_BACKUP/packages/aur_packages.txt"

# Копируем конфигурационные файлы домашней директории
typeset -a home_configs=(
	".bash_profile"
	".bashrc"
	".zprofile"
	".zshrc"
	".makepkg.conf"
)

for config in $home_configs; do
	[[ -e $USER/$config ]] && copy_verbose "$USER/$config" "$USER_BACKUP/" "-ruv"
done

# Обрабатываем ManualPackages с использованием zsh globbing
if [[ -d $USER/ManualPackages ]]; then
	for pkgbuild_path in $USER/ManualPackages/**/PKGBUILD(N); do
		relative_path=${pkgbuild_path#$USER/}
		destination_dir=$USER_BACKUP/${relative_path:h}
		mkdir -p "$destination_dir"
		cp -v "$pkgbuild_path" "$destination_dir/"
	done
fi

# Копируем .config директории
typeset -a config_dirs=(
	"autostart"
	"audacious"
	"environment.d"
	"hypr"
	"kitty"
	"mako"
	"nvim"
	"nvm"
	"systemd"
	"tofi"
	"waybar"
	"yazi"
)

for config_dir in $config_dirs; do
	[[ -d $USER/.config/$config_dir ]] && copy_verbose "$USER/.config/$config_dir" "$USER_BACKUP/.config/" "-rv"
done

# Копируем отдельные конфигурационные файлы
typeset -a config_files=(
	"pwr.sh"
	"mimeapps.list"
)

for config_file in $config_files; do
	[[ -e $USER/.config/$config_file ]] && copy_verbose "$USER/.config/$config_file" "$USER_BACKUP/.config/" "-rv"
done

# Копируем .local директории
typeset -a local_dirs=(
	"bin"
	"share/fonts"
	"share/applications"
)

for local_dir in $local_dirs; do
	local src_path=$USER/.local/$local_dir
	local dest_path=$USER_BACKUP/.local/${local_dir:h}
	[[ -d $src_path ]] && copy_verbose "$src_path" "$dest_path" "-rv"
done

# Копируем системные сервисы
typeset -a system_services=(
	"/etc/systemd/system/numlock.service"
	"/etc/systemd/system/getty@tty1.service.d"
)

for service in $system_services; do
	[[ -e $service ]] && copy_verbose "$service" "$SYSTEM_SERVICES_BACKUP/" "-rv" "sudo"
done

print "🎉 Backup completed successfully!"
