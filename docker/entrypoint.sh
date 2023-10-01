#!/bin/bash

set -e
shopt -s expand_aliases

alias ls='ls --color=always'
alias grep='grep --color=always'

#/etc/init.d/dbus start
#/etc/init.d/avahi-daemon start
#mkdir /run/dbus
#dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address
#dbus-launch
#avahi-daemon --no-chroot --daemonize



echo "/etc/owntone.conf:"
grep -v "^[[:space:]]*\#" /etc/owntone.conf | grep .
ls -ld /var/cache/owntone /var/log/owntone.log
echo "whoami: $(whoami), id: $(id)"
echo

if [[ "$1" == "bash" || "$1" == "shell" ]]; then
    exec -l /bin/bash
elif [[ "$1" == "avahi" ]]; then
    avahi-browse -a
else
    /usr/sbin/owntone $*
fi
