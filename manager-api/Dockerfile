FROM php:7.1-apache

RUN apt-get update && apt-get install -y \
	git \
        libpq-dev \
    && docker-php-ext-install -j$(nproc) pdo pdo_pgsql\
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/IPS-LMU/emuDB-manager.git /code
RUN rm -rf /var/www/html && ln -s /code/src/server-side /var/www/html
RUN rm /var/www/html/emudb-manager.config.php && ln -s /etc/emu-cloud/emudb-manager.config.php /var/www/html

RUN echo "display_errors=off" >> /usr/local/etc/php/conf.d/log.ini
RUN echo "log_errors=on" >> /usr/local/etc/php/conf.d/log.ini
