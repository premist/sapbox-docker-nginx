FROM debian:jessie

WORKDIR /opt

ENV NGINX_VERSION 1.11.10
ENV PAGESPEED_VERSION 1.11.33.4
ENV NGX_BROTLI_COMMIT_HASH bfd2885

RUN CONFIG="\
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_gunzip_module \
    --with-gzip_static_module \
    --with-http_mp4_module \
    --with-ipv6 \
    --with-threads \
    --add-module=/opt/ngx_brotli \
  " \
  && apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
    sudo wget git curl build-essential zlib1g-dev libpcre3 libpcre3-dev libssl-dev unzip ca-certificates \
  && apt-get clean \
  && git clone --recursive https://github.com/google/ngx_brotli.git \
  && cd ngx_brotli \
  && git checkout -b $NGX_BROTLI_COMMIT_HASH \
  && ( curl -f -L -sS https://ngxpagespeed.com/install | bash -s -- -v $PAGESPEED_VERSION -n $NGINX_VERSION -y -a '$CONFIG' ) \
  && rm -rf /opt/ngx_brotli \
  && apt-get remove -y build-essential git curl wget unzip \
  && apt-get autoremove -y \
  && ln -sf /dev/stdout /usr/local/nginx/logs/access.log \
  && ln -sf /dev/stderr /usr/local/nginx/logs/error.log

EXPOSE 80 443
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
