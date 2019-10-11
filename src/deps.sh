cmd_deps=(
    type
    cd
    id
    pwd
    mkdir
    cp
    tr
    cut
    grep
    basename
    dirname
    getent
    systemd-nspawn
    tar
    gzip
    bzip2
    xz
    realpath
)

have_cmd()
{
    local cmd=$1
    type $cmd >/dev/null
    return $?
}

for dep in ${cmd_deps[@]}; do
  if ! have_cmd $dep; then
    fatal "missing required command: $dep"
  fi
done
