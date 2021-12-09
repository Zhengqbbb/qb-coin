# shellcheck shell=sh disable=SC3043
# https://github.com/Zhengqbbb/qb
# Copyright (c) 2021 Zhengqbbb
# License: MIT License
_REMOTE="${_REMOTE:-github}"
_G_USER="${_G_USER:-zhengqbbb}"
___qb_setup() {
	[ ! -f "$HOME/.qb/qb.sh" ] && return 1
	local CAN="$HOME/.profile"
	if [ "$BASH_VERSION" ]; then        CAN="$HOME/.bashrc"
		[ "$(uname)" = "Darwin" ]  &&   CAN="$CAN $HOME/.bash_profile"
	elif [ "$ZSH_VERSION" ]; then       CAN="$HOME/.zshrc"
	elif [ "$KSH_VERSION" ]; then       CAN="$HOME/.kshrc"
	else                                CAN="$HOME/.shinit"
	fi

	QB_STR="[ -f \"\$HOME/.qb/qb.sh\" ] && . \"\$HOME/.qb/qb.sh\""
	IFS=" "
	for i in $CAN; do
		if grep -F "$QB_STR" "$i" >/dev/null; then
			printf "%s\n" "$(ui yellow "[qb]: Already installed in $i")" >&2
		else
			printf "\n%s\n" "$QB_STR" >> "$i"
			printf "%s\n" "$(ui green "[qb]: Successfully Installed in: $i")" >&2
		fi
	done

	[ -f "$HOME/.qb/data.json.bak" ] && cp "$HOME/.qb/data.json.bak" "$HOME/.qb/data.json"
	. "$HOME/.qb/qb.sh"
	___qb_draw_logo
	qb help
	___qb_printf_line
	printf "%s %s\n" \
		"$(ui bold green '[qb]:')" \
		"You can use $(ui bold cyan "\`qb help\`")  to view the help document"
	printf "%s %s\n" \
		"$(ui bold green '[qb]:')" \
		"Now you can try to run $(ui bold cyan "\`qb\`") to check it work" 
	printf "%s %s %s\n" \
		"$(ui bold green '[qb]:')" \
		"If there is a $(ui bold yellow 'network error') maybe you need socket5 proxy," \
		"you can run$(ui bold cyan "\`qb proxy\`") to set socket5 address"
}

___qb_install() {
	local QB_PATH="${QB_PATH:-$HOME/.qb}"
	if [ -f  "$QB_PATH/qb.sh" ]; then
		printf "%s\n" "$(ui yellow "[qb]: Already installed qb")"
		return 0
	fi
	printf "%s\n" "$(ui green "[qb]: Start to clone qb repo ...")"
	
	if [ ! "$(command -v git)" ]; then
		printf "%s\n" "$(ui red "[qb]: Error git is not installed")"
		return 1
	fi
	env git clone -b stable --depth=1 "https://$_REMOTE.com/$_G_USER/qb.git" "$QB_PATH" || {
	printf "%s\n" "$(ui red "[qb]: Error git clone of qb repo failed")"
    return 1
  }
}

# start
[ ! -f "$HOME/.x-cmd/.boot/boot" ] && eval "$(curl https://get.x-cmd.com)"
[ ! "$(command -v x)" ] && eval "$(curl https://get.x-cmd.com)"
xrc ui && printf "%s\n" "$(ui green "[qb]: Successful load x-cmd A powerful shell tool")"
___qb_install
___qb_setup