FROM alpine:3.20

RUN apk update \
  && apk add --no-cache tzdata dnsmasq logrotate \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "59      23      *       *       *       logrotate -f /etc/logrotate.d/dnsmasq" >> /etc/crontabs/root \
  && rm -rf /var/lib/apt/lists/* \
  && rm /var/cache/apk/*

ADD dnsmasq /etc/logrotate.d/

WORKDIR /dnsmasq

EXPOSE 53

ENTRYPOINT ["sh", "-c", "crond restart && dnsmasq -k --interface=eth0 --no-resolv --server=114.114.114.114 --server=8.8.8.8 --cache-size=1000 --min-cache-ttl=300 --max-cache-ttl=300 --log-queries=extra --log-facility=/dnsmasq/logs/dnsmasq.log --pid-file=/var/run/dnsmasq.pid --no-hosts --addn-hosts=/dnsmasq/config/dnsmasq.hosts --domain-needed --no-negcache --address=/*.nb.io/10.1.8.11"]