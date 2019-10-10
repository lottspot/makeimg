line_prefix=$(print_color -bc white "=>")

info()
{
    printf '%s %s\n' $line_prefix "$(print_color -c white "$@")"
}

ok()
{
    printf '%s %s\n' $line_prefix "$(print_color -c green "$@")"
}

error()
{
    local msg=$(printf '%s %s %s\n' $line_prefix "$(print_color -bc red error:)" "$(print_color -c red "$@")")
    print_e "$msg"
}

fatal()
{
    local msg=$(printf '%s %s %s\n' $line_prefix "$(print_color -bc red fatal:)" "$(print_color -bc red "$@")")
    print_e "$msg"
    exit 1
}
