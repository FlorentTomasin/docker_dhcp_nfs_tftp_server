#!/bin/sh

# DHCP config
echo "DHCP init..."
/usr/sbin/dhcpd -4 --no-pid -cf /etc/dhcp/dhcpd.conf -lf /var/lib/dhcp/dhcpd.leases
# TFTP config
echo "TFTP init..."
in.tftpd -c -s /var/tftpboot
# NFS config
echo "NFS init..."
/sbin/rpcbind -s
/sbin/rpcinfo
/usr/sbin/rpc.nfsd -d --no-nfs-version 2 --no-nfs-version 3 8 |:
/usr/sbin/exportfs -rv
/usr/sbin/rpc.mountd --no-nfs-version 2 --no-nfs-version 3

while true; do

  pid=`pidof rpc.mountd`
  
  if [ -z "$pid" ]; then
    echo "NFS has failed, exiting, so Docker can restart the container..."
    break
  fi

  sleep 1

done
