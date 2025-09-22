VERSION := $(shell date +%Y%m%d)-$(shell git rev-parse --short=8 HEAD)
BITNAMI_OPENRESTY_TAG := 1.27.1-2-debian-12-r15
TAG := $(VERSION)-$(BITNAMI_OPENRESTY_TAG)

build:
	DOCKER_BUILDKIT=0 docker build -t cyching/openresty:$(TAG) .
	docker tag cyching/openresty:$(TAG) cyching/openresty:latest

test:
	sleep 3
	curl -Is localhost:8088/get | grep -i "X-Cache-Status:"
	curl -Is localhost:8088/get | grep -i "X-Cache-Status: HIT"
	curl -Is localhost:8088/purge/get | grep -i "HTTP/1.1 200 OK"
	curl -Is localhost:8088/get | grep -i "X-Cache-Status: MISS"
	curl -Is localhost:8088/get | grep -i "X-Cache-Status: HIT"
	curl -Is -X PURGE localhost:8088/ | grep -i "HTTP/1.1 200 OK"
	curl -Is localhost:8088/get | grep -i "X-Cache-Status: MISS"
	curl -Is localhost:8088/get | grep -i "X-Cache-Status: HIT"
	curl -s localhost:8088/status | grep -i "<title>nginx vhost traffic status monitor</title>"

up:
	docker-compose up --build --remove-orphans

down:
	docker-compose down -v

reload:
	docker-compose exec openresty openresty -s reload

logs: ## 查看 OpenResty 的 logs
	docker-compose logs -f openresty

metrics:
	curl -v localhost:8088/metrics

# Install extenssions for debugger: C/C++, C/C++ Themes, and C/C++ Themes
# Install packages: sudo apt-get install build-essential gdb psmisc
# Config the directory for installation. e.g.: --with-debug --prefix=/home/kasm-user/workspace/containers/openresty/output

# cd openresty
# mkdir src && cd src
# curl -O https://openresty.org/download/openresty-1.27.1.2.tar.gz && tar -zxvf ./openresty-1.27.1.2.tar.gz 
# git clone --branch 2.5.3 https://github.com/nginx-modules/ngx_cache_purge.git && git clone --branch v0.2.4 https://github.com/vozlt/nginx-module-vts.git
# cd openresty-1.27.1.2
# ./configure --with-debug --prefix=/home/kasm-user/workspace/containers/openresty/output --with-pcre-jit --with-http_realip_module --with-http_ssl_module --with-http_stub_status_module --with-http_v2_module --with-http_gzip_static_module --with-http_gunzip_module --with-http_auth_request_module --with-http_sub_module --with-mail_ssl_module --with-mail --with-compat --with-file-aio --with-http_addition_module --with-http_dav_module --with-http_flv_module --with-http_geoip_module=dynamic --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_random_index_module --with-http_secure_link_module --with-http_slice_module --with-http_xslt_module=dynamic --with-ipv6 --with-md5-asm --with-sha1-asm --with-stream_realip_module --with-threads --with-stream --add-dynamic-module=../ngx_cache_purge --add-module=../nginx-module-vts && make -j$(nproc) && make install

# cp openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c.orig
# vim openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c
# diff -u openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c.orig openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c > ../mask-Signature.patch 
