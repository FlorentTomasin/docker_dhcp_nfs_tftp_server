FROM alpine:edge

COPY entrypoint.sh /entrypoint.sh

# Install alpine requirements
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/releases/x86_64/" >> /etc/apk/repositories && \
    apk add -U -v --no-cache --no-progress \
        nfs-utils && \
    # Clean Alpine package list
    rm -rf /var/cache/apk/* /tmp/* && \
    rm -f /sbin/halt /sbin/poweroff /sbin/reboot && \
    # Make the NFS server auto start
    mkdir -p /var/lib/nfs/v4recovery && \
    chmod u+x /entrypoint.sh

# Setup enironment variables
ENV NFS_EXPORT_DIR /nfs
ENV NFS_EXPORT_DOMAIN *
ENV NFS_EXPORT_OPTION rw,fsid=0,sync,no_subtree_check,no_auth_nlm,insecure,no_root_squash,crossmnt,no_acl

# Export the NFS server port
EXPOSE 111/tcp \
       111/udp \
       2049/tcp \
       2049/udp

WORKDIR /

ENTRYPOINT ["/entrypoint.sh"]
