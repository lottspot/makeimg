img_name=arch-$(date +%Y.%m.%d).tar.xz
img_cmd="pacstrap $img_dir ${img_pkgs[@]}"

img_pkgs=(
    base
    networkmanager
    openssh
    sudo
)

postinstall_files_src=(
    admin-sudoers
    authorized_keys
)

postinstall_files_dst=(
    /etc/sudoers.d/admin
    /opt/authorized_keys
)

# Will run inside image via systemd-nspawn
do_postinstall(){
    systemctl enable NetworkManager
    systemctl enable sshd
    useradd -Umd /home/admin -s /bin/bash admin
    mkdir -m 0700 /home/admin/.ssh
    mv /opt/authorized_keys /home/admin/.ssh/authorized_keys
    chown -R admin: /home/admin/.ssh
        cat <<EOF > /etc/NetworkManager/system-connections/System-Ethernet
[connection]
id='System ethernet'
uuid=$(uuidgen)
type=ethernet

[ipv4]
method=auto

[ipv6]
method=auto
EOF
}
