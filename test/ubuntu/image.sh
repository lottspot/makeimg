img_suite=bionic
img_mirror=http://archive.ubuntu.com/ubuntu/
img_name=ubuntu-$img_suite

do_install()
{
  debootstrap --force-check-gpg --keyring keyrings/ubuntu-archive-keyring.gpg $img_suite "$img_dir/" $img_mirror
}
