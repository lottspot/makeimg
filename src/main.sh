set -e

main()
{
    init_vars
    load_cfg         || fatal "failed to load config"
    load_args "$@"   || fatal "invalid arguments"

    validate_hostenv
    confine validate_imagesh  || fatal "invalid image.sh"

    # systemd-nspawn will print \r characters we don't want eval'd
    eval "$(confine get_img_paths | tr -d '\r')" || fatal "failed to resolve image paths"
    validate_img_paths

    # prepare img_dir
    prepare || fatal "failed to prepare build environment"

    # preinstall stage
    confine -w "$img_dir" run_files 'preinstall' || fatal "stage: preinstall"

    # install stage
    confine -w "$img_dir" run_hook 'install' || fatal "stage: install"

    # postinstall stage
    confine -w "$img_dir" run_files 'postinstall'       || fatal "stage: postinstall"
    run_hook_nspawn 'postinstall' || fatal "stage: postinstall"

    # archive resulting image
    if [[ $img_path =~ .*\.tar(\.(gz|xz|bz2))?$ ]]; then
        confine -w "$img_dir_base" archive
    else
        ok "image built at $img_dir"
    fi
}

main "$@"
