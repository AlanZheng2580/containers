ARG NGINX_VERSION=1.25.1
ARG BITNAMI_NGINX_REVISION=r41
ARG BITNAMI_NGINX_TAG=${NGINX_VERSION}-debian-11-${BITNAMI_NGINX_REVISION}

FROM bitnami/nginx:${BITNAMI_NGINX_TAG} AS builder
USER root
## Redeclare NGINX_VERSION so it can be used as a parameter inside this build stage
ARG NGINX_VERSION
## Install required packages and build dependencies
RUN install_packages dirmngr gpg gpg-agent curl build-essential libpcre3-dev zlib1g-dev
## Add trusted NGINX PGP key for tarball integrity verification
#RUN gpg --keyserver pgp.mit.edu --recv-key 520A9993A1C052F8
## Download NGINX, verify integrity and extract
RUN cd /tmp && \
    curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc && \
#    gpg --verify nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz && \
    tar xzf nginx-${NGINX_VERSION}.tar.gz
## Compile NGINX with desired module
RUN apt update && apt -y install git && cd /tmp && \
    git clone https://github.com/nginx-modules/ngx_cache_purge.git
RUN cd /tmp/nginx-${NGINX_VERSION} && \
    rm -rf /opt/bitnami/nginx && \
    ./configure --prefix=/opt/bitnami/nginx --with-compat --add-dynamic-module=/tmp/ngx_cache_purge && \
    make && \
    make install

FROM bitnami/nginx:${BITNAMI_NGINX_TAG}
USER root
COPY --from=builder /opt/bitnami/nginx/modules/ngx_http_cache_purge_module.so /opt/bitnami/nginx/modules/ngx_http_cache_purge_module.so
## Enable module
RUN echo "load_module modules/ngx_http_cache_purge_module.so;" | cat - /opt/bitnami/nginx/conf/nginx.conf > /tmp/nginx.conf && \
    cp /tmp/nginx.conf /opt/bitnami/nginx/conf/nginx.conf
## Set the container to be run as a non-root user by default
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
