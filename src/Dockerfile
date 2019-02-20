FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        isc-dhcp-server \
        tftpd-hpa \
        nfs-kernel-server && \
    # Clean rootfs
    apt-get clean all && \
    apt-get autoremove -y && \
    apt-get purge && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    # Configure DHCP
    touch /var/lib/dhcp/dhcpd.leases && \
    # Configure rpcbind
    mkdir -p /run/sendsigs.omit.d && \
    touch /run/sendsigs.omit.d/rpcbind

# Export the NFS server ports
EXPOSE 111/tcp \
       111/udp \
       2049/tcp \
       2049/udp \
       67/tcp \
       67/udp \
       69/udp

WORKDIR /

VOLUME ["/etc/dhcp"]
VOLUME ["/etc/default"]

COPY entrypoint.sh /entrypoint.sh
    # Set correct entrypoint permission
RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
