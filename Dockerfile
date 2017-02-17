FROM debian:jessie

RUN apt-get update \
  && apt-get -y install sudo wget curl build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev unzip \
  && apt-get clean \
  && bash <(curl -f -L -sS https://ngxpagespeed.com/install) \
    --nginx-version latest -y -a '--with-http_ssl_module --with-http_v2_module'
