FROM php:7.4-cli AS builder
WORKDIR /var/www

RUN apt-get update && \
    apt-get install libzip-dev -y && \
    docker-php-ext-install zip

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');"

RUN php composer.phar create-project --prefer-dist laravel/laravel laravel

# Otimização da imagem
FROM PHP:7.4-fpm-alpine
WORKDIR /var/www
RUN rm -rf /var/www/html

# copia o conteúdo de /var/www/laravel do stage builder para /var/www/ do stage atual (WORKDIR)
COPY --from=builder /var/www/laravel .

# Atribui permissões para permitir que o user do alpine possa executar comandos e gravar logs
# -R = recursivo, www-data = usuário e grupo, /var/www = onde será aplicada a permissão
RUN chown -R www-data:www-data /var/www

EXPOSE 9000

# executa o php-fpm
CMD ["php-fpm"]

# docker build -t urielgoncalves/laravel:prod laravel -f /03-multistage-building/dockerfile.prod