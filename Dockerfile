# Use official PHP image with Apache
FROM php:8.1-apache

# Enable required PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy Laravel files
COPY . .

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy custom Apache config (optional)
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

