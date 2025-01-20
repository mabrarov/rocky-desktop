#!/bin/bash -eux

echo '==> Remove old kernels'
dnf -y remove --oldinstallonly --setopt installonly_limit=2 kernel

echo '==> Clean up'
dnf -y clean all
rm -rf /var/cache/dnf
