VERSION := $(shell date +%Y%m%d)-$(shell git rev-parse --short=8 HEAD)
BITNAMI_OPENRESTY_TAG := 1.27.1-1-debian-12-r5
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
	docker-compose up -d

down:
	docker-compose down -v

metrics:
	curl -v localhost:8088/metrics
