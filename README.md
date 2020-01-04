# docker: status report for .onion services ✉️ 🐳

send email via [dma](https://github.com/corecode/dma) 
when [tor .onion service](https://2019.www.torproject.org/docs/onion-services.html.en)
goes online or offline

repo: https://github.com/fphammerle/docker-onion-service-status-mail

docker hub: https://hub.docker.com/r/fphammerle/onion-service-status-mail

signed image tags: https://github.com/fphammerle/docker-onion-service-status-mail/tags

```sh
$ sudo docker network create tor
$ sudo docker run -d --network tor \
    --name tor_proxy \
    fphammerle/tor-proxy
$ sudo docker run -d --network tor \
    -e TOR_HOST=tor_proxy -e TOR_PORT=9050 \
    -e ONION_SERVICE_HOST=change-me.onion \
    -e ONION_SERVICE_PORT=80 \
    -e RECIPIENT_ADDRESS=me@example.com \
    --name onion_service_monitor  \
    fphammerle/onion-service-status-mail
```

## docker-compose 🐙

1. `git clone https://github.com/fphammerle/docker-onion-service-status-mail`
2. edit `docker-compose.yml`
3. `docker-compose up --build`
