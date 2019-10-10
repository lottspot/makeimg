img_path=
img_dir=
src_dir=

# prepare the image installation environment
prepare()
{
    img_path=$img_dir_base/$img_name
    img_dir=${img_path%.tar*}
    src_dir=$(pwd)
    test -e "$img_dir" || mkdir -p "$img_dir" || error "failred to create directory: $img_dir"
    test -e "$src_dir"     || fatal "src_dir does not exist: $src_dir (this is most likely a bug)"
}

# execute a user defined hook
run_hook()
{
    local stage=$1
    local hook_name=do_$stage
    declare -f $hook_name >/dev/null || return 0
    ok "enter hook: $stage"
    stderr_show
    (
        set -e
        eval "$hook_name"
    ) || { error "hook failed: $hook_name"; return 1; }
    stderr_hide
    ok "exit hook: $stage"
    return 0
}

# execute a user defined hook inside a systemd-nspawn jail
run_hook_nspawn()
{
    local stage=$1
    local hook_name=do_$stage
    declare -f $hook_name >/dev/null || return 0
    ok "enter hook: $stage"
    stderr_show
    if systemd-nspawn -D $img_dir /bin/bash -c "set -e; $(declare -f $hook_name); $hook_name"; then
        stderr_hide
        ok "exit hook: $stage"
        return 0
    else
        error "hook failed: $stage"
    fi
}

# copy user defined sets of files
run_files()
{
    local stage=$1
    eval "local src=(\${${stage}_files_src[@]})"
    eval "local dst=(\${${stage}_files_dst[@]})"
    test "${#src[@]}" -gt 0 || return 0
    ok "copy $stage files"
    for (( i=0; i<${#src[@]}; i++ )); do
        srcpath=$src_dir/${src[i]}
        dstpath=$img_dir/${dst[i]}
        dstdir=$(dirname "$dstpath")
        test -e "$dstdir" || mkdir -p "$dstdir" || { error "unable to create directory: $dstdir"; return 1; }
        info "+ cp -r $srcpath $dstpath"
        stderr_show
        cp -r "$srcpath" "$dstpath" || { error "copy failed"; return 1; }
        stderr_hide
    done
    ok "$stage files copied"
    return 0
}

archive()
(
    arc_name=$img_dir.tar
    ok "begin archive"
    stderr_show
    tar -C "$img_dir" -cpf "$arc_name" . || { error "failed to archive"; return 1; }
    case $img_path in
        *.gz)
            info "compressing to path $img_path"
            gzip -c "$arc_name" > "$img_path" || { error "failed to compress"; return 1; }
            rm "$arc_name"
            ;;
        *.bz2)
            info "comrpessing to path $img_path"
            bzip2 -zc "$arc_name" > "$img_path" || { error "failed to compress"; return 1; }
            rm "$arc_name"
            ;;
        *.xz)
            info "compressing to path $img_path"
            xz -zcT0 "$arc_name" > "$img_path" || { error "failed to compress"; return 1; }
            rm "$arc_name"
            ;;
        *.tar)
            test "$arc_name" = "$img_path" || mv "$arc_name" "$img_path" || { error "failed to write image to destination path"; return 1; }
            ;;
    esac
    rm -rf "$img_dir"
    stderr_hide
    ok "image archived to $img_path"
    return 0
)
