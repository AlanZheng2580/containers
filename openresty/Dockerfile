ARG RESTY_IMAGE_BASE="debian"
ARG RESTY_IMAGE_TAG="bookworm-slim"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG} as builder

## Install required packages and build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends dirmngr gpg gpg-agent curl build-essential libpcre3-dev zlib1g-dev \
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
        zlib1g-dev

RUN cd /tmp && \
    curl -O https://openresty.org/download/openresty-1.27.1.1.tar.gz && \
    curl -O https://openresty.org/download/openresty-1.27.1.1.tar.gz.asc && \
    # gpg --verify openresty-1.27.1.1.tar.gz.asc openresty-1.27.1.1.tar.gz && \
    tar xzf openresty-1.27.1.1.tar.gz

RUN cd /tmp/openresty-1.27.1.1 && \
    ./configure --prefix=/opt/bitnami/openresty --with-pcre-jit --with-http_realip_module --with-http_ssl_module --with-http_stub_status_module --with-http_v2_module --with-http_gzip_static_module --with-http_gunzip_module --with-http_auth_request_module --with-http_sub_module --with-mail_ssl_module --with-mail --with-compat --with-file-aio --with-http_addition_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_xslt_module=dynamic --with-ipv6 --with-md5-asm --with-sha1-asm --with-stream_realip_module --with-threads --with-stream && \
    make && \
    make install

FROM bitnami/openresty:1.27.1-1-debian-12-r5
COPY --from=builder /opt/bitnami/openresty/bin/openresty /opt/bitnami/openresty/bin/openresty


# ARG NGINX_VERSION=1.27.1
# ARG BITNAMI_NGINX_REVISION=r5
# ARG BITNAMI_NGINX_TAG=${NGINX_VERSION}-debian-12-${BITNAMI_NGINX_REVISION}

# FROM bitnami/nginx:${BITNAMI_NGINX_TAG} AS builder
# USER root
# ## Redeclare NGINX_VERSION so it can be used as a parameter inside this build stage
# ARG NGINX_VERSION
# ## Install required packages and build dependencies
# RUN install_packages dirmngr gpg gpg-agent curl build-essential libpcre3-dev zlib1g-dev
# ## Add trusted NGINX PGP key for tarball integrity verification
# #RUN gpg --keyserver pgp.mit.edu --recv-key 520A9993A1C052F8
# ## Download NGINX, verify integrity and extract
# RUN cd /tmp && \
#     curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
#     curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
# #    gpg --verify nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz && \
#     tar xzf nginx-${NGINX_VERSION}.tar.gz
# ## Compile NGINX with desired module
# RUN apt update && apt -y install git && cd /tmp && \
#     git clone --branch 2.5.3 https://github.com/nginx-modules/ngx_cache_purge.git
# RUN cd /tmp/nginx-${NGINX_VERSION} && \
#     rm -rf /opt/bitnami/nginx && \
#     ./configure --prefix=/opt/bitnami/nginx --with-compat --add-dynamic-module=/tmp/ngx_cache_purge && \
#     make && \
#     make install

# FROM bitnami/nginx:${BITNAMI_NGINX_TAG}
# USER root
# COPY --from=builder /opt/bitnami/nginx/modules/ngx_http_cache_purge_module.so /opt/bitnami/nginx/modules/ngx_http_cache_purge_module.so
# ## Enable module
# RUN echo "load_module modules/ngx_http_cache_purge_module.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
#     cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
# ## Set the resolver.conf
# RUN sed -i '/exec "$@"/i echo resolver $(awk '"'"'BEGIN{ORS=" "} $1=="nameserver" {print $2}'"'"' /etc/resolv.conf)" ipv6=off valid=30s;" > /opt/bitnami/nginx/conf/resolver.conf' /opt/bitnami/scripts/nginx/entrypoint.sh
# ## Set the container to be run as a non-root user by default
# USER 1001
# ENTRYPOINT [ "/opt/bitnami/scripts/nginx/entrypoint.sh" ]
# CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
