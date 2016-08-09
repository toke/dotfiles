function osum () {
    : ${1?Use a subcommand, try: osum help}

    echo "$@" | nc osum-home-master.server.lan 18140
}
