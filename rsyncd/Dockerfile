FROM alpine:3.18.3

RUN set -xe \
    && apk add -U rsync libcap openssh-server sudo \
    && rm -rf /var/cache/apk/*

COPY rsyncd.conf /etc/rsyncd.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod 644 /etc/rsyncd.conf
RUN chmod 755 /docker-entrypoint.sh
RUN mkdir -p /share && chmod 777 /share
RUN sed -i 's/#Port 22/Port 8873/' /etc/ssh/sshd_config
RUN sed -i 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/' /etc/ssh/sshd_config

# https://askubuntu.com/a/919732
RUN adduser -D rsyncd && setcap cap_net_bind_service,cap_setgid=+ep /usr/bin/rsync
RUN echo "rsyncd ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER rsyncd

WORKDIR /share
COPY --chown=rsyncd rsyncd.secrets /home/rsyncd/

EXPOSE 873

ENTRYPOINT [ "/docker-entrypoint.sh"]
