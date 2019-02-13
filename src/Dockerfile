FROM alpine:edge

# Install alpine requirements for NFS, DHCP, TFTP
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/releases/x86_64/" >> /etc/apk/repositories && \
    apk add -U -v --no-cache --no-progress \
        nfs-utils \
        dhcp \
        tftp-hpa && \
    # Clean Alpine package list
    rm -rf /var/cache/apk/* /tmp/* && \
    rm -f /sbin/halt /sbin/poweroff /sbin/reboot && \
    # Make the NFS server auto start
    mkdir -p /var/lib/nfs/v4recovery && \
    # Configure DHCP
    touch /var/lib/dhcp/dhcpd.leases && \
    # Set corret tftpboot permission
    chmod 777 /var/tftpboot

# Export the NFS server port
EXPOSE 111/tcp \
       111/udp \
       2049/tcp \
       2049/udp \
       67/tcp \
       67/udp \
       69/udp

WORKDIR /

VOLUME ["/nfs"]
VOLUME ["/etc/dhcp"]

COPY entrypoint.sh /entrypoint.sh
    # Set correct entrypoint permission
RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
