#!/bin/bash

usage() {
  echo "Usage: waybar-updates [options]
    -f, --format          Custom format string with one/more of {aur}, {pacman} or {total}
    -t, --tooltip         Custom format string for the tooltip (use {} for the update list)
    -i, --interval        Interval between checks
    -c, --cycles          Cycles between online checks (e.g. 6s * 600 cycles = 3600s = 1h between online checks)
    -l, --packages-limit  Maximum number of packages to be shown in notifications and tooltip
    -d, --devel           Enable devel checks
    -n, --notify          Enable notifications for updats."
  exit 2
}

declare -A formats=()
formats[text]="{total}"
# formats[tooltip]="\t\t {\t  :pacman}{\t  :aur}{\t  :dev}\n\n{}"
formats[tooltip]="{}"   # now we’ll build our own tooltip with headers
tooltip_pacman=""
tooltip_aur=""
tooltip_devel=""

interval=6
cycles_number=600
packages_limit=15
devel=false
notify=false

PARSED_ARGUMENTS=$(getopt --name "waybar-updates" -o "hf:t:i:c:l:dn" --long \
  "help,format:,tooltip:,interval:,cycles:,packages-limit:,devel,notify" -- "$@")
eval set -- "$PARSED_ARGUMENTS"
while :; do
  case "$1" in
  -f | --format)
    formats[text]="$2"
    shift 2
    ;;
  -t | --tooltip)
    formats[tooltip]="$2"
    shift 2
    ;;
  -i | --interval)
    interval="$2"
    shift 2
    ;;
  -c | --cycles)
    cycles_number="$2"
    shift 2
    ;;
  -l | --packages-limit)
    packages_limit="$2"
    shift 2
    ;;
  -d | --devel)
    devel=true
    shift
    ;;
  -n | --notify)
    notify=true
    shift
    ;;
  -h | --help) usage ;;
  --)
    shift
    break
    ;;
  *)
    echo "Unexpected option: $1"
    usage
    ;;
  esac
done

check_pacman_updates() {
  if [ "$1" == "online" ]; then
    pacman_updates=$(checkupdates --nocolor)
  elif [ "$1" == "offline" ]; then
    pacman_updates=$(checkupdates --nosync --nocolor)
  fi

  pacman_updates_checksum=$(echo "$pacman_updates" | sha256sum)
  pacman_updates_count=$(echo "$pacman_updates" | grep -vc ^$)
}

check_devel_updates() {
  ignored_packages=$(pacman-conf IgnorePkg)
  if [ "$1" == "online" ]; then
    develsuffixes="git"
    develpackages=$(pacman -Qm | grep -Ee "$develsuffixes")
    if [ -n "$ignored_packages" ]; then
        develpackages=$(grep -vF "$ignored_packages" <<< "$develpackages")
    fi
    rm -f "$tmp_devel_packages_file"
    tmp_devel_packages_file=$(mktemp --suffix -waybar-updates)
    build_devel_list "$develpackages" "online"
  elif [ "$1" == "offline" ]; then
    new_devel_packages=$(pacman -Qm | grep -Ee "$develsuffixes")
    old_devel_packages=$(awk '{printf ("%s %s\n", $1, $3)}' "$tmp_devel_packages_file")

    develpackages=$(LC_ALL=C join <(echo "$old_devel_packages") <(echo "$new_devel_packages"))
    echo "d:$develpackages"

    if [[ $(echo "$develpackages" | grep -vc ^$) -ne 0 ]]; then
      develpackages=$(awk '{printf ("%s %s %s\n", $1, $3, $2)}' <<< "$develpackages")
      build_devel_list "$develpackages" "offline"
    fi
  fi
  devel_updates=$(awk '{printf ("%s %s\n", $1, $2)}' "$tmp_devel_packages_file")
  devel_updates_checksum=$(echo "$devel_updates" | sha256sum)
  devel_updates_count=$(echo "$devel_updates" | grep -vc ^$)
}

build_devel_list() {
  custom_pkgbuild_vars="_gitname=\|_githubuser=\|_githubrepo=\|_gitcommit=\|url=\|_pkgname=\|_gitdir=\|_repo_name=\|_gitpkgname=\|source_dir=\|_name="

  truncate -s 0 "$tmp_devel_packages_file"

  i=0
  while read -r pkgname version source
  do
    (( i++ ))
    if [ -z "$source" ]; then
      eval "$(curl -s "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=$pkgname" | grep "$custom_pkgbuild_vars")"
      eval source="$(curl -s "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=$pkgname" | \
        grep -zPo '(?s)source=\(.*?\)' | \
        awk '/git/{print "source="$1}' | \
        sed 's/source=//g' | sed '/http/p' | \
        sed 's/(//;s/)//g' | tr -d '\0' | head -1)"
      source=$(sed 's/^\(.*\)\(http.*$\)/\2/;s/\"//;s/'\''//' <<< "$source")
      source=$(cut -f1 -d"#" <<< "$source")
    fi
    lastcommit=$(git ls-remote --heads "$source" | awk '{ print $1}' | cut -c1-7)
    if ! echo "$version" | grep -q "$lastcommit"; then
      echo "$pkgname $version $source ${lastcommit//$'\n'/ }" >> "$tmp_devel_packages_file"
    fi
  done <<< "$1"
}

check_aur_updates() {
  ignored_packages=$(pacman-conf IgnorePkg)
  if [ -n "$ignored_packages" ]; then
      old_aur_packages=$(pacman -Qm | grep -vF "$ignored_packages")
  else
      old_aur_packages=$(pacman -Qm)
  fi

  if [ "$1" == "online" ]; then
    rm -f "$tmp_aur_packages_file"
    tmp_aur_packages_file=$(mktemp --suffix -waybar-updates)
    # shellcheck disable=SC2046
    new_aur_packages=$(curl -s "https://aur.archlinux.org/rpc?v=5&type=info$(printf '&arg[]=%s' $(echo "$old_aur_packages" | cut -f1 -d' '))" |
      jq -r '.results[] | .Name + " " + .Version' | tee "$tmp_aur_packages_file")
  elif [ "$1" == "offline" ]; then
    new_aur_packages=$(cat "$tmp_aur_packages_file")
  fi

  aur_updates=$(LC_ALL=C join <(echo "$old_aur_packages") <(echo "$new_aur_packages") |
    while LC_ALL=C read -r pkg a b; do
      case "$(vercmp "$a" "$b")" in
      -1) printf "%s %s -> %s\n" "$pkg" "$a" "$b" ;;
      esac
    done)

  aur_updates_checksum=$(echo "$aur_updates" | sha256sum)
  aur_updates_count=$(echo "$aur_updates" | grep -vc ^$)
}

check_updates() {
  if [ "$1" == "online" ]; then
    check_pacman_updates online
    check_aur_updates online
    if [ $devel == true ];then check_devel_updates online; fi
  elif [ "$1" == "offline" ]; then
    check_pacman_updates offline
    check_aur_updates offline
    if [ $devel == true ];then check_devel_updates offline; fi
  fi
  if [ $devel == true ];then
    total_updates_count=$((pacman_updates_count + aur_updates_count + devel_updates_count))
  else
    total_updates_count=$((pacman_updates_count + aur_updates_count))
  fi
}

format() {
  local text format_arg="${formats[$1]}" aur_label dev_label pacman_label total_label

  [ "$aur_updates_count" -gt 0 ] && aur_label="\2${aur_updates_count}\4"
  [ "$devel_updates_count" -gt 0 ] && dev_label="\2${devel_updates_count}\4"
  [ "$pacman_updates_count" -gt 0 ] && pacman_label="\2${pacman_updates_count}\4"
  [ "$total_updates_count" -gt 0 ] && total_label="\2${total_updates_count}\4"

  text="$(echo -n "${format_arg}" | tr '\n' '\r' | sed \
    -e 's/{\(\([^{]\+\):\)\?aur\(:\([^}]\+\)\)\?}/'"$aur_label"'/' \
    -e 's/{\(\([^{]\+\):\)\?dev\(:\([^}]\+\)\)\?}/'"$dev_label"'/' \
    -e 's/{\(\([^{]\+\):\)\?pacman\(:\([^}]\+\)\)\?}/'"$pacman_label"'/' \
    -e 's/{\(\([^{]\+\):\)\?total\(:\([^}]\+\)\)\?}/'"$total_label"'/' \
  )"

  echo -e "${text//{\}/$2}"
}

send_notification() {
  local count="$3" list="$4" source="$2" text type="$1"
  local fmt="%d ${type} available from ${source}"

  [[ $notify == true && $count -gt 0 ]] || return

  text="$(ngettext waybar-updates "$fmt" "${fmt/update/updates}" "$count")"

  notify-send -a waybar-updates -u normal -i software-update-available-symbolic \
    "${text//%d/$count}" "$(echo "$list" | head -n "$packages_limit")"
}

send_output() {
  local source status=pending-updates text tooltip

  # if [[ ! $total_updates_count -gt 0 ]]; then
  if (( total_updates_count == 0 )); then
    json "" updated "$(gettext "waybar-updates" "System is up to date")" updated
    return 1
  fi

  # for source in pacman aur devel; do
  #   tooltip_append "${source}_updates_count" "${source}_updates"
  # done
  #
  # json "$(format text "$total_updates_count")" "$status" "$(format \
  #   tooltip "$(echo -e "$tooltip" | head -n "$packages_limit")" \
  # )" "$status"
  
  # build each section
  tooltip_pacman_header="[ Pacman updates: ${pacman_updates_count}]"
  tooltip_aur_header="[ AUR updates: ${aur_updates_count}]"
  tooltip_devel_header="[ Devel updates: ${devel_updates_count}]"
  # collect the raw lists
  tooltip_pacman=""; tooltip_aur=""; tooltip_devel=""
  tooltip_append pacman_updates_count pacman_updates
  tooltip_append aur_updates_count     aur_updates
  if [ "$devel" = true ]; then
	  tooltip_append devel_updates_count devel_updates
  fi
  # assemble full tooltip, limiting lines
  full_tooltip=""
  [[ -n $tooltip_pacman ]] && full_tooltip+="$tooltip_pacman_header\t${tooltip_pacman}\n\n"
  [[ -n $tooltip_aur    ]] && full_tooltip+="$tooltip_aur_header\t${tooltip_aur}\n\n"
  [[ -n $tooltip_devel  ]] && full_tooltip+="$tooltip_devel_header\t${tooltip_devel}\n\n"
  # trim trailing whitespace/newlines
  full_tooltip=$(echo -e "$full_tooltip" | head -n $packages_limit)
  json "$(format text "$total_updates_count")" "$status" "$full_tooltip" "$status"
}

# tooltip_append() {
#   [[ ${!1} -gt 0 ]] || return
#
#   [[ -z $tooltip ]] || tooltip+="\n"
#
#   tooltip+="${!2}"
# }

tooltip_append() {
	local count_var=$1 list_var=$2
	# only add if there are updates
	[[ ${!count_var} -gt 0 ]] || return

	case "$list_var" in
		pacman_updates)
			tooltip_pacman+="\n${!list_var}"
			;;
		aur_updates)
			tooltip_aur+="\n${!list_var}"
			;;
		devel_updates)
			tooltip_devel+="\n${!list_var}"
			;;
	esac
}
json() {
  jq --unbuffered --null-input --compact-output \
    --arg text "$1" \
    --arg alt "$2" \
    --arg tooltip "$3" \
    --arg class "$4" \
    '{"text": $text, "alt": $alt, "tooltip": $tooltip, "class": $class}'
}

cleanup() {
  echo "Cleaning up..."
  rm -f "$tmp_aur_packages_file"
  rm -f "$tmp_devel_packages_file"
  exit 0
}

# sync at the first start
check_updates online
pacman_updates_checksum=""
aur_updates_checksum=""
devel_updates_checksum=""
# count cycles to check updates using network sometime
cycle=0

trap cleanup SIGINT SIGTERM

# check updates every 6 seconds
while true; do
  previous_pacman_updates_checksum=$pacman_updates_checksum
  previous_aur_updates_checksum=$aur_updates_checksum
  if [ $devel == true ];then previous_devel_updates_checksum=$devel_updates_checksum; fi

  if [ "$cycle" -ge "$cycles_number" ]; then
    check_updates online
    cycle=0
  else
    check_updates offline
    cycle=$((cycle + 1))
  fi
  if [ $devel == true ];then
    condition (){
      { [ "$previous_pacman_updates_checksum" == "$pacman_updates_checksum" ] &&
      [ "$previous_aur_updates_checksum" == "$aur_updates_checksum" ] &&
      [ "$previous_devel_updates_checksum" == "$devel_updates_checksum" ] ;}
    }
  else
    condition (){
      { [ "$previous_pacman_updates_checksum" == "$pacman_updates_checksum" ] &&
      [ "$previous_aur_updates_checksum" == "$aur_updates_checksum" ] ;}
    }
  fi
  if condition; then
    sleep "$interval"
    continue
  fi

  # Output text and tooltip then send push notifcations, limiting the body to 10 packages;
  send_output && {
    send_notification update pacman "$pacman_updates_count" "$pacman_updates"
    send_notification update AUR "$aur_updates_count" "$aur_updates"
    send_notification devel-update AUR "$devel_updates_count" "$devel_updates"
  }

  sleep "$interval"
done
