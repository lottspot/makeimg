validate_hostenv()
{
    test "$(id -u)" -eq 0   || fatal "$SCRIPT must be run as root"
    test -e "$src_dir"      || fatal "BUG: src_dir does not exist: $src_dir"
    test -e image.sh        || fatal "image.sh not found"
}

validate_img_paths()
{
    test ! -e "$img_path"  || fatal "refusing to overwrite existing img_path: $img_path"
    test ! -e "$img_dir"   || fatal "refusing to overwrite existing imd_dir: $img_dir"
}

validate_imagesh()
{
    test    -n "$img_name" || error "missing required directive: img_name"
    declare -f do_install  || error "image.sh must define a do_install hook"
}
