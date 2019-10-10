cmd_deps=(
    cd
    type
    id
    pwd
    mkdir
    cp
    basename
    dirname
    systemd-nspawn
    tar
    gzip
    bzip2
    xz
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