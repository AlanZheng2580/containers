#!/bin/sh
set -e

if [ -z "$RSYNCD_PASSWORD" ]; then
    echo 'WARNING: env var $RSYNCD_PASSWORD not defined, using container default, which is INSECURE!'
else
    echo "rsyncd:$RSYNCD_PASSWORD" > /home/rsyncd/rsyncd.secrets
fi

cat /home/rsyncd/rsyncd.secrets | sudo chpasswd
sudo chown rsyncd:rsyncd /home/rsyncd/.ssh/authorized_keys
sudo /usr/sbin/sshd -D
