#!/bin/sh

# NFS config
echo "NFS init..."
/usr/sbin/exportfs -rv
/sbin/rpcbind -s
/usr/sbin/rpc.nfsd --no-nfs-version 2 --no-nfs-version 3 8 |:
/usr/sbin/rpc.mountd
# DHCP config
echo "DHCP init..."
/usr/sbin/dhcpd -4 --no-pid -cf /etc/dhcp/dhcpd.conf -lf /var/lib/dhcp/dhcpd.leases
# TFTP config
echo "TFTP init..."
in.tftpd -L -c -s /var/tftpboot
