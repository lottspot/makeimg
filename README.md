# makeimg

makeimg is a utility to simplify building rootfs images
from scratch. It was designed with systemd-machined in mind,
but should also work well for creating base images
for use with tools like buildah or docker.

makeimg requires root privileges, systemd-nspawn, and the
bootstrapping tool of your choice (e.g., `pacstrap` for
arch images, `dnf` for Fedora/CentOS, `debootstrap` for Debian/Ubuntu, etc.).

## Quick start

```
cat <<EOF > image.sh
img_name=myimage.tar.gz

do_install()
{
    for dir in bin lib etc var; do
        mkdir $img_dir/$dir
        touch $img_dir/$dir/.keep
    done
}
EOF
makeimg  # must be executed as root
```

Usage: `makeimg [img_dir_base]`

If no `img_dir_base` is passed, makeimg will default to the path `./img`.
The `img_dir_base` parameter can also be added to the config file ~/.config/makeimg.conf

For more concrete examples of image.sh files, check out the [test](./test) directory.

## Paths

There are three specific paths makeimg will generate from user inputs
and expose to builds:

- `$src_dir`: Absolute path to the directory containing the invoked image.sh
- `$img_dir`: Directory which the image rootfs should be installed into
- `$img_path`: Path to the finalized image file after archiving and compression`

## image.sh

makeimg must be invoked inside of a project directory, which is any
directory containing an image.sh. This directory will then be set to `$src_dir`
for the build process. For an example, see [test/arch/image.sh](./test/arch/image.sh).

Required variables:

- `img_name`: The filename of the final system image

Required hooks:

- `do_install()`


## Stages

The image build happens in stages which the user can inject hooks and data
into.

### preinstall

The preinstall stage happens after the build directory has been created,
but before the install command has been invoked. This should be used to
copy files into place which may be needed during rootfs installation.
The preinstall stage is for copying files only; there are no hooks.

Variables:

- `preinstall_files_src`: an array of files (relative to `$src_dir`)
 which should be copied into `$img_dir`.
- `preinstall_files_dst`: an array of paths (relative to `$img_dir`)
 which are the destination paths for source files. The order of this
 array corresponds to the order of `preinstall_files_src`.

### install

The install stage is intended for running any commands needed to install
a root filesystem into `$img_dir`. It consists only of the `do_install()`
hook.

### postinstall

The postinstall staged is intended for making final modifications to the
installed system. The postinstall stage both performs file copying and
runs a special hook. Files are copied before the hook is executed.

Variables & hooks:

- `postinstall_files_src`: Like `preinstall_files_src`, but for the
 postinstall stage
- `postinstall_files_dst`: Like `preinstall_files_dst`, but for the
 postinstall stage
- `do_postinstall()`: A special hook which is run jailed inside of
 the new rootfs. It is run in a systemd-nspawn container, enabling it to
 do things like enable system services, but it has no access to the build
 environment, so cannot use variables like `$src_dir` or `$img_dir`.

## Installing makeimg

After a recursive clone, simply execute the `make` command in the project root.

```
make
mv makeimg /usr/local/sbin
```

## Confinement

All build stages are run in a confined systemd-nspawn container. within
this container, the only non-volatile writable location is `$img_dir`.
The `$src_dir` directory is also mounted in as a read-only location.
This isolation makes it safe for the build process to run with root privileges,
but as a trade off, results in certain restrictive behaviors (such as the inability to refer
to filesystem paths outside of `$srcdir` during builds)
