#!/bin/bash -eux

echo '==> Configuring settings for vagrant'

vagrant_user=vagrant
vagrant_user_home="/home/${vagrant_user}"
vagrant_insecure_key="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

# Add vagrant user (if it doesn't already exist)
if ! id -u "${vagrant_user}" >/dev/null 2>&1; then
  echo "==> Creating ${vagrant_user}"
  /usr/sbin/groupadd "${vagrant_user}"
  /usr/sbin/useradd "${vagrant_user}" -g "${vagrant_user}" -G wheel
  echo "==> Giving ${vagrant_user} sudo powers"
  echo "${vagrant_user}" | passwd --stdin "${vagrant_user}"
  echo "${vagrant_user}        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

  mkdir -p /var/lib/AccountsService/users
  echo "[User]" > "/var/lib/AccountsService/users/${vagrant_user}"
  echo "SystemAccount=true" >> "/var/lib/AccountsService/users/${vagrant_user}"
fi

echo "==> Installing Vagrant SSH key"
# shellcheck disable=SC2174
mkdir -pm 700 "${vagrant_user_home}/.ssh"
# https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
echo "${vagrant_insecure_key}" > "${vagrant_user_home}/.ssh/authorized_keys"
chmod 0600 "${vagrant_user_home}/.ssh/authorized_keys"
chown -R ${vagrant_user}:${vagrant_user} ${vagrant_user_home}/.ssh
