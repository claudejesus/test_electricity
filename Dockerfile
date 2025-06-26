FROM php:8.2-apache

# Install mysqli extension and enable mod_rewrite
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli && a2enmod rewrite

# Copy all project files to the Apache web root
COPY . /var/www/html/

# Set working directory and permissions (optional but recommended)
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 for web traffic
EXPOSE 80
