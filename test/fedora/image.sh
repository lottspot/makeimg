img_releasever=30
img_name=fedora-$img_releasever

do_install()
{
  export DNF_VAR_SRC_DIR=$src_dir
  dnf -y -c dnf.conf --installroot "$img_dir/" --releasever "$img_releasever" group install core
}
