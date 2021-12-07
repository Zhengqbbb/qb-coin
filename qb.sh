# shellcheck shell=sh disable=SC3043
# A fast and simple terminal plugin that can watch your BSC price in the terminal.
# https://github.com/Zhengqbbb/qb
# v1.0.0-beta1
# Copyright (c) 2021 Zhengqbbb
# License: MIT License

xrc param/v0
xrc ui
. $HOME/.qb/tool.sh

qb(){
    param:dsl <<A
subcommands:
    ls          "list all your coins"
    add         "add coin address in your coins list"
    del         "delete coin in your coins list"
    timer       "change the refresh timer"
    proxy       "edit the address to use socket5 proxy"
A
    param:run

    if [ "$PARAM_SUBCMD" = "help" ]; then
        qb _param_help_doc
        return 0
    fi

    local qb_source_path="$HOME/.qb"
    local qb_data
    local coin_list
    local coin_list_length=0
    qb_data="$(cat "$qb_source_path/data.json")"
    coin_list="$(printf "%s" "$qb_data" | x jq ".coins")"
    coin_list_length="$(printf "%s" "$coin_list" | x jq "length")"

    if [ -z "$PARAM_SUBCMD" ]; then
        ___qb_control_run
        return 0
    fi
    "___qb_control_${PARAM_SUBCMD}" "$@"
}

###
    # @use: `qb ls`
    # @description: list all your coins
    # use jq but it feel slowly
###
___qb_control_ls() {
    local i=0
    ___qb_printf_line
    if [ -z "$coin_list_length" ] || [ "$coin_list_length" -eq 0 ]; then
        ___qb_info_log_info 'Empty data list'
    fi
    while [ $i -lt "$coin_list_length" ]; do
        printf "%-10s  %-40s %s\n" \
            "$(ui bold yellow "${i} ➜")" \
            "$(___qb_printf_key_value 'Name' "$(printf "%s" "$coin_list" | x jq -r ".[${i}].name")")" \
            "$(ui bold yellow "➜") $(___qb_printf_key_value 'Address' "$(printf "%s" "$coin_list" | x jq -r ".[${i}].address")")"
        i=$((i+1))
    done
    ___qb_printf_line
    unset i
}

###
    # @use: `qb add`
    # @description: add coin address in your coins list
###
___qb_control_add() {
    local _address
    local _data
    local _name
    ui prompt "$(ui bold green 'Enter BSC coin address')" _address
    if [ -z "$_address" ];then
        ___qb_error_log_info "Empty data"
        return 1
    fi
    ___qb_info_log_info "Loading coin data..."
    ______qb_control_use_proxy
    _data="$(curl --connect-timeout 8 -m 15 https://api.pancakeswap.info/api/v2/tokens/"$_address" 2>/dev/null)" 2>/dev/null
    _name="$(printf "%s" "$_data" | x jq -r ".data.symbol")"
    if [ -z "$_data" ] || [ "$_name" = "null" ];then
        ___qb_printf_net_warm "https://api.pancakeswap.info/api/v2/tokens/${_address}"
        return 1
    fi
    local _item
    local _coins
    _item=$(printf "%s" "[{\"name\": \"${_name}\",\"address\": \"${_address}\"}]")
    _coins=$(printf "$qb_data" | x jq ".coins + $_item")
    qb_data=$(printf "$qb_data" | x jq ".coins = $_coins")
    printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    ___qb_success_log_info "$(ui bold yellow "$_name"), add coin list successfully"
    qb ls
    unset _address _data _name _item _coins
}

___qb_control_del() {
    ___qb_control_ls
    local _index
    local _has_data
    local _name
    local _is_sure
    if [ -z "$coin_list_length" ] || [ "$coin_list_length" -eq 0 ]; then
        ___qb_info_log_info 'Empty data list'
        return 1
    fi
    ui prompt "$(ui bold green 'Enter the index of the list you want to delete')" _index "=~" "[0-9]*"
    [ "$coin_list_length" -gt "$_index" ] && _has_data='true'
    if [ -z $_has_data ];then
        ___qb_error_log_info "Error Index: $_index"
        return 1
    fi
    _name="$(printf "%s" "$coin_list" | x jq -r ".[${_index}].name")"
    ui prompt "Are you sure you want to delete $(ui bold yellow "$_name") (y/n)" _is_sure
    if [ -n "$_is_sure" ] && [ "$_is_sure" != 'y' ];then
        return 1
    fi
    qb_data="$(printf "%s" "$qb_data" | x jq "del(.coins[$_index])")"
    ___qb_success_log_info "Successfully deleted $(ui bold yellow "$_name") $(ui bold green 'in your list')"
    printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    unset _index _has_data _name _is_sure
    return 0
}

___qb_control_timer() {
    local _timer
    local _has_timer
    _has_timer="$(printf "%s" "$qb_data" | x jq 'has("timer")')"
    [ "$_has_timer" = 'true' ] && _timer="$(printf "%s" "$qb_data" | x jq ".timer")" && ___qb_info_log_info "Your refresh timer is $_timer s"
    ui prompt "$(ui bold green 'Enter the set refresh timer(s)')" _timer "=~" "[0-9]*"
    qb_data="$(printf "%s" "$qb_data" | x jq ".timer=$_timer")"
    printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    ___qb_success_log_info "Your refresh timer(s) is setted: $(ui bold yellow "${_timer}")"
    unset _timer
    return 0
}

###
    # @description: reset socket5 proxy in terminal.
    # @example: socks5://127.0.0.1:1086
    # Not only your local, you can also use your local area network, such as wifi: socks5://192.168.31.1:1086
###
___qb_control_proxy() {
    local _has_host
    local _host
    local _port
    local _address
    _has_host="$(printf "%s" "$qb_data" | x jq '.proxy' | x jq 'has("host")')"
    _host="$(printf "%s" "$qb_data" | x jq -r '.proxy.host')"
    if [ "$_has_host" = 'true' ] && [ "$_host" != 'unset' ];then
        _address="socks5://$(printf "%s" "$qb_data" | x jq -r '.proxy.host'):$(printf "%s" "$qb_data" | x jq -r '.proxy.port')"
        ___qb_info_log_info "Your socket5 proxy address is $(ui underline bold yellow "$_address")"
    fi
    ui prompt "$(ui bold green 'Enter the host of the proxy.Such as ')$(ui bold underline yellow '127.0.0.1')" _host
    ui prompt "$(ui bold green 'Enter the port of the proxy.Such as ')$(ui bold underline yellow '1086')" _port
    if [ -z "$_host" ] && [ -z "$_port" ];then
        qb_data="$(printf "%s" "$qb_data" | x jq '.proxy.host="unset"' | x jq '.proxy.port="unset"')"
        printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
        export ALL_PROXY=
        ___qb_success_log_info "Your socket5 proxy proxy has been $(ui bold cyan 'cancelled')"
        return 0
    fi
    _address="socks5://$_host:$_port"
    _host="\"$_host\""
    _port="\"$_port\""
    qb_data="$(printf "%s" "$qb_data" | x jq ".proxy.host=$_host" | x jq ".proxy.port=$_port")"
    printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    ___qb_success_log_info "Your socket5 proxy address is setted: $(ui bold underline yellow "${_address}")"
    unset _has_host _host _port _address
    return 0
}

###
    # @description: use socket5 proxy in terminal.Can be in bash and zsh
###
______qb_control_use_proxy() {
    local _host
    local _port
    _host="$(printf "%s" "$qb_data" | x jq -r ".proxy.host")"
    _port="$(printf "%s" "$qb_data" | x jq -r ".proxy.port")"
   
    if  [ "${_host}" = 'unset' ] && [ "${_port}" = 'unset' ]; then
        [ -n "$ALL_PROXY" ] && export ALL_PROXY=
    elif [ -n "$_host" ] && [ "${_host}" != 'null' ];then
        export ALL_PROXY=socks5://"${_host}":"${_port}"
    fi
    unset _host _port
}

###
    # @use: `qb`
    # @description: show the BSC coins price
###
___qb_control_run() {
    local i
    local _timer
    ___qb_draw_logo
    _timer="$(printf "%s" "$qb_data" | x jq -r ".timer")"
    [ "$_timer" = 'null' ] && _timer=10
    ______qb_control_use_proxy

    ___qb_printf_line
    if [ -z "$coin_list_length" ] || [ "$coin_list_length" -eq 0 ]; then
        ___qb_info_log_info 'Empty data list'
        ___qb_printf_line
        return 1
    fi

    while true; do
        i=0
        while [ $i -lt "$coin_list_length" ]; do
            local _address
            local _name
            local _data
            local _usdt_price
            local _time
            _address="$(printf "%s" "$coin_list" | x jq -r ".[${i}].address")"
            _name="$(printf "%s" "$coin_list" | x jq -r ".[${i}].name")"
            _data="$(curl --connect-timeout 8 -m 15 https://api.pancakeswap.info/api/v2/tokens/"$_address" 2>/dev/null)" 2>/dev/null
            _usdt_price=$(printf "%s" "$_data" | x jq ".data.price" 2>/dev/null)
            _time="$(date +%H:%M:%S)"
            if [ -z "$_data" ] || [ -z "$_usdt_price" ] || [ "$_usdt_price" = 'null' ];then
                ___qb_printf_net_warm "https://api.pancakeswap.info/api/v2/tokens/${_address}"
                break
            fi
            printf "%s %-17s %s\n" \
                "$(ui bold cyan "[$_time]")" \
                "$(ui bold yellow "$_name")" \
                "$(ui bold yellow 'USDT price:') $(ui bold green "$_usdt_price")"
            i=$((i+1))
            unset _address _name _data _usdt_price _time
        done
        ___qb_printf_line
        sleep "$_timer"
    done
}