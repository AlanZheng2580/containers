ref: https://docs.rundeck.com/docs/learning/howto/egress-proxy.html#parameters-explained

docker network create --driver bridge ext
docker compose build
docker compose up
docker exec -it {rundeck_container} bash
# connection failed
curl https://kernel.org
curl -x proxysrv:8888 https://kernerl.org
rd plugins list

# chrome
1. open http://localhost
1. login
1. set your profiles
1. set your github token
1. setup SCM, https://git@github.com/AlanZheng2580/tech.git


# for rundeck
# if you want it connect to internet, set up these vars
export http_proxy=http://proxysrv:8888
export https_proxy=http://proxysrv:8888

# tcpdump
tcpdump -n -vv ip host 10.64.62.59
