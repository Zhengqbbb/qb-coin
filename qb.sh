# shellcheck shell=sh disable=SC3043

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
    if [ "$coin_list_length" -eq 0 ]; then
        ___qb_info_log_info 'Empty data list'
    fi
    while [ $i -lt "${coin_list_length}" ]; do
        printf "%-10s  %-40s %s\n" \
            "$(ui bold yellow "${i} ➜")" \
            "$(___qb_printf_key_value 'Name' "$(printf "%s" "$coin_list" | x jq -r ".[${i}].name")")" \
            "$(___qb_printf_key_value 'Address' "$(printf "%s" "$coin_list" | x jq -r ".[${i}].address")")"
        i=$((i+1))
    done
    ___qb_printf_line
}

###
    # @use: `qb add`
    # @description: add coin address in your coins list
###
___qb_control_add() {
    local _address
    local _data
    local _name
    read -p "$(ui bold green 'Print BSC coin address') $(ui bold yellow '➜') " _address
    if [ -z "$_address" ];then
        ___qb_error_log_info "Empty data"
        return 1
    fi
    ___qb_info_log_info "Loading coin data..."
    ______qb_control_use_proxy
    _data="$(curl https://api.pancakeswap.info/api/v2/tokens/"$_address" 2>/dev/null)" 2>/dev/null
    _name="$(printf "%s" "$_data" | x jq -r ".data.symbol")"
    if [ -z "$_data" ] || [ -z "$_name" ];then
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
}

___qb_control_del() {
    ___qb_control_ls
    return 0
}

___qb_control_timer() {
    echo 'time'
    return 0
}

###
    # @description: reset socket5 proxy in terminal.
    # @example: socks5://127.0.0.1:1086
    # Not only your local, you can also use your local area network, such as wifi: socks5://192.168.31.1:1086
###
___qb_control_proxy() {
    echo 'proxy'
    return 0
}

###
    # @description: use socket5 proxy in terminal.Can be in bash and zsh
###
______qb_control_use_proxy() {
    local _address
    local _port
    _address="$(printf "%s" "$qb_data" | x jq -r ".proxy.address")"
    _port="$(printf "%s" "$qb_data" | x jq -r ".proxy.port")"
    if [ "$_address" != 'null' ]; then
        export ALL_PROXY=socks5://"${_address}":"${_port}"
    fi
    unset _address _port
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
    ______qb_control_use_proxy

    ___qb_printf_line
    if [ "$coin_list_length" -eq 0 ]; then
        ___qb_info_log_info 'Empty data list'
        ___qb_printf_line
        return 1
    fi

    while true; do
        i=0
        while [ $i -lt "${coin_list_length}" ]; do
            local _address
            local _name
            local _data
            local _usdt_price
            local _time
            _address="$(printf "%s" "$coin_list" | x jq -r ".[${i}].address")"
            _name="$(printf "%s" "$coin_list" | x jq -r ".[${i}].name")"
            _data="$(curl https://api.pancakeswap.info/api/v2/tokens/"$_address" 2>/dev/null)" 2>/dev/null
            _usdt_price=$(printf "%s" "$_data" | x jq ".data.price")
            _time="$(date +%H:%M:%S)"
            if [ -z "$_data" ] || [ -z "$_usdt_price" ];then
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