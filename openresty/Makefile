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

# cd openresty
# mkdir src
# cd src
# curl -O https://openresty.org/download/openresty-1.27.1.2.tar.gz 
# tar -zxvf ./openresty-1.27.1.2.tar.gz 
# cp openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c.orig
# vim openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c
# diff -u openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c.orig openresty-1.27.1.2/bundle/nginx-1.27.1/src/http/ngx_http_request.c > ../mask-Signature.patch 
