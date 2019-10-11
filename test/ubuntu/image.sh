img_suite=bionic
img_mirror=http://archive.ubuntu.com/ubuntu/
img_name=ubuntu-$img_suite

do_install()
{
  debootstrap $img_suite "$img_dir/" $img_mirror
}
