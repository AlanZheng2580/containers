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
	curl -x localhost:8088 https://github.com -o /dev/null -w "%{http_code}" -s|grep 200

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
