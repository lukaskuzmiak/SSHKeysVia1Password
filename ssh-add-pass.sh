#!/bin/bash

# This script utilizes ssh-add -c to ask the user for permission each time key is used
# Keep that in mind as you need to have SSH_ASKPASS set properly
# -c option is not necessary, feel free to remove it if you know what you're doing

if [ $# -ne 2 ] ; then
  echo "Usage: ssh-add-pass keyfile passfile"
  exit 1
fi

pass="$2"

echo "$pass"| SSH_ASKPASS="$HOME/ssh-add-pass-helper.sh" ssh-add -c "$1"
echo $?
