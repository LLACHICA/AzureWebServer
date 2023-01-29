FROM nginx:latest

ARG IP_ADDRESS
ENV IP_ADDRESS ${IP_ADDRESS}

COPY nginx.template /etc/nginx/nginx.template

RUN envsubst < /etc/nginx/nginx.template > /etc/nginx/nginx.conf && \
    rm /etc/nginx/nginx.template

COPY /var/www/html/*  /usr/share/nginx/html