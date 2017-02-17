FROM debian:jessie

WORKDIR /opt

ENV NGINX_VERSION 1.11.10
ENV PAGESPEED_VERSION 1.11.33.4

RUN apt-get update \
  && apt-get -y install sudo wget git curl build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev unzip \
  && apt-get clean \
  && git clone --recursive https://github.com/google/ngx_brotli.git \
  && cd ngx_brotli \
  && git checkout -b bfd2885 \
  && ( curl -f -L -sS https://ngxpagespeed.com/install | bash -s -- -v $PAGESPEED_VERSION -n $NGINX_VERSION -y -a '--with-http_ssl_module --with-ipv6 --with-http_v2_module --add-module=/opt/ngx_brotli' ) \
  && rm -rf /opt/ngx_brotli

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
