#!/bin/bash -eux

echo "==> Updating system packages"
dnf update -y --refresh
