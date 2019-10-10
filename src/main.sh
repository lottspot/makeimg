set -e

main()
{
    SCRIPT=$(basename "$0")
    test "$(id -u)" -eq 0 || fatal "$SCRIPT must be run as root"
    stderr_hide
    parse_args "$@" || fatal "invalid arguments"

    (
        # load image.sh
        stderr_show
        . image.sh
        stderr_hide
        validate_env    || fatal "invalid build environment"
        prepare         || fatal "failed to prepare build environment"
        . image.sh  # allow image.sh to resolve prepared variables

        # preinstall stage
        run_files 'preinstall' || fatal "stage: preinstall"
        run_hook  'preinstall' || fatal "stage: preinstall"

        # install stage
        install || fatal "stage: install"

        # postinstall stage
        run_files 'postinstall'       || fatal "stage: postinstall"
        run_hook_nspawn 'postinstall' || fatal "stage: postinstall"

        # archive resulting image
        if [[ $img_path =~ .*\.tar(\.(gz|xz|bz2))?$ ]]; then
            archive
        else
            ok "image built at $img_dir"
        fi
    )
}

main "$@"
