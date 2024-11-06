VERSION := $(shell date +%Y%m%d)-$(shell git rev-parse --short=8 HEAD)
TAG := $(VERSION)

build:
	docker build -t cyching/rundeck-egress-test:$(TAG) .
	docker tag cyching/rundeck-egress-test:$(TAG) cyching/rundeck-egress-test:latest

up:
	docker-compose up

down:
	docker-compose down -v
