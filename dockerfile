FROM nginx:latest

ARG IP_ADDRESS
ENV IP_ADDRESS ${IP_ADDRESS}

COPY /root/nginx-staging/AzureWebServer/scripts/my-web.conf /etc/nginx/nginx.template

RUN envsubst < /etc/nginx/nginx.template > /etc/nginx/nginx.conf && \
    rm /etc/nginx/nginx.template
COPY /root/nginx-staging/AzureWebServer/html/*  /usr/share/nginx/html