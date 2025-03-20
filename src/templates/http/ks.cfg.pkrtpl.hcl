cdrom
lang en_US.UTF-8
keyboard us
rootpw --plaintext root
network --bootproto=dhcp --noipv6
network --hostname=localhost.localdomain
firewall --disabled
selinux --disabled
timezone Europe/Moscow
bootloader --location=mbr
text
zerombr
clearpart --all --initlabel
autopart --type=plain
auth --useshadow --passalgo=sha512
xconfig --defaultdesktop=GNOME --startxonboot
firstboot --disabled
eula --agreed
services --enabled=NetworkManager,sshd
reboot
user --name="${username}" --plaintext --password "${password}" --groups=users,wheel --shell=/bin/bash

%packages --ignoremissing
@Base
@Core
@Development Tools
@Fonts
@X11
@gnome-desktop
@input-methods
@network-tools
@remote-desktop-clients
@system-admin-tools
kernel-devel
kernel-headers
gnome-disk-utility
gnome-packagekit
firefox
vinagre
openssh-clients
sudo
net-tools
vim
wget
curl
rsync
perl
bzip2
gcc
dkms
make
cabextract

-empathy
-postfix
-abrt
-abrt-*
-cheese
-gnome-boxes
-gnome-contacts
-gnome-dictionary
-gnome-dictionary-libs
-gnome-getting-started-docs
-gnome-video-effects
-gnome-user-docs
-gnome-weather
-gnome-tour
-orca
-setroubleshoot
-setroubleshoot-*
-totem
-totem-nautilus
-cockpit*
%end

%post --erroronfail

dnf remove -y PackageKit*

# Increase DNF timeout
echo "timeout=300" >> /etc/dnf/dnf.conf
# ... and decrease minimum DNF download speed
echo "minrate=1" >> /etc/dnf/dnf.conf

# Update
dnf --enablerepo=base clean metadata
dnf update -y --refresh

# Turning off sshd DNS lookup to prevent timeout delay
sed -i -r 's/^(UseDNS\s+.+)$/#\1/' /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config

# Disabling GSSAPI authentication to prevent timeout delay
sed -i -r 's/^(GSSAPIAuthentication\s+.+)$/#\1/' /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

%end
