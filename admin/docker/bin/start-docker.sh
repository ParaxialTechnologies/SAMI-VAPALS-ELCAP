#!/bin/bash

# This script is intended for use in Docker containers
# It should be run as root

trap "/etc/init.d/osehravista stop" SIGTERM

echo "Starting xinetd"
/usr/sbin/xinetd

echo "Starting sshd"
/usr/sbin/sshd

/etc/init.d/osehravista start

find /home/osehra/tmp -exec chmod ug+rw {} \;

# Create a fifo so that bash can read from it to catch signals from Docker
rm -f ~/fifo
mkfifo ~/fifo || exit
chmod 400 ~/fifo
read < ~/fifo

exit 0
