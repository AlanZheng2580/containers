FROM alpine:3.18.3

RUN set -xe \
    && apk add -U rsync libcap openssl stunnel \
    && rm -rf /var/cache/apk/*

COPY rsyncd.conf /etc/rsyncd.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

# https://askubuntu.com/a/919732
RUN adduser -D rsyncd && setcap cap_net_bind_service,cap_setgid=+ep /usr/bin/rsync
USER rsyncd
# openssl req -new -x509 -days 3650 -key ca.key -out ca.pem -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/CN=www.example.com"
# openssl req -new -key key.pem -out cert.csr -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/CN=www.example.com"

WORKDIR /share
COPY --chown=rsyncd rsyncd.secrets /home/rsyncd/
RUN chmod 600 /home/rsyncd/rsyncd.secrets

EXPOSE 873

# stunnel
RUN mkdir -p /home/rsyncd/tls \
    && cd /home/rsyncd/tls \
    && openssl genrsa -out ca.key 2048 \
    && openssl req -new -x509 -days 3650 -key ca.key -out ca.pem -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/CN=www.example.com" \
    && openssl genrsa -out key.pem 2048 \
    && openssl req -new -key key.pem -out cert.csr -subj "/C=US/ST=YourState/L=YourCity/O=YourOrganization/CN=www.example.com" \
    && openssl x509 -req -days 3650 -in cert.csr -CA ca.pem -CAkey ca.key -set_serial 01 -out cert.pem
COPY --chown=rsyncd stunnel.server.conf /home/rsyncd/
EXPOSE 8873

ENTRYPOINT [ "/docker-entrypoint.sh"]
CMD ["rsync", "--daemon", "--no-detach", "--log-file", "/dev/stdout", "&&", "stunnel", "/home/rsyncd/stunnel.server.conf"]
