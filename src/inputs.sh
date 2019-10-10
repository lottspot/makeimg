img_dir_base=
img_dir_base_default="./img"
cfg_subpath=".config/makeimg.conf"

load_cfg()
{
  local user_home=
  if [ "$SUDO_USER" ]; then
    user_home="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
  else
    user_home="$HOME"
  fi

  local cfg_path="$user_home/$cfg_subpath"
  if [ -e "$cfg_path" ]; then
    . "$cfg_path"
  fi
}

parse_args()
{
    local arg=$1
    test -z "$img_dir_base" || return 0
    img_dir_base=$img_dir_base_default
    test "$arg" || return 0
    img_dir_base=$arg
}

validate_env(){
    test -n "$img_name"    || fatal "missing required directive: img_name"
    declare -f do_install  || fatal "image.sh must define a do_install hook"
}
