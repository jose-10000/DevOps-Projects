FROM nginx:1.27.2-alpine

# Install curl and openssl for health checks and SSL certificate generation
RUN apk add --no-cache curl openssl

# Create SSL directory and generate self-signed certificate for testing
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=Test/L=Test/O=Test/OU=Test/CN=localhost" && \
    chmod 600 /etc/nginx/ssl/nginx.key && \
    chmod 644 /etc/nginx/ssl/nginx.crt

# Copy custom nginx configuration
COPY config/default.conf /etc/nginx/conf.d/default.conf

# Create web root directory and copy custom HTML content
RUN mkdir -p /var/www/html
COPY html/ /var/www/html/

# Create nginx user and set permissions
RUN chown -R nginx:nginx /var/www/html && \
    chmod -R 755 /var/www/html

# Expose ports 80 (redirect) and 443 (SSL)
EXPOSE 80 443

# Health check using HTTPS
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -k -f https://localhost/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
