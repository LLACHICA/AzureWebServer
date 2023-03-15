FROM php:7.0-fpm
RUN docker-php-ext-install pdo_mysql

WORKDIR /var/www/html
# Install the wait-for-it.sh script
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /usr/bin/wait-for-it
RUN chmod +x /usr/bin/wait-for-it

# Wait for the MySQL container to be up and running
CMD ["wait-for-it", "mysql:3306", "--", "php", "./create_table.php"]
