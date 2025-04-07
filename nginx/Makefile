VERSION := $(shell date +%Y%m%d)-$(shell git rev-parse --short=8 HEAD)
NGINX_VERSION := 1.25.5
BITNAMI_NGINX_REVISION := r7
BITNAMI_NGINX_TAG := $(NGINX_VERSION)-debian-12-$(BITNAMI_NGINX_REVISION)
TAG := $(VERSION)-$(BITNAMI_NGINX_TAG)

build:
	docker build --build-arg NGINX_VERSION=$(NGINX_VERSION) --build-arg BITNAMI_NGINX_REVISION=$(BITNAMI_NGINX_REVISION) --build-arg BITNAMI_NGINX_TAG=$(BITNAMI_NGINX_TAG) -t cyching/nginx:$(TAG) .
	docker tag cyching/nginx:$(TAG) cyching/nginx:latest

checker: build
	docker build --build-arg TAG=$(TAG) -t cyching/nginx-checker:$(TAG) -f Dockerfile-checker .

test:
	docker-compose up -d
	sleep 3
	curl -I localhost:8080/get
	curl -I localhost:8080/get
	curl -I localhost:8080/purge/get
	curl -I localhost:8080/get
	curl -I -X PURGE localhost:8080/
	curl -I localhost:8080/get
	docker-compose down -v
