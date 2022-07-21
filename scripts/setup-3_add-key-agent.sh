#!/bin/bash

NAME=${1}

DEST=${2}
PRIK="${DEST}/${NAME}"

if [[ -z "${SSH_PASS}" ]]; then
  echo "trying to use password previously set for SSH key"
  PASS=${3}
else
  # this is useful for when the shell is closed and key needs to be added to agent
  echo "using the SSH_PASS env variable as the password"
  PASS="${SSH_PASS}"
  # to clean this from history use: for ln in $( history | grep SSH_PASS | cut -f2 -d' ' | tac); do history -d $ln; done
fi

/usr/bin/expect <<EOD
spawn ssh-add $PRIK
match_max 100000
expect -exact "Enter passphrase for $PRIK: "
send -- "$PASS\r"
expect eof
EOD

if  ssh-add -l | grep -q "$(ssh-keygen -lf "${PRIK}" | awk '{print $2}')"; then 
    echo "key is in agent"
else
    echo "key was not added to the agent"
    exit 1
fi
