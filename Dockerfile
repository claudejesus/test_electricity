FROM php:8.2-apache

# Enable mod_rewrite for .htaccess support
RUN a2enmod rewrite

# Copy all source code into Apache server folder
COPY . /var/www/html/

# Expose port 80 (used by Render)
EXPOSE 80
