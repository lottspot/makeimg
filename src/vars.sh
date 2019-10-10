img_dir_base=
img_dir=
img_path=
src_dir=

SCRIPT=$(basename "$0")

init_vars()
{
  img_dir_base="./img"
  src_dir=$(pwd)
}

load_cfg()
{
  local user_home=
  local cfg_subpath=".config/$SCRIPT.conf"
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

load_args()
{
    local arg=$1
    test "$arg" || return 0
    img_dir_base=$arg
}

get_img_paths()
{
    img_path=$img_dir_base/$img_name
    img_dir=${img_path%.tar*}
    printf 'img_path="%s"\n' "$img_path"
    printf 'img_dir="%s"\n' "$img_dir"
}
