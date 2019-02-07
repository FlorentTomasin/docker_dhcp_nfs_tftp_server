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
  pid_rpc_nfsd=`pidof rpc.nfsd`
  echo "Terminating: pid_rpc_nfsd=${pid_rpc_nfsd}..."
  while [ ! -z ${pid_rpc_nfsd} ] ; do
      kill -TERM ${pid_rpc_nfsd} > /dev/null 2>&1
      pid_rpc_nfsd=`pidof rpc.nfsd`
  done
  echo "...terminated"
  pid_rpc_mountd=`pidof rpc.mountd`
  echo "Terminating: pid_rpc_mountd=${pid_rpc_mountd}..."
  while [ ! -z ${pid_rpc_mountd} ] ; do
      kill -TERM ${pid_rpc_mountd} > /dev/null 2>&1
      pid_rpc_mountd=`pidof rpc.mountd`
  done
  echo "...terminated"
  # For IPv6 bug:
  pid_rpc_bind=`pidof rpcbind`
  echo "Terminating: pid_rpc_bind=${pid_rpc_bind}..."
  while [ ! -z ${pid_rpc_bind} ] ; do
      kill -TERM ${pid_rpc_bind} > /dev/null 2>&1
      pid_rpc_bind=`pidof rpcbind`
  done
  echo "...terminated"
  pid_dhcpd=`pidof dhcpd`
  echo "Terminating: pid_dhcpd=${pid_dhcpd}..."
  while [ ! -z ${pid_dhcpd} ] ; do
      kill -TERM ${pid_dhcpd} > /dev/null 2>&1
      pid_dhcpd=`pidof dhcpd`
  done
  echo "...terminated"
  pid_in_tftpd=`pidof in.tftpd`
  echo "Terminating: pid_in_tftpd=${pid_in_tftpd}..."
  while [ ! -z ${pid_in_tftpd} ] ; do
      kill -TERM ${pid_in_tftpd} > /dev/null 2>&1
      pid_in_tftpd=`pidof in.tftpd`
  done
  echo "...terminated"
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
/sbin/rpcbind -s
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
