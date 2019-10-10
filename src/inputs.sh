img_dir_parent=
img_dir_parent_default="./img"

parse_args()
{
    local arg=$1
    img_dir_parent=$img_dir_parent_default
    test -n "$arg" || return 0
    img_dir_parent=$arg
}
