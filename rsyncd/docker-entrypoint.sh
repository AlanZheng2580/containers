#!/bin/sh
set -e

if [ -z "$RSYNCD_PASSWORD" ]; then
    echo 'WARNING: env var $RSYNCD_PASSWORD not defined, using container default, which is INSECURE!'
else
    echo "rsyncd:$RSYNCD_PASSWORD" > /home/rsyncd/rsyncd.secrets
fi

cat /home/rsyncd/rsyncd.secrets | sudo chpasswd

sudo cp /home/rsyncd/.ssh/authorized_keys.ori /home/rsyncd/.ssh/authorized_keys
sudo chown rsyncd:rsyncd /home/rsyncd/.ssh/authorized_keys

sudo cp /etc/ssh/ssh_host_rsa_key.ori /etc/ssh/ssh_host_rsa_key 
sudo chmod 600 /etc/ssh/ssh_host_rsa_key

sudo cp /etc/ssh/ssh_host_rsa_key.pub.ori /etc/ssh/ssh_host_rsa_key.pub 
sudo chmod 644 /etc/ssh/ssh_host_rsa_key.pub

sudo /usr/sbin/sshd -D
