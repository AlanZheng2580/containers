# Docker Rsync Over SSH Server Setup

## Prerequisites

- Docker and Rsync installed on your system.
- Basic knowledge of SSH and Docker.

## 1. Generating SSH Keys

Generate a new SSH key pair for the client & server

```sh
cd {PATH}/rsync
ssh-keygen -t rsa -b 4096 -f ./client_key
cp ./client_key.pub ./authorized_keys
ssh-keygen -t rsa -b 4096 -f ./ssh_host_rsa_key
```

## 2. Build the docker image

```sh
make build
```

## 3. Testing

```sh
make test
```
