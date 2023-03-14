FROM nginx:latest
ARG IP_ADDRESS
ENV IP_ADDRESS ${IP_ADDRESS}

RUN apt-get update && apt-get install -y \
    php-fpm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./scripts/my-web.conf /etc/nginx/nginx.template

RUN envsubst '$IP_ADDRESS' < /etc/nginx/nginx.template > /etc/nginx/conf.d/my-web.conf && \
    rm /etc/nginx/nginx.template

COPY ./html/ /usr/share/nginx/html/

CMD service php7.4-fpm start && nginx -g 'daemon off;'