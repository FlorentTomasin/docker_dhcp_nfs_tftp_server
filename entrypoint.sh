#!/bin/sh -eu

echo "$NFS_EXPORT_DIR $NFS_EXPORT_DOMAIN($NFS_EXPORT_OPTION)" > /etc/exports
/usr/sbin/exportfs -r
/sbin/rpcbind -s
/usr/sbin/rpc.nfsd --no-nfs-version 2 --no-nfs-version 3 8 |:
/usr/sbin/rpc.mountd -F
