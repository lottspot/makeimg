img_releasever=8
img_name=centos-$img_releasever

do_install()
{
  export DNF_VAR_SRC_DIR=$src_dir
  dnf -y -c dnf.conf --installroot "$img_dir/" --releasever "$img_releasever" group install core
}
