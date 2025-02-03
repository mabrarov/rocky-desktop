#!/bin/bash -eux

echo "==> Installing kernel headers: $(uname -r)"
dnf install -y epel-release
dnf update -y --refresh --exclude=kernel*
dnf install -y dkms "kernel-devel-$(uname -r)" "kernel-headers-$(uname -r)" gcc make bzip2 perl elfutils-libelf-devel

echo "==> Installing VirtualBox guest additions"
ssh_user_home="/home/${SSH_USER}"
mount -o loop "${ssh_user_home}/VBoxGuestAdditions.iso" /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf "${ssh_user_home}/VBoxGuestAdditions.iso"

if [[ -n "${VBOXSF_USER}" ]]; then
  echo "==> Adding ${VBOXSF_USER} user into vboxsf group"
  usermod -aG vboxsf "${VBOXSF_USER}"
fi
