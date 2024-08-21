VERSION := $(shell git rev-parse --short=8 HEAD)-$(shell date +%Y%m%d)

build:
	docker build -t cyching/rsyncd:$(VERSION) .

test:
	docker run -d --name=rsyncd -p 8873:8873 \
	-v ./authorized_keys:/home/rsyncd/.ssh/authorized_keys.ori \
	-v ./ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key.ori \
	-v ./ssh_host_rsa_key.pub:/etc/ssh/ssh_host_rsa_key.pub.ori cyching/rsyncd:$(VERSION)
	sleep 3
	rsync -e 'ssh -p 8873 -i ./client_key -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' ./Dockerfile rsyncd@localhost:/share/testing/ && echo success!
	docker stop rsyncd && docker rm rsyncd
