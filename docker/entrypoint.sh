#!/bin/bash

set -e
shopt -s expand_aliases

alias ls='ls --color=always'
alias grep='grep --color=always'

# * needs to run with --privileged
# * avahi-daemon+dbus: -v /run/dbus:/run/dbus -v /run/avahi-daemon/socket:/run/avahi-daemon/socket
# * uid in container needs to have permissions (group 'avahi'?)

echo "/etc/owntone.conf:"
grep -v "^[[:space:]]*\#" /etc/owntone.conf | grep .
ls -ld /var/cache/owntone /var/log/owntone.log
echo "whoami: $(whoami), id: $(id)"
echo

if [[ "$EUID" == "0" ]]; then
    echo "Running as root, starting dbus and avahi-daemon"
    /etc/init.d/dbus start
    /etc/init.d/avahi-daemon start
fi

if [[ "$1" == "bash" || "$1" == "shell" ]]; then
    exec -l /bin/bash
else
    /usr/sbin/owntone $*
fi
