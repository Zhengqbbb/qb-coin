# shellcheck shell=sh disable=SC3043

[ -z "$(command -v ui)" ] && xrc ui
# function
___qb_printf_line() {
    printf "%s\n" "$(ui bold blue "----------🚀-----🌕------------------------------------------------------")"
}

___qb_success_log_info() {
    printf "%s\n" "$(ui green "✅ SUCESS: $1")"
}

___qb_info_log_info() {
    printf "%s%s\n" \
		"$(ui yellow "📝 INFO: ")" \
    	"$(ui cyan "$1")"
}

___qb_warm_log_info() {
    printf "%s\n" "$(ui yellow "⚠️ WARM: $1")"
}

___qb_error_log_info() {
    printf "%s\n" "$(ui red "❌ ERROR: $1")"
}

___qb_printf_key_value() {
    printf "%s %s" \
		"$(ui bold cyan "$1"):" \
    	"$(ui bold green "$2")"
}

###
 # @param {*} link
###
___qb_printf_net_warm() {
    printf "%s\n%s\n%s\n" \
		"$(ui red 'not found data, maybe is net error')" \
		"Please check if the network is normal: $(ui underline yellow "$1")" \
		"And you can try $(ui cyan "\`qb proxy\`") to reset the proxy"
}

___qb_is_not_folder(){
	local TARGET_PATH="$1"
	if [ ! -d "$TARGET_PATH" ]; then
	warm_log_info "Not Find Folder :: $TARGET_PATH"
	return 0
	fi
	return 1
}
___qb_is_not_file(){
	local TARGET_PATH="$1"
	if [ ! -f "$TARGET_PATH" ]; then
	warm_log_info "Not Find File :: $TARGET_PATH"
	return 0
	fi
	return 1
}

___qb_draw_logo() {
	local ___qb_var_art_path="$HOME/.qb/art"
	printf "$(cat "$___qb_var_art_path")\n"
}