FROM php:8.3-fpm

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    zip \
    npm \
    nodejs \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd zip mbstring exif pcntl bcmath

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Criar diretório da aplicação
WORKDIR /var/www

# Copiar arquivos do Laravel
COPY . .

# Instalar dependências do Laravel (Composer e NPM)
RUN composer install && \
    npm install && \
    npm run build || true

# Instalar Laravel Breeze (opcional, se você quiser já embutido)
# -> Se preferir instalar depois manualmente, comente estas linhas
RUN composer require laravel/breeze --dev && \
    php artisan breeze:install vue --force && \
    npm install && \
    npm run build || true

CMD ["php-fpm"]
