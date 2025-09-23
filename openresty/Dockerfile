FROM bitnami/openresty:1.27.1-2-debian-12-r15 as builder
USER root

## Install required packages and build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends dirmngr gpg gpg-agent curl build-essential libpcre3-dev \
        libssl-dev \
        ca-certificates \
        gettext-base \
        libgd-dev \
        libgeoip-dev \
        libncurses5-dev \
        libperl-dev \
        libreadline-dev \
        libxslt1-dev \
        make \
        perl \
        unzip \
        wget \
        zlib1g-dev \
        git

RUN cd /tmp && \
    curl -O https://openresty.org/download/openresty-1.27.1.2.tar.gz && \
    curl -O https://openresty.org/download/openresty-1.27.1.2.tar.gz.asc && \
    # gpg --verify openresty-1.27.1.1.tar.gz.asc openresty-1.27.1.1.tar.gz && \
    tar xzf openresty-1.27.1.2.tar.gz && \
    git clone --branch 2.5.3 https://github.com/nginx-modules/ngx_cache_purge.git && \
    git clone --branch v0.2.4 https://github.com/vozlt/nginx-module-vts.git

COPY ./mask-Signature.patch /tmp/

RUN cd /tmp/openresty-1.27.1.2 && \
    patch -p4 < /tmp/mask-Signature.patch

RUN cd /tmp/openresty-1.27.1.2 && \
    ./configure --prefix=/opt/bitnami/openresty --with-pcre-jit --with-http_realip_module --with-http_ssl_module --with-http_stub_status_module --with-http_v2_module --with-http_gzip_static_module --with-http_gunzip_module --with-http_auth_request_module --with-http_sub_module --with-mail_ssl_module --with-mail --with-compat --with-file-aio --with-http_addition_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_xslt_module=dynamic --with-ipv6 --with-md5-asm --with-sha1-asm --with-stream_realip_module --with-threads --with-stream \
    --add-dynamic-module=../ngx_cache_purge \
    --add-module=../nginx-module-vts && \
    make -j$(nproc) && \
    make install

FROM bitnami/openresty:1.27.1-2-debian-12-r15
USER root
COPY --from=builder /opt/bitnami/openresty/nginx/modules/ngx_http_cache_purge_module.so /opt/bitnami/openresty/nginx/modules/ngx_http_cache_purge_module.so
COPY --from=builder /opt/bitnami/openresty/bin/openresty /opt/bitnami/openresty/bin/openresty
## Enable module
RUN echo "load_module modules/ngx_http_cache_purge_module.so;" | cat - /opt/bitnami/openresty/nginx/conf/nginx.conf > /tmp/nginx.conf && \
    cp /tmp/nginx.conf /opt/bitnami/openresty/nginx/conf/nginx.conf
RUN apt-get update && apt-get install -y curl unzip git iputils-ping \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN opm get ledgetech/lua-resty-http
## Set the resolver.conf
RUN sed -i '/exec "$@"/i echo resolver $(awk '"'"'BEGIN{ORS=" "} $1=="nameserver" {print $2}'"'"' /etc/resolv.conf)" ipv6=off valid=30s;" > /opt/bitnami/openresty/nginx/conf/resolver.conf' /opt/bitnami/scripts/openresty/entrypoint.sh
## Set the container to be run as a non-root user by default
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/openresty/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openresty/run.sh" ]
