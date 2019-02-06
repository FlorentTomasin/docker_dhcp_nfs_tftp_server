#!/bin/sh

# Make sure we react to these signals by running stop() when we see them - for clean shutdown
# And then exiting
trap "stop; exit 0;" SIGTERM SIGINT

stop()
{
  # We're here because we've seen SIGTERM, likely via a Docker stop command or similar
  # Let's shutdown cleanly
  echo "SIGTERM caught, terminating NFS process(es)..."
  /usr/sbin/exportfs -uav
  pid1=`pidof rpc.nfsd`
  pid2=`pidof rpc.mountd`
  # For IPv6 bug:
  pid3=`pidof rpcbind`
  pid4=`pidof dhcpd`
  pid5=`pidof in.tftpd`
  kill -TERM $pid1 $pid2 $pid3 $pid4 $pid5 > /dev/null 2>&1
  echo "Terminated."
  exit
}

# DHCP config
echo "DHCP init..."
/usr/sbin/dhcpd -4 --no-pid -cf /etc/dhcp/dhcpd.conf -lf /var/lib/dhcp/dhcpd.leases
# TFTP config
echo "TFTP init..."
in.tftpd -l -c -s /var/tftpboot
# NFS config
echo "Starting rpcbind..."
/sbin/rpcbind -w
echo "Displaying rpcbind status..."
/sbin/rpcinfo
echo "Starting NFS in the background..."
/usr/sbin/rpc.nfsd --debug 8 --no-udp --no-nfs-version 2 --no-nfs-version 3
echo "Exporting File System..."
if /usr/sbin/exportfs -rv; then
    /usr/sbin/exportfs
else
    echo "Export validation failed, exiting..."
    exit 1
fi
echo "Starting Mountd in the background..."
/usr/sbin/rpc.mountd --debug all --no-udp --no-nfs-version 2 --no-nfs-version 3

nfsgood=0
for i in `seq 1 100`; do
    mypid=`pidof rpc.mountd`
    if [ ! -z ${mypid} ]; then
        nfsgood=1
        break
    fi
    sleep 1
done

if test "${nfsgood}" -ne 0; then
    echo "NFS started..."
    while true; do sleep 1; done
else
    echo "NFS failed to start"
fi
#su root
