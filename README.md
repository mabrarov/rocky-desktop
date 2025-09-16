# Rocky Linux 10 Desktop

[Packer](http://packer.io/intro/index.html) project for Virtual Appliance with VirtualBox VM based on Rocky Linux 10 with GNOME and VirtualBox Guest Additions.

## Build requirements

1. [Oracle VirtualBox](https://www.virtualbox.org/) 7.1.10+.
1. [HashiCorp Packer](http://packer.io/downloads.html) 1.11.2+.
1. All commands assume current directory is the one where this repository is cloned.
1. All commands assume usage of Bash. Git Bash on Windows is tested and supported too.

## Steps to build

1. Download [Rocky-10.0-x86_64-dvd1.iso](https://rockylinux.org/ru/download) and put it into the root directory of repository.
1. Download [VBoxGuestAdditions_7.2.2.iso](https://download.virtualbox.org/virtualbox/7.2.2/VBoxGuestAdditions_7.2.2.iso) and put it into the root directory of repository.
1. Run
    ```bash
    packer init rocky-desktop.pkr.hcl && packer build rocky-desktop.pkr.hcl
    ```
1. Find the built OVA in output/rocky-desktop-x.y.z.ova, where `x.y.z` is value of `vm_version` variable in
    [rocky-desktop.pkr.hcl](rocky-desktop.pkr.hcl).

## Changing version of OVA

1. Change default value of `vm_version` variable in [rocky-desktop.pkr.hcl](rocky-desktop.pkr.hcl).
1. Build new OVA.

## Using different ISO with Rocky Linux

1. Download new ISO file with Rocky Linux (https://rockylinux.org/download) and put it into the root directory of repository.
1. Change name of the ISO file in `iso_url` field in [rocky-desktop.pkr.hcl](rocky-desktop.pkr.hcl).
1. Change value of `iso_checksum` field in [rocky-desktop.pkr.hcl](rocky-desktop.pkr.hcl). The new value can be taken
    from `CHECKSUM` file distributed with Rocky Linux ISO.
1. Change default value of `vm_version` variable in [rocky-desktop.pkr.hcl](rocky-desktop.pkr.hcl).
1. Build new OVA.

## Using different VirtualBox Guest Additions

1. Download new ISO file with VirtualBox Guest Additions (https://download.virtualbox.org/virtualbox/) and put it into the root directory of repository.
1. Change name of the ISO file in `guest_additions_url` field in [rocky-desktop.pkr.hcl](rocky-desktop.pkr.hcl).
1. Change value of `guest_additions_sha256` field in [rocky-desktop.pkr.hcl](rocky-desktop.pkr.hcl). The new value can
    be taken from `SHA256SUMS` file in the same directory as ISO file with VirtualBox Guest Additions.
1. Change default value of `vm_version` variable in [rocky-desktop.pkr.hcl](rocky-desktop.pkr.hcl).
1. Build new OVA.
