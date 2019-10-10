confine()
{

    bindarg=
    local OPTIND=1
    if getopts ':w:' arg "$@" && [ "$arg" = 'w' ]; then
        local bindarg="--bind=$OPTARG"
    fi
    shift $((OPTIND-1))

    local args=(
        --quiet
        --volatile
        --directory  /
        --bind-ro    /etc
        --bind-ro    "$src_dir"
        --chdir      "$src_dir"
    )
    test -z "$bindarg" || args+=("$bindarg")

    local preload="
        $(set | grep -vE '^BASH|E?UID|PPID|SHELLOPTS')
        set -e
        . image.sh"

    systemd-nspawn "${args[@]}" -- /bin/bash -c "$preload;$*"
}
