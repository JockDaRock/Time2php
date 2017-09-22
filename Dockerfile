FROM php:fpm

RUN apt-get update && apt-get install python3-dev python3-pip -y \
    && apt-get upgrade -y \
    && apt-get install ca-certificates && pip3 install --upgrade pip setuptools wheel \
    && pip3 install requests certifi

# RUN apt-get update && apt-get install zlib1g-dev
# RUN pecl install pecl/raphf && docker-php-ext-enable raphf
# RUN pecl install propro && docker-php-ext-enable propro
# RUN pecl install pecl_http && docker-php-ext-enable http

ADD https://github.com/alexellis/faas/releases/download/0.5.8-alpha/fwatchdog /usr/bin

RUN chmod +x /usr/bin/fwatchdog

WORKDIR /root/

COPY time2php.py .

ENV fprocess="python3 time2php.py"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
