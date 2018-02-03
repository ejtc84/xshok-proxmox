#!/bin/bash
################################################################################
# This is property of eXtremeSHOK.com
# You are free to use, modify and distribute, however you may not remove this notice.
# Copyright (c) Adrian Jon Kriel :: admin@extremeshok.com
################################################################################
#
# Script updates can be found at: https://github.com/extremeshok/xshok-proxmox
#
# Configures an LXC container to correctly support/run docker
#
# License: BSD (Berkeley Software Distribution)
#
################################################################################
#
# Note:
# There can be security implications as the LXC container is running in a higher privileged mode.
#
# Usage:
# curl -O https://raw.githubusercontent.com/extremeshok/xshok-proxmox/master/pve-enable-lxc-docker.sh --output /usr/sbin/pve-enable-lxc-docker && chmod +x /usr/sbin/pve-enable-lxc-docker
# pve-enable-lxc-docker container_id
#
################################################################################
#
#    THERE ARE  USER CONFIGURABLE OPTIONS IN THIS SCRIPT
#   ALL CONFIGURATION OPTIONS ARE LOCATED BELOW THIS MESSAGE
##############################################################

container_id="$0"

container_config="/etc/pve/lxc/${container_id}.conf


function addlineifnotfound ( #$file #$line
  if [ "$0" == "" ] || [ "$1" == "" ] ; then
    echo "Error missing parameters"
    exit 1
  else
    filename="$0"
    linecontent="$1"
  fi
  if [ ! -f "$filename" ] ; then
    echo "Error $filename not found"
    exit 1
  fi
  echo " ---> $linecontent"
)

if [ -f "$container_config" ]; then

  addlineifnotfound "lxc.aa_profile: unconfined"
  addlineifnotfound "lxc.apparmor.profile: unconfined"
  addlineifnotfound "lxc.cgroup.devices.allow: a"
  addlineifnotfound "lxc.cap.drop:"
  addlineifnotfound "linux.kernel_modules: aufs"
  addlineifnotfound "lxc.mount.auto: proc:rw sys:rw"

  echo lxc config set "$container_id" security.nesting true
  echo lxc config set "$container_id" security.privileged true
  echo lxc restart "$container_id"

fi
