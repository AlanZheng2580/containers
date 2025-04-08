VERSION := $(shell date +%Y%m%d)-$(shell git rev-parse --short=8 HEAD)
BITNAMI_OPENRESTY_TAG := 1.27.1-1-debian-12-r5
TAG := $(VERSION)-$(BITNAMI_OPENRESTY_TAG)

build:
	DOCKER_BUILDKIT=0 docker build -t cyching/openresty:$(TAG) .
	docker tag cyching/openresty:$(TAG) cyching/openresty:latest

test:
	sleep 3
	curl -I localhost:8088/get
	curl -I localhost:8088/get
	curl -I localhost:8088/purge/get
	curl -I localhost:8088/get
	curl -I -X PURGE localhost:8088/
	curl -I localhost:8088/get

up:
	docker-compose up -d

down:
	docker-compose down -v

metrics:
	curl -v localhost:8088/metrics
