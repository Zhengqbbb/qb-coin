# shellcheck shell=sh disable=SC3043
# A fast and simple terminal plugin that can watch your BSC price in the terminal.
# https://github.com/Zhengqbbb/qb
# v1.0.0-beta1
# Copyright (c) 2021 Zhengqbbb
# License: MIT License

xrc param/v0
. $HOME/.qb/tool.sh

qb(){
    param:dsl <<A
subcommands:
    ls          "list all your coins"
    add         "add coin address in your coins list"
    star        "put the selected coin on top"
    del         "delete coin in your coins list"
    timer       "change the refresh timer"
    proxy       "edit the address to use socket5 proxy"
A
    param:run
    xrc ui
    xrc json
    if [ "$PARAM_SUBCMD" = "help" ]; then
        qb _param_help_doc
        return 0
    fi

    local qb_source_path="$HOME/.qb"
    local qb_data
    local coin_list
    local coin_list_length=0
    qb_data="$(cat "$qb_source_path/data.json")"
    if [ -z "$qb_data" ] ; then
        ___qb_error_log_info "Empty source file: $qb_source_path/data.json"
        return 1
    fi
    coin_list="$(json query qb_data.coins)"
    coin_list_length="$(json length coin_list)"
    if [ -z "$PARAM_SUBCMD" ]; then
        ___qb_control_run
        return 0
    fi
    "___qb_control_${PARAM_SUBCMD}" "$@"
}

___qb_json_unquote() { local _qb_handed="$1"; _qb_handed="${_qb_handed#*\"}"; printf "%s" "${_qb_handed%\"*}";}
___qb_control_ls() {
    local i=0
    ___qb_printf_line
    if [ -z "$coin_list_length" ] || [ "$coin_list_length" -eq 0 ]; then
        ___qb_info_log_info 'Empty data list'
    fi
    while [ $i -lt "$coin_list_length" ]; do
        printf "%-10s  %-40s %s\n" \
            "$(ui bold yellow "$((i+1)) ➜")" \
            "$(___qb_printf_key_value 'Name' "$(json query coin_list.\[${i}\].name)")" \
            "$(ui bold yellow "➜") $(___qb_printf_key_value 'Address' "$(json query coin_list.\[${i}\].address)")"
        i=$((i+1))
    done
    ___qb_printf_line
    unset i
}

___qb_control_add() {
    local _coin_address
    local _data
    local _name
    ui prompt "$(ui bold green 'Enter BSC coin address')" _coin_address
    if [ -z "$_coin_address" ];then
        ___qb_error_log_info "Empty data"
        return 1
    fi
    ___qb_info_log_info "Loading coin data..."
    ______qb_control_use_proxy
    _data="$(curl --connect-timeout 10 -m 18 https://api.pancakeswap.info/api/v2/tokens/"$_coin_address" 2>/dev/null)" 2>/dev/null
    _name=$(json q _data.data.symbol 2>/dev/null)
    if [ -z "$_data" ] || [ -z "$_name" ];then
        ___qb_printf_net_warm "https://api.pancakeswap.info/api/v2/tokens/${_coin_address}"
        return 1
    fi
    local _item
    _item=$(printf "%s" "{\"name\": ${_name},\"address\": \"${_coin_address}\"}")
    json push qb_data.coins "$_item"
    printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    ___qb_success_log_info "$(ui bold yellow "$_name"), add coin list successfully"
    qb ls
    unset _coin_address _data _name _item
}
______qb_control_list_by_index() {
    ___qb_control_ls
    local _index
    local _has_data
    local _name
    local _is_sure
    local _item
    
    if [ -z "$coin_list_length" ] || [ "$coin_list_length" -eq 0 ]; then
        ___qb_info_log_info 'Empty data list'
        return 1
    fi
    ui prompt "$(ui bold green "Enter the index of the list you want to $1")" _index "=~" "[0-9]*"
    _index=$((_index-1))
    [ "$coin_list_length" -gt "$_index" ] && _has_data='true'
    if [ -z $_has_data ];then
        ___qb_error_log_info "Error Index: $((_index+1))"
        return 1
    fi
    _name="$(json q coin_list.\[${_index}\].name)"
    if [ "$1" = 'delete' ]; then
        ui prompt "Are you sure you want to $1 $(ui bold yellow "$_name") (y/n)" _is_sure
        if [ -n "$_is_sure" ] && [ "$_is_sure" != 'y' ];then
            return 1
        fi
        qb_data=$(json del qb_data.coins.\[${_index}\])
        ___qb_success_log_info "Successfully deleted $(ui bold yellow "$_name") $(ui bold green 'in your list')"
        printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    else
        _item="$(json q coin_list.\[${_index}\])"
        qb_data=$(json del qb_data.coins.\[${_index}\])
        json prepend qb_data.coins "$_item"
        ___qb_success_log_info "Successfully star $(ui bold yellow "$_name") $(ui bold green 'in your list')"
        printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    fi
    unset _index _has_data _name _is_sure _item
    return 0
}

___qb_control_star() {
    ______qb_control_list_by_index 'star'
}

___qb_control_del() {
     ______qb_control_list_by_index 'delete'
}

___qb_control_timer() {
    local _timer
    _timer="$(___qb_json_unquote "$(json q qb_data.timer)")"
    [ -n "$_timer" ] && ___qb_info_log_info "Your refresh timer is $_timer s"
    ui prompt "$(ui bold green 'Enter the set refresh timer(s)')" _timer "=~" "[0-9]*"
    json put qb_data.timer "${_timer}" > /dev/null
    printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    ___qb_success_log_info "Your refresh timer(s) is setted: $(ui bold yellow "${_timer}")"
    unset _timer
    return 0
}

___qb_control_proxy() {
    local _host
    local _port
    local _address
    _host="$(___qb_json_unquote "$(json q qb_data.proxy.host)")"
    if [ -n "$_host" ] && [ "$_host" != 'unset' ] && [ "$_host" != 'default' ];then
        _host=$(___qb_json_unquote "$_host")
        _port=$(___qb_json_unquote "$(json q qb_data.proxy.port)")
        _address="socks5://$_host:$_port"
        ___qb_info_log_info "Your socket5 proxy address is $(ui underline bold yellow "$_address")"
    fi
    ui prompt "$(ui bold green 'Enter the host of the proxy.Such as ')$(ui bold underline yellow '127.0.0.1')" _host
    ui prompt "$(ui bold green 'Enter the port of the proxy.Such as ')$(ui bold underline yellow '1086')" _port
    if [ -z "$_host" ] && [ -z "$_port" ];then
        json put qb_data.proxy.host 'unset' > /dev/null
        json put qb_data.proxy.port 'unset' > /dev/null
        printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
        export ALL_PROXY=
        export all_proxy=
        ___qb_success_log_info "Your socket5 proxy proxy has been $(ui bold cyan 'cancelled')"
        return 0
    fi
    _address="socks5://$_host:$_port"
    json put qb_data.proxy.host "$_host" > /dev/null
    json put qb_data.proxy.port "$_port" > /dev/null
    printf "%s\n" "$qb_data" > "$qb_source_path/data.json"
    ___qb_success_log_info "Your socket5 proxy address is setted: $(ui bold underline yellow "${_address}")"
    unset _has_host _host _port _address
    return 0
}

______qb_control_use_proxy() {
    local _host
    local _port
    _host=$(___qb_json_unquote "$(json q qb_data.proxy.host)")
    _port=$(___qb_json_unquote "$(json q qb_data.proxy.port)")
   
    if  [ "${_host}" = 'unset' ] && [ "${_port}" = 'unset' ]; then
        { [ -n "$ALL_PROXY" ] || [ -n "$all_proxy" ] ; } && export ALL_PROXY= && export all_proxy=
        return 0
    elif [ -n "$_host" ] && [ "${_host}" != 'default' ];then
        export ALL_PROXY=socks5://"${_host}":"${_port}"
        export all_proxy=socks5://"${_host}":"${_port}"
    fi
    unset _host _port
}

___qb_control_run() {
    local i
    local _timer
    ___qb_draw_logo
    _timer=$(___qb_json_unquote "$(json q qb_data.timer)")
    [ -z "$_timer" ] && _timer=10
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
            _address=$(___qb_json_unquote "$(json q qb_data.coins.\[${i}\].address)")
            _name=$(___qb_json_unquote "$(json q qb_data.coins.\[${i}\].name)")
            _data="$(curl --connect-timeout 8 -m 15 https://api.pancakeswap.info/api/v2/tokens/"$_address" 2>/dev/null)" 2>/dev/null
            [ -n "$_data" ] && _usdt_price=$(___qb_json_unquote "$(json q _data.data.price)")
            _time="$(date +%H:%M:%S)"
            if [ -z "$_data" ] || [ -z "$_usdt_price" ];then
                ___qb_printf_net_warm "https://api.pancakeswap.info/api/v2/tokens/${_address}"
                unset _address _name _data _usdt_price _time
                break
            fi
            [ -n "$_usdt_price" ] && printf "%s %-17s %s %s\n" \
                "$(ui bold cyan "[$_time]")" \
                "$(ui bold yellow "$_name")" \
                "$(ui bold cyan "➜")" \
                "$(ui bold yellow 'USDT price:') $(ui bold green "$_usdt_price")"
            i=$((i+1))
            unset _address _name _data _usdt_price _time
        done
        ___qb_printf_line
        sleep "$_timer"
    done
}

if [ -n "${BASH_VERSION}${ZSH_VERSION}" ] && [ "${-#*i}" != "$-" ]; then
    xrc advise
    advise qb - <<A
{
    "ls": null,
    "add": null,
    "star": null,
    "del": null,
    "timer": null,
    "proxy": null,
    "help": null
}
A
fi