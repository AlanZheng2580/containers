VERSION := $(shell date +%Y%m%d)-$(shell git rev-parse --short=8 HEAD)


build:
	docker build -t cyching/nginx:$(VERSION) .
	docker tag cyching/nginx:$(VERSION) cyching/nginx:latest

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