FROM rundeck/rundeck:4.17.4

USER root

# base network tools
RUN apt-get update && apt-get -y install iputils-ping curl nmap mc tcpdump

# rd cli to interact with rundeck instance
RUN curl -s https://packagecloud.io/install/repositories/pagerduty/rundeck/script.deb.sh | os=any dist=any bash && apt-get update && apt-get install rundeck-cli

USER rundeck

# rd cli env vars
ENV RD_AUTH_PROMPT false
ENV RD_URL http://localhost:4440
ENV RD_USER admin
ENV RD_PASSWORD admin
