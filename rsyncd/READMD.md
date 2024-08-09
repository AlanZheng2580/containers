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

### 產生給azure ci pipeline讀取的client_key

因為azure ci pipeline的變數是字串，儲存時的換行會變成空格，所以先把client_key用base64編碼
cat client_key | base64 > client_key.base64，再把內容貼到pipeline變數
pipeline內再用cat $(cleintKeyBase64) | tr ' ' '\n' | base64 -d > ./client_key 解開
