img_dir_parent=
img_dir_parent_default="./img"

parse_args()
{
    local arg=$1
    img_dir_parent=$img_dir_parent_default
    test -n "$arg" || return 0
    img_dir_parent=$arg
}

validate_env(){
    test -n "$img_name"    || fatal "missing required directive: img_name"
    declare -f do_install  || fatal "image.sh must define a do_install hook"
}
