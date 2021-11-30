# shellcheck shell=sh disable=SC3043

xrc param/v0
. $HOME/.qb/tool.sh

qb(){
    param:dsl <<A
subcommands:
    ls          "list all your coins"
    add         "add coin address in your coins list"
    del         "delete coin in your coins list"
    time        "change the refresh time"
    proxy       "edit the address to use socket5 proxy"
A
    param:run

    if [ "$PARAM_SUBCMD" = "help" ]; then
        qb _param_help_doc
        return 0
    fi
    if [ -z "$PARAM_SUBCMD" ]; then
        ___qb_control_run
        return 0
    fi

    "___qb_control_${PARAM_SUBCMD}" "$@"
}

___qb_control_ls() {
    echo ls
    return 0
}

___qb_control_add() {
    echo add
    return 0
}

___qb_control_del() {
    echo del
    return 0
}

___qb_control_time() {
    echo 'time'
    return 0
}

___qb_control_proxy() {
    echo proxy
    return 0
}

___qb_control_run() {
    echo run
    return 0
}