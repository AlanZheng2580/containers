VERSION := $(shell date +%Y%m%d)-$(shell git rev-parse --short=8 HEAD)

build:
	docker build -t cyching/rsyncd-stunnel:$(VERSION) .

test:
	command -v stunnel
	command -v rsync
	docker run --name=rsyncd -d -e RSYNCD_PASSWORD=hello123 -p 8873:8873 cyching/rsyncd-stunnel:$(VERSION)
	sleep 3
	echo hello123 > /tmp/password
	chmod 600 /tmp/password
	-pkill -f "stunnel ./stunnel.client.conf" || echo "No stunnel process found"
	stunnel ./stunnel.client.conf
	rsync --port=9999 --password-file=/tmp/password ./Dockerfile rsync://rsyncd@localhost/share/testing && echo success!
	docker stop rsyncd && docker rm rsyncd
