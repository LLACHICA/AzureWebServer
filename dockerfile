FROM nginx:latest

ARG IP_ADDRESS
ENV IP_ADDRESS ${IP_ADDRESS}

COPY ./scripts/my-web.conf /etc/nginx/nginx.template

RUN envsubst '$IP_ADDRESS' < /etc/nginx/nginx.template > /etc/nginx/conf.d/my-web.conf && \
    rm /etc/nginx/nginx.template
COPY ./html/  /usr/share/nginx/html/